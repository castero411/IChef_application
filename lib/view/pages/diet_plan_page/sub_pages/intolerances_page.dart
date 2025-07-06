// pages/intolerances_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/provider/user_data_provider.dart';
import 'package:i_chef_application/view/commonWidgets/selector.dart';

const kAllIntolerances = [
  'Lactose Intolerance',
  'Gluten Sensitivity',
  'Histamine Sensitivity',
  'Fructose Intolerance',
  'Caffeine Sensitivity',
  'Food Additives',
];

class IntolerancesPage extends ConsumerWidget {
  const IntolerancesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(userDataProvider.select((u) => u.intolerances));

    return SelectableListCard(
      title: 'Add your Intolerances',
      items: kAllIntolerances,
      selected: selected,
      onToggle: (item, isSelected) {
        final notifier = ref.read(userDataProvider.notifier);
        isSelected
            ? notifier.addIntolerance(item)
            : notifier.removeIntolerance(item);
      },
    );
  }
}
