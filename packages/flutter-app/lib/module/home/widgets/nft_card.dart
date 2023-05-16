import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NftCard extends StatelessWidget {
  const NftCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: const Color(0xFFFCFF52).withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
                color: Colors.black.withOpacity(0.04))
          ]),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: CachedNetworkImageProvider(
                          'https://i.seadn.io/s/primary-drops/0xa76699ffc87188a3487ddf0c53e3748aef7f4c91/25274694:about:preview_media:65b9a4ad-b4fb-4542-a48a-20d458d72d15.png?auto=format&dpr=1&w=3840'))),
            ),
          ),
          Text(
            '#1',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }
}
