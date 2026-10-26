import 'package:latlong2/latlong.dart';
import 'package:moodiary_data/moodiary_data.dart';
import 'package:moodiary_di/moodiary_di.dart';
import 'package:moodiary_editor/src/data/geo_repository.dart';
import 'package:moodiary_editor/src/data/weather_repository.dart';
import 'package:moodiary_models/moodiary_models.dart';
import 'package:moodiary_storage/moodiary_storage.dart';
import 'package:mui/mui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_controller.g.dart';

enum DraftSaveResult { saved, failed }

typedef PlaceResult = ({Place? place, GeoFailure? failure});

@riverpod
class EditController extends _$EditController {
  late final _repository = getIt<DiaryRepository>();

  bool _persisted = false;

  bool _wasNewDraft = false;

  String? _indexedContent;

  String? _indexedTitle;

  Diary? _latest;

  Future<DraftSaveResult>? _inFlight;

  @override
  FutureOr<Diary> build(
    String? diaryId, {
    DiaryType? defaultType,
    String? defaultCategoryId,
    List<String>? defaultTags,
  }) async {
    final diary = await ref.watch(
      getDiaryProvider(
        id: diaryId,
        defaultType: defaultType,
        defaultCategoryId: defaultCategoryId,
        defaultTags: defaultTags,
      ).future,
    );
    if (diary == null) throw StateError('Diary not found: $diaryId');
    _persisted = !(diaryId == null || diaryId.isEmpty);
    _wasNewDraft = !_persisted;
    _latest = diary;
    _indexedContent = diary.contentText;
    _indexedTitle = diary.title;
    listenSelf((_, next) {
      final value = next.value;
      if (value != null) _latest = value;
    });
    return diary;
  }

  // time 是绝对时刻（新建为 UTC、库读为本地），取墙钟分量前必须 toLocal。
  void changeDate(DateTime date) {
    state = state.whenData((current) {
      final t = current.time.toLocal();
      return current.copyWith(
        time: DateTime(
          date.year,
          date.month,
          date.day,
          t.hour,
          t.minute,
          t.second,
          t.millisecond,
          t.microsecond,
        ),
      );
    });
  }

  void changeTime(TimeOfDay time) {
    state = state.whenData((current) {
      final t = current.time.toLocal();
      return current.copyWith(
        time: DateTime(t.year, t.month, t.day, time.hour, time.minute),
      );
    });
  }

  void changeTitle(String title) {
    state = state.whenData((current) => current.copyWith(title: title));
  }

  void changeContent(String content, {String? contentText}) {
    state = state.whenData(
      (current) => current.copyWith(
        content: content,
        contentText: contentText ?? content,
      ),
    );
  }

  void changeType(DiaryType type) {
    state = state.whenData((current) => current.copyWith(type: type.value));
  }

  void changeMood(DiaryMood mood) {
    state = state.whenData((current) => current.copyWith(mood: mood));
  }

  void changeCategory(String? categoryId) {
    state = state.whenData(
      (current) => current.copyWith(categoryId: categoryId),
    );
  }

  void changeTags(List<String> tags) {
    state = state.whenData((current) => current.copyWith(tags: tags));
  }

  void changePlace(String? placeId) {
    state = state.whenData((current) => current.copyWith(placeId: placeId));
  }

  void changeWeather(DiaryWeather? weather) {
    state = state.whenData((current) => current.copyWith(weather: weather));
  }

  Future<CoordinatesResult> locate() =>
      getIt<GeoRepository>().currentCoordinates();

  Future<PlaceResult> fetchPosition(
    BuildContext context, {
    LatLng? coords,
    bool onlyIfUnset = false,
  }) async {
    try {
      final geo = await getIt<GeoRepository>().getGeo(context, coords: coords);
      final name = geo.name;
      final at = geo.coords;
      if (name == null || at == null) {
        return (place: null, failure: geo.failure);
      }
      final places = getIt<PlaceRepository>();
      var place =
          await places.getPlaceById(Place.idForName(name)) ??
          await places.getPlaceByName(name);
      if (place == null) {
        place = Place.forName(
          name,
          latitude: at.latitude,
          longitude: at.longitude,
        );
        await places.insertAPlace(place);
      }
      if (!onlyIfUnset || state.value?.placeId == null) changePlace(place.id);
      return (place: place, failure: null);
    } catch (_) {
      return (place: null, failure: GeoFailure.lookupFailed);
    }
  }

