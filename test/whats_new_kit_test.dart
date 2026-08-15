import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:whats_new_kit/whats_new_kit.dart';

const releases = [
  WhatsNewRelease(
    id: 'v2',
    version: '1.1.0',
    title: 'What\'s New',
    items: [WhatsNewItem(WhatsNewItemType.added, 'Added a new feature.')],
  ),
  WhatsNewRelease(
    id: 'v1',
    version: '1.0.0',
    title: 'Welcome',
    items: [WhatsNewItem(WhatsNewItemType.added, 'Initial release.')],
  ),
];

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('WhatsNew.newerThan', () {
    test('returns all releases when lastSeenId is null', () async {
      await WhatsNew.initialize(releases: releases);

      expect(WhatsNew.newerThan(null), releases);
    });

    test('returns only releases newer than the last seen id', () async {
      await WhatsNew.initialize(releases: releases);

      final newer = WhatsNew.newerThan('v1');

      expect(newer.map((r) => r.id), ['v2']);
    });

    test('returns all releases when lastSeenId is unknown', () async {
      await WhatsNew.initialize(releases: releases);

      expect(WhatsNew.newerThan('unknown'), releases);
    });
  });

  group('WhatsNew.getLatestIfNeeded', () {
    test('returns the latest release when nothing has been seen', () async {
      await WhatsNew.initialize(releases: releases);

      final release = await WhatsNew.getLatestUnseenRelease();

      expect(release?.id, 'v2');
    });

    test('returns null when everything has been seen', () async {
      SharedPreferences.setMockInitialValues({
        'flutter_whats_new_last_seen_id': 'v2',
      });
      await WhatsNew.initialize(releases: releases);

      expect(await WhatsNew.getLatestUnseenRelease(), isNull);
    });

    test(
      'returns latest release in debug mode even when everything is seen',
      () async {
        SharedPreferences.setMockInitialValues({
          'flutter_whats_new_last_seen_id': 'v2',
        });
        await WhatsNew.initialize(releases: releases, debugMode: true);

        final release = await WhatsNew.getLatestUnseenRelease();

        expect(release?.id, 'v2');
      },
    );

    test('does not mark the release as seen', () async {
      await WhatsNew.initialize(releases: releases);

      await WhatsNew.getLatestUnseenRelease();

      expect(await WhatsNew.getLatestUnseenRelease(), isNotNull);
    });
  });

  group('WhatsNew.markAsSeen', () {
    test('marks the release as seen so it is no longer shown', () async {
      await WhatsNew.initialize(releases: releases);

      await WhatsNew.markAsSeen('v2');

      expect(await WhatsNew.getLatestUnseenRelease(), isNull);
    });

    test('is a no-op in debug mode', () async {
      await WhatsNew.initialize(releases: releases, debugMode: true);

      await WhatsNew.markAsSeen('v2');

      expect(await WhatsNew.getLatestUnseenRelease(), isNotNull);
    });
  });
}
