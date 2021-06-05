import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheNetworkImages {
  imageWidget(String url, String errorAssetURL,
      {double height, double width, BoxFit boxFit}) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: boxFit,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            strokeWidth: 1,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(errorAssetURL),
    );
  }
}
