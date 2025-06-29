import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/view/commonWidgets/action_button.dart';
import 'package:i_chef_application/view/commonWidgets/logo_container.dart';
import 'package:i_chef_application/view/text_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.sizeOf(context).width, height: 100),
          logoWithBackground,
          Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('I', style: main30.copyWith(color: secondaryColor)),
              Text('Chef', style: main30),
            ],
          ),
          Text('Your assistant to a helathy life', style: secondary20),
          SizedBox(height: 350),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                ActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  text: 'Log in',
                  height: 44,
                ),
                Gap(20),
                ActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'signup');
                  },
                  text: 'Sign up',
                  height: 44,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
