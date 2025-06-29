import 'package:flutter/material.dart';
import 'package:i_chef_application/view/text_styles.dart';

class GeneratePage extends StatelessWidget {
  const GeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate', style: secondarytitle25)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: Center(
                child: Text(
                  'Generate meals\n from diffrenct quisines',
                  textAlign: TextAlign.center,
                  style: black20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: SizedBox(child: Row(children: [])),
            ),
          ],
        ),
      ),
    );
  }
}
