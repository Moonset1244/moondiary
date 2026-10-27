import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:moodiary_http/moodiary_http.dart';
import 'package:moodiary_models/moodiary_models.dart';
import 'package:moodiary_storage/moodiary_storage.dart';

@lazySingleton
class LlmPresetRepository {
  LlmPresetRepository(this._http);

  final IHttpClient _http;

  static const String _apiUrl = 'https://models.dev/api.json';

  static const Duration _timeout = Duration(seconds: 15);

  int get cachedAt => MoodiaryKVs.llmPresetCacheAt.get() ?? 0;

  Future<List<LlmProviderPreset>> load() async {
    final cached = cachedPresets();
    if (cached.isNotEmpty) return cached;
    return refresh();
  }

  List<LlmProviderPreset> cachedPresets() {
    final cached = MoodiaryKVs.llmPresetCache.get() ?? '';
    if (cached.isEmpty) return const [];
    try {
      return _decodeCache(cached);
    } catch (_) {
      return const [];
    }
  }

  Future<List<LlmProviderPreset>>? _inFlight;

  Future<List<LlmProviderPreset>> refresh() {
    final running = _inFlight;
    if (running != null) return running;
    final future = _refresh().whenComplete(() => _inFlight = null);
    _inFlight = future;
    return future;
  }

  Future<List<LlmProviderPreset>> _refresh() async {
    final body = await _fetchBody();
    final normalized = await compute(_normalize, body);
    MoodiaryKVs.llmPresetCache.set(normalized);
    MoodiaryKVs.llmPresetCacheAt.set(DateTime.now().millisecondsSinceEpoch);
    return _decodeCache(normalized);
  }

  Future<String> _fetchBody() async {
    final res = await _http.get<String>(
      _apiUrl,
      timeout: _timeout,
      silent: true,
      plainText: true,
    );
    final data = res.data;
    if (data == null || data.isEmpty) {
      throw StateError('empty response from $_apiUrl');
    }
    return data;
  }

  List<LlmProviderPreset> _decodeCache(String s) {
    final list = jsonDecode(s);
    if (list is! List) throw const FormatException('invalid preset cache');
    return [
      for (final item in list)
        if (item is Map)
          LlmProviderPreset.fromJson(item.cast<String, dynamic>()),
    ];
  }
}

String _normalize(String body) {
  return jsonEncode(
    parseModelsDevCatalog(body).map((e) => e.toJson()).toList(),
  );
}

List<LlmProviderPreset> parseModelsDevCatalog(String body) {
  final root = jsonDecode(body);
  if (root is! Map) {
    throw const FormatException('invalid models.dev api.json root');
  }
  final result = <LlmProviderPreset>[];
  root.forEach((id, value) {
    if (id is String && value is Map) {
      if (!_providerAllowlist.contains(id.toLowerCase())) return;
      final preset = LlmProviderPreset.fromModelsDev(
        id,
        value.cast<String, dynamic>(),
      );
      if (preset != null) result.add(preset);
    }
  });
  // 白名单若没匹配到（models.dev 改 id），退回全量，避免列表为空
  if (result.isEmpty) {
    root.forEach((id, value) {
      if (id is String && value is Map) {
        final preset = LlmProviderPreset.fromModelsDev(
          id,
          value.cast<String, dynamic>(),
        );
        if (preset != null) result.add(preset);
      }
    });
  }
  result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return result;
}

// 只保留主流提供商（国外常用 + 国内常用），过滤 models.dev 里国内用不上的小众服务
const Set<String> _providerAllowlist = {
  'openai',
  'anthropic',
  'google',
  'openrouter',
  'deepseek',
  'zhipuai',
  'moonshot',
  'qwen',
  'xai',
  'mistral',
  'groq',
  'perplexity',
};
