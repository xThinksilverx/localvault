import 'package:shared_preferences/shared_preferences.dart';

class MigrationService {
  static const _keySchemaVersion = 'schema_version';
  static const _currentVersion = 1;

  Future<void> runMigrations() async {
    final prefs = await SharedPreferences.getInstance();
    final version = prefs.getInt(_keySchemaVersion) ?? 0;

    if (version < 1) {
      await _migrateToV1(prefs);
    }

    await prefs.setInt(_keySchemaVersion, _currentVersion);
  }

  Future<void> _migrateToV1(SharedPreferences prefs) async {
    if (!prefs.containsKey('language')) {
      await prefs.setString('language', 'pt');
    }
    if (!prefs.containsKey('notifications')) {
      await prefs.setBool('notifications', true);
    }
  }
}
