import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:i_chef_application/constants/colors.dart';
import 'package:i_chef_application/routes.dart';
import 'package:i_chef_application/view/pages/introduction_page/introduction_page.dart';
import 'package:i_chef_application/view/pages/main_page/main_page.dart';
import 'package:i_chef_application/view/pages/search_result_page/search_result_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'iChef',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      home:
          user == null
              ? IntroductionPage()
              : MainPage(), // Replace with any widget you want
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
                (context) => const Scaffold(
                  body: Center(
                    child: Text('Invalid arguments for search result'),
                  ),
                ),
          );
        }
        return null;
      },
    );
  }
}
