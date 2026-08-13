enum WhatsNewItemType { added, improved, fixed }

class WhatsNewItem {
  final WhatsNewItemType type;
  final String description;

  const WhatsNewItem(this.type, this.description);
}
