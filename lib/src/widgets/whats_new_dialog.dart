import 'package:flutter/material.dart';
import 'package:flutter_whats_new/src/models/whats_new_release.dart';

class WhatsNewDialog extends StatelessWidget {
  final WhatsNewRelease release;

  const WhatsNewDialog({super.key, required this.release});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(release.title),
      content: Text(release.version),
    );
  }
}
