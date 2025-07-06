// pages/cuisine_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/provider/user_data_provider.dart';

const kAllCuisines = [
  'Egyptian',
  'Italian',
  'Mexican',
  'Chinese',
  'Indian',
  'French',
  'American',
  'Japanese',
  'Greek',
  'Spanish',
];

class CuisinePage extends ConsumerWidget {
  const CuisinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCuisine = ref.watch(
      userDataProvider.select((u) => u.cuisine), // using `country` field
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Cuisine')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kAllCuisines.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final cuisine = kAllCuisines[i];
          final isSelected = cuisine == selectedCuisine;

          return ListTile(
            title: Text(cuisine),
            leading: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              // update the single selection
              ref.read(userDataProvider.notifier).setCountry(cuisine);
            },
          );
        },
      ),
    );
  }
}
