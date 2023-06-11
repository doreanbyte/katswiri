import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

final class PrefsManager {
  const PrefsManager._();

  static const instance = PrefsManager._();
  static final _lock = Lock();
  static SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;

    await _lock.synchronized(() async {
      _prefs = await SharedPreferences.getInstance();
    });

    return _prefs!;
  }
}
