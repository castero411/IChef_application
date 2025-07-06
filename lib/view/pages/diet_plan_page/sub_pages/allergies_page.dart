import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/provider/user_data_provider.dart';
import 'package:i_chef_application/view/commonWidgets/selector.dart';

/// Master list of allergens shown in the UI
const kAllAllergies = [
  'Milk',
  'Eggs',
  'Peanuts',
  'Treenuts',
  'Wheat',
  'Soy',
  'Fish',
  'Shellfish',
  'Sesame',
];

class AllergiesPage extends ConsumerWidget {
  const AllergiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(userDataProvider.select((u) => u.allergies));

    return SelectableListCard(
      title: 'Add your Allergies',
      items: kAllAllergies,
      selected: selected,
      onToggle: (item, isSelected) {
        final notifier = ref.read(userDataProvider.notifier);
        isSelected ? notifier.addAllergy(item) : notifier.removeAllergy(item);
      },
    );
  }
}
