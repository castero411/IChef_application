// widgets/selectable_list_card.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/view/text_styles.dart';

class SelectableListCard extends StatelessWidget {
  const SelectableListCard({
    super.key,
    required this.title,
    required this.items,
    required this.selected,
    required this.onToggle,
  });

  final String title;
  final List<String> items;
  final List<String> selected;
  final void Function(String item, bool isSelected) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: black20.copyWith(fontSize: 19)),
          const Gap(20),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (final item in items) ...[
                  _Tile(
                    name: item,
                    selected: selected.contains(item),
                    onTap: () => onToggle(item, !selected.contains(item)),
                  ),
                  if (item != items.last)
                    const Divider(height: 1, thickness: .5),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Icon(
        selected ? Icons.check_box : Icons.check_box_outline_blank,
        color: primary,
      ),
      dense: true,
      onTap: onTap,
    );
  }
}
