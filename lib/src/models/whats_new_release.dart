import 'package:whats_new_kit/src/models/whats_new_item.dart';

class WhatsNewRelease {
  final String id;
  final String version;
  final String? build;
  final String title;
  final String? date;
  final List<WhatsNewItem> items;

  const WhatsNewRelease({
    required this.id,
    required this.version,
    this.build,
    required this.title,
    this.date,
    required this.items,
  });
}
