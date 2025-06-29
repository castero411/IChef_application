import 'package:flutter/material.dart';
import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/routes.dart';
import 'package:i_chef_application/view/pages/introduction_page/introduction_page.dart';
import 'package:i_chef_application/view/pages/landing_page/landing_page.dart';
import 'package:i_chef_application/view/pages/login_page/login_page.dart';
import 'package:i_chef_application/view/pages/main_page/main_page.dart';
import 'package:i_chef_application/view/pages/search_result_page/search_result_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ichef',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      home: MainPage(),
      routes: appRoutes,
      onGenerateRoute: (settings) {
        if (settings.name == 'search result') {
          final args = settings.arguments;
          if (args is String) {
            return MaterialPageRoute(
              builder: (context) => SearchResultsPage(query: args),
            );
          }
          return MaterialPageRoute(
            builder:
                (context) => Scaffold(
                  body: Center(
                    child: Text('Invalid arguments for search result'),
                  ),
                ),
          );
        }
      },
    );
  }
}
