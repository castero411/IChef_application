import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/provider/user_data_provider.dart';
import 'package:i_chef_application/view/pages/diet_plan_page/sub_pages/allergies_page.dart';
import 'package:i_chef_application/view/pages/diet_plan_page/sub_pages/cuisines_page.dart';
import 'package:i_chef_application/view/pages/diet_plan_page/sub_pages/intolerances_page.dart';
import 'package:i_chef_application/view/text_styles.dart';

// ignore: must_be_immutable
class DietPlanPage extends ConsumerWidget {
  DietPlanPage({super.key});

  List<Widget> pages = [AllergiesPage(), IntolerancesPage(), CuisinePage()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int index = ref.watch(currentIndex);

    return Scaffold(
      bottomNavigationBar: SizedBox(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (index == 0)
                const SizedBox()
              else
                Button(
                  width: 50,
                  color: Colors.grey.withAlpha(100),
                  onTap: () {
                    ref.read(currentIndex.notifier).update((old) => old - 1);
                  },
                  child: Icon(Icons.arrow_back_ios_outlined),
                ),

              Button(
                onTap: () async {
                  if (index == 2) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      'home',
                      (route) => false,
                    );
                    await ref
                        .read(userDataProvider.notifier)
                        .createUserInFirebase();
                  } else {
                    ref.read(currentIndex.notifier).state = index + 1;
                  }
                },
                child: Text('next', style: white20),
              ),
            ],
          ),
        ),
      ),
      body: pages[index],

      appBar: AppBar(
        title: Center(
          child: Text(
            "Setup Your Profile",
            style: secondary20.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
    );
  }
}

final currentIndex = StateProvider<int>((ref) => 0);

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onTap,
    this.color = mainColor,
    required this.child,
    this.width = 100,
  });
  final Function() onTap;
  final Color color;
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(onTap: onTap, child: Center(child: child)),
    );
  }
}
