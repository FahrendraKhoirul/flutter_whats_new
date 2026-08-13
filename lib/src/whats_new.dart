import 'package:flutter/material.dart';
import 'package:flutter_whats_new/src/models/whats_new_release.dart';
import 'package:flutter_whats_new/src/storage/whats_new_storage.dart';
import 'package:flutter_whats_new/src/widgets/whats_new_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WhatsNew {
  WhatsNew._();

  static late WhatsNewStorage _storage;
  static late List<WhatsNewRelease> _releases;
  static late bool _debugMode;

  static Future<void> initialize({
    required List<WhatsNewRelease> releases,
    bool debugMode = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    _releases = releases;
    _storage = SharedPreferencesWhatsNewStorage(prefs);
    _debugMode = debugMode;
  }

  static List<WhatsNewRelease> newerThan(String? lastSeenId) {
    if (lastSeenId == null) {
      return _releases;
    }

    final index = _releases.indexWhere((release) => release.id == lastSeenId);

    if (index == -1) {
      return _releases;
    }

    return _releases.sublist(0, index);
  }

  static Future<void> showIfNeeded(BuildContext context) async {
    final lastSeenId = await _storage.getLastSeenId();

    if (!context.mounted) {
      return;
    }

    final newReleases = newerThan(lastSeenId);

    if (newReleases.isEmpty && !_debugMode) {
      return;
    }

    final release = newReleases.isNotEmpty
        ? newReleases.first
        : _releases.first;

    await showDialog(
      context: context,
      builder: (_) {
        return WhatsNewDialog(release: release);
      },
    );

    if (!_debugMode) {
      await _storage.saveLastSeenId(release.id);
    }
  }
}
