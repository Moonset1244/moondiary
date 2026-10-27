import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:moodiary_editor/src/data/geo_repository.dart';
import 'package:moodiary_editor/src/data/model/weather.dart';
import 'package:moodiary_editor/src/data/qweather_config.dart';
import 'package:moodiary_http/moodiary_http.dart';
import 'package:moodiary_models/moodiary_models.dart';
import 'package:mui/mui.dart';

typedef WeatherResult = ({DiaryWeather? weather, GeoFailure? failure});

@lazySingleton
class WeatherRepository {
  WeatherRepository(this._http);

  final IHttpClient _http;

  Future<WeatherResult> getWeather({
    required BuildContext context,
    required LatLng coords,
  }) async {
    final credentials = await qweatherCredentials();
    if (credentials != null && context.mounted) {
      try {
        final local = Localizations.localeOf(context);
        final res = await _http.get(
          'https://${credentials.host}/v7/weather/now',
          query: {
            'location': qweatherLocation(coords),
            'key': credentials.key,
            'lang': local,
          },
        );
        final weather = await compute(
          WeatherResponse.fromJson,
          res.data as Map<String, dynamic>,
        );
        final now = weather.now;
        if (now?.icon != null && now?.text != null) {
          return (
            weather: DiaryWeather(
              icon: now!.icon!,
              temp: now.temp,
              text: now.text!,
            ),
            failure: null,
          );
        }
      } catch (_) {
        // 和风失败则走免 key 兜底
      }
    }
    return _openMeteoWeather(coords);
  }

  /// 免 key 兜底：Open-Meteo（全球免费，无需注册）。
  Future<WeatherResult> _openMeteoWeather(LatLng coords) async {
    try {
      final res = await _http.get(
        'https://api.open-meteo.com/v1/forecast',
        query: {
          'latitude': '${coords.latitude}',
          'longitude': '${coords.longitude}',
          'current': 'temperature_2m,weather_code',
        },
      );
      final data = res.data;
      final current = data is Map ? data['current'] : null;
      if (current is! Map) {
        return (weather: null, failure: GeoFailure.lookupFailed);
      }
      final code = (current['weather_code'] as num?)?.toInt() ?? -1;
      final temp = (current['temperature_2m'] as num?)?.round();
      final (icon, text) = _openMeteoText(code);
      return (
        weather: DiaryWeather(
          icon: icon,
          temp: temp?.toString(),
          text: text,
        ),
        failure: null,
      );
    } catch (_) {
      return (weather: null, failure: GeoFailure.lookupFailed);
    }
  }

  static (String, String) _openMeteoText(int code) => switch (code) {
    0 => ('100', '晴'),
    1 => ('101', '多云'),
    2 => ('102', '多云'),
    3 => ('104', '阴'),
    45 || 48 => ('501', '雾'),
    51 || 53 || 55 || 56 || 57 => ('305', '毛毛雨'),
    61 || 66 => ('305', '小雨'),
    63 => ('306', '中雨'),
    65 || 67 => ('307', '大雨'),
    71 || 73 || 77 => ('400', '雪'),
    75 => ('402', '大雪'),
    80 || 81 => ('300', '阵雨'),
    82 => ('307', '强阵雨'),
    85 || 86 => ('400', '阵雪'),
    95 || 96 || 99 => ('302', '雷阵雨'),
    _ => ('104', '阴'),
  };
}
