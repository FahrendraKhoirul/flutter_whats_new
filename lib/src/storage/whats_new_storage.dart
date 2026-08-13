import 'package:shared_preferences/shared_preferences.dart';

abstract class WhatsNewStorage {
  Future<String?> getLastSeenId();

  Future<void> saveLastSeenId(String id);
}

class SharedPreferencesWhatsNewStorage implements WhatsNewStorage {
  static const String lastSeenIdKey = 'flutter_whats_new_last_seen_id';
  final SharedPreferences _sharedPreferences;

  SharedPreferencesWhatsNewStorage(this._sharedPreferences);

  @override
  Future<String?> getLastSeenId() async {
    return _sharedPreferences.getString(lastSeenIdKey);
  }

  @override
  Future<void> saveLastSeenId(String id) async {
    await _sharedPreferences.setString(lastSeenIdKey, id);
  }
}
