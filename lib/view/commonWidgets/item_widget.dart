import 'package:flutter/material.dart';
import 'package:i_chef_application/view/text_styles.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.title,
    required this.image,
    required this.calories,
    required this.onTap,
  });

  final String title;
  final String image;
  final String calories;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                    image: NetworkImage(image),
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
                      Text(
                        title,
                        style: black20.copyWith(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text("calories :$calories"),
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
