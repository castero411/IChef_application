import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget({
    super.key,
    required this.image,
    required this.itemName,
    required this.time,
    required this.onTap,
    required this.onFavourite,
    required this.isFavourite,
  });

  final ImageProvider<Object> image;
  final String itemName;
  final String time;
  final Function() onTap;
  final Function() onFavourite;
  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image(
                  image: image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(4),
                          Row(
                            children: [
                              const Icon(
                                Icons.fastfood,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const Gap(4),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    IconButton(
                      onPressed: onFavourite,
                      icon: const Icon(Icons.favorite_border_rounded),
                      iconSize: 30,
                      color:
                          isFavourite ? Colors.redAccent : Colors.grey.shade600,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
