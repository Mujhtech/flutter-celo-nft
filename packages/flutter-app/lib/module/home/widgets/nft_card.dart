import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_celo_composer/module/home/models/nft_model.dart';

class NftCard extends StatelessWidget {
  const NftCard({
    required this.nft,
    super.key,
  });
  final NftModel nft;

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
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(nft.tokenUri ?? ''))),
            ),
          ),
          Text(
            '#${nft.tokenId}',
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
