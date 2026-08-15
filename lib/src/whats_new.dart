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

  /// Returns the latest release the user hasn't seen yet, without marking it
  /// as seen. Returns `null` when there is nothing to show.
  ///
  /// Use this for a custom UI. When the developer is done showing the release,
  /// call [markAsSeen] explicitly.
  static Future<WhatsNewRelease?> getLatestUnseenRelease() async {
    final lastSeenId = await _storage.getLastSeenId();

    final newReleases = newerThan(lastSeenId);

    if (newReleases.isEmpty && !_debugMode) {
      return null;
    }

    return newReleases.isNotEmpty ? newReleases.first : _releases.first;
  }

  /// Marks the release with [id] as seen, so it won't be shown again.
  /// No-op in debug mode.
  static Future<void> markAsSeen(String id) async {
    if (_debugMode) {
      return;
    }

    await _storage.saveLastSeenId(id);
  }

  static Future<void> showIfNeeded(BuildContext context) async {
    final release = await getLatestUnseenRelease();

    if (!context.mounted || release == null) {
      return;
    }

    await showDialog(
      context: context,
      builder: (_) {
        return WhatsNewDialog(release: release);
      },
    );

    await markAsSeen(release.id);
  }
}
