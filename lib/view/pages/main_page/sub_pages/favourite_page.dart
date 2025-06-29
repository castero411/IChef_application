import 'package:flutter/material.dart';
import 'package:i_chef_application/view/commonWidgets/item_widget.dart';
import 'package:i_chef_application/view/text_styles.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite', style: secondarytitle25)),
      body: SingleChildScrollView(
        child: Column(
          children: [ItemWidget(), ItemWidget(), ItemWidget(), ItemWidget()],
        ),
      ),
    );
  }
}