  Future<WeatherResult> fetchWeather(
    BuildContext context, {
    LatLng? coords,
    bool onlyIfUnset = false,
  }) async {
    try {
      var at = coords;
      if (at == null) {
        final located = await getIt<GeoRepository>().currentCoordinates();
        at = located.coords;
        if (at == null) return (weather: null, failure: located.failure);
      }
      if (!context.mounted) {
        return (weather: null, failure: GeoFailure.lookupFailed);
      }
      final result = await getIt<WeatherRepository>().getWeather(
        context: context,
        coords: at,
      );
      final weather = result.weather;
      if (weather != null && (!onlyIfUnset || state.value?.weather == null)) {
        changeWeather(weather);
      }
      return result;
    } catch (_) {
      return (weather: null, failure: GeoFailure.lookupFailed);
    }
  }

  Future<DraftSaveResult> autoSave() async {
    while (_inFlight != null) {
      await _inFlight;
    }
    final future = _doAutoSave();
    _inFlight = future;
    try {
      return await future;
    } finally {
      if (identical(_inFlight, future)) _inFlight = null;
    }
  }

  Future<DraftSaveResult> _doAutoSave() async {
    final current = _latest;
    if (current == null) return .saved;
    var next = touched(withDerivedMedia(current));
    final autoTitle = _generateAutoTitle(next);
    if (next.title.trim().isEmpty && autoTitle != null) {
      next = next.copyWith(title: autoTitle);
    }
    if (_wasNewDraft && _isBlank(next)) {
      try {
        if (_persisted) {
          await _repository.hardDeleteDiary(next.id);
          _persisted = false;
        }
        _indexedContent = next.contentText;
        _indexedTitle = next.title;
        _latest = next;
        if (ref.mounted) {
          state = .data(next);
        }
        return .saved;
      } catch (_) {
        return .failed;
      }
    }
    final indexMode =
        next.contentText == _indexedContent && next.title == _indexedTitle
        ? IndexMode.skip
        : IndexMode.inline;
    try {
      if (_persisted) {
        await _repository.updateADiary(newDiary: next, index: indexMode);
      } else {
        await _repository.insertADiary(next);
        _persisted = true;
      }
      _indexedContent = next.contentText;
      _indexedTitle = next.title;
      _latest = next;
      if (ref.mounted) {
        state = .data(next);
      }
      return .saved;
    } catch (_) {
      return .failed;
    }
  }

  bool _isBlank(Diary d) =>
      d.title.trim().isEmpty &&
      d.contentText.trim().isEmpty &&
      d.imageName.isEmpty &&
      d.audioName.isEmpty &&
      d.videoName.isEmpty &&
      d.fileName.isEmpty;

  // 自动标题：0 关闭 / 1 正文首句 / 2 日期时间 / 3 自定义模板
  String? _generateAutoTitle(Diary d) {
    final mode = MoodiaryKVs.autoTitleMode.get() ?? 0;
    switch (mode) {
      case 0:
        return null;
      case 1:
        return _firstSentence(d.contentText);
      case 2:
        return _fmtDateTime(d.time.toLocal());
      case 3:
        return _applyTemplate(d);
      default:
        return null;
    }
  }

  String? _firstSentence(String contentText) {
    final text = contentText.trim();
    if (text.isEmpty) return null;
    final first = text.split(RegExp(r'[。！？!?.\n]')).first.trim();
    if (first.isEmpty) return null;
    return first.length > 40 ? '${first.substring(0, 40)}…' : first;
  }

  String _fmtDateTime(DateTime t) {
    String p(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${p(t.month)}-${p(t.day)} '
        '${p(t.hour)}:${p(t.minute)}:${p(t.second)}';
  }

  String _applyTemplate(Diary d) {
    final t = d.time.toLocal();
    String p(int n) => n.toString().padLeft(2, '0');
    final first = _firstSentence(d.contentText) ?? '';
    final tpl = MoodiaryKVs.autoTitleTemplate.get() ?? 'yyyy-MM-dd HH:mm:ss';
    return tpl
        .replaceAll('yyyy', '${t.year}')
        .replaceAll('MM', p(t.month))
        .replaceAll('dd', p(t.day))
        .replaceAll('HH', p(t.hour))
        .replaceAll('mm', p(t.minute))
        .replaceAll('ss', p(t.second))
        .replaceAll('{first}', first)
        .replaceAll('{title}', d.title);
  }
}
