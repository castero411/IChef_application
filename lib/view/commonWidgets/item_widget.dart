import 'package:flutter/material.dart';
import 'package:i_chef_application/view/text_styles.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'recipe');
      },
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 15),
        child: SizedBox(
          height: 90,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: Image(
                    image: AssetImage('assets/potato.jpg'),
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('item title', style: black20),
                      Text('item timer'),
                      Text('item ingredients'),
                    ],
                  ),
                ),
              ),
              Expanded(child: Icon(Icons.arrow_forward_ios_rounded)),
            ],
          ),
        ),
      ),
    );
  }
}
