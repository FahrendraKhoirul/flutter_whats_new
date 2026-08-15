import 'package:flutter/material.dart';
import 'package:flutter_whats_new/src/models/whats_new_item.dart';
import 'package:flutter_whats_new/src/models/whats_new_release.dart';

/// Visual identity (label, icon, color) for each [WhatsNewItemType].
class _WhatsNewItemTypeStyle {
  final String label;
  final IconData icon;
  final Color color;

  const _WhatsNewItemTypeStyle({
    required this.label,
    required this.icon,
    required this.color,
  });
}

_WhatsNewItemTypeStyle _styleFor(WhatsNewItemType type) {
  return switch (type) {
    WhatsNewItemType.added => _WhatsNewItemTypeStyle(
      label: 'Added',
      icon: Icons.add_circle_outline,
      color: Colors.green.shade600,
    ),
    WhatsNewItemType.improved => _WhatsNewItemTypeStyle(
      label: 'Improved',
      icon: Icons.auto_awesome_outlined,
      color: Colors.blue.shade600,
    ),
    WhatsNewItemType.fixed => _WhatsNewItemTypeStyle(
      label: 'Fixed',
      icon: Icons.build_outlined,
      color: Colors.orange.shade700,
    ),
  };
}

class WhatsNewDialog extends StatelessWidget {
  final WhatsNewRelease release;

  const WhatsNewDialog({super.key, required this.release});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(release.title),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _WhatsNewReleaseMeta(release: release),
              const SizedBox(height: 20),
              ...release.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _WhatsNewItemTile(item: item),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}

class _WhatsNewReleaseMeta extends StatelessWidget {
  final WhatsNewRelease release;

  const _WhatsNewReleaseMeta({required this.release});

  @override
  Widget build(BuildContext context) {
    final metadata = [
      'v${release.version}',
      if (release.build != null) release.build!,
      if (release.date != null) release.date!,
    ];

    return Text(
      metadata.join(' · '),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _WhatsNewItemTile extends StatelessWidget {
  final WhatsNewItem item;

  const _WhatsNewItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = _styleFor(item.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: style.color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(style.icon, size: 18, color: style.color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                style.label,
                style: TextStyle(
                  color: style.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
