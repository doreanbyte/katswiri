import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

final class DioRequest {
  static Dio? _dio;

  static Dio getInstance({bool refresh = false}) {
    if (_dio == null || refresh) {
      final cacheStore = MemCacheStore(
        maxSize: 10485760,
        maxEntrySize: 1048576,
      );

      final cacheOptions = CacheOptions(
        maxStale: const Duration(minutes: 5),
        store: cacheStore,
        hitCacheOnErrorExcept: [],
        policy: refresh ? CachePolicy.refresh : CachePolicy.forceCache,
      );

      _dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(options: cacheOptions),
        );
    }

    return _dio!;
  }
}
