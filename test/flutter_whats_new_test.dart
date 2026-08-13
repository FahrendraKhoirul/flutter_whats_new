import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_whats_new/flutter_whats_new.dart';

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
}
