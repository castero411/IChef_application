import 'package:flutter/material.dart';
import 'package:i_chef_application/view/pages/ai_chat_page/ai_chat_page.dart';
import 'package:i_chef_application/view/pages/diet_plan_page/diet_plan_page.dart';

import 'package:i_chef_application/view/pages/introduction_page/introduction_page.dart';
import 'package:i_chef_application/view/pages/landing_page/landing_page.dart';
import 'package:i_chef_application/view/pages/login_page/login_page.dart';
import 'package:i_chef_application/view/pages/main_page/main_page.dart';
import 'package:i_chef_application/view/pages/plan_meal_page/plan_meal_page.dart';

import 'package:i_chef_application/view/pages/settings_page/settings_page.dart';
import 'package:i_chef_application/view/pages/setup_account_page.dart/setup_account_page.dart';
import 'package:i_chef_application/view/pages/sign_up_page/sign_up_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  'landing': (context) => LandingPage(),
  'login': (context) => LoginPage(),
  'signup': (context) => SignUpPage(),
  'home': (context) => MainPage(),
  'introduction': (context) => IntroductionPage(),
  'settings': (context) => SettingsPage(),

  'setup_account': (context) => SetupAccountPage(),
  'chat': (context) => AiChatPage(),
  'diet': (context) => DietPlanPage(),
};
