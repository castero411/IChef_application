import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  void _onIntroEnd(context) {
    Navigator.pushReplacementNamed(context, 'landing'); // go to next screen
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 16.0),
      imagePadding: EdgeInsets.only(top: 40),
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Receive recipes based on your taste",
          body: "Personalized recommendations to fit your preferences.",
          image: Image.asset("assets/onboarding1.png", height: 250),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Improve together with your assistant",
          body: "Chat with iChef and get smarter every day.",
          image: Image.asset("assets/onboarding2.png", height: 250),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Cook your recipes with iChef",
          body: "Follow voice-guided steps easily and confidently.",
          image: Image.asset("assets/onboarding3.png", height: 250),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.deepOrange,
        color: Colors.black26,
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
