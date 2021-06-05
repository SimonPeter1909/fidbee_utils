import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';

import '../fidbee_utils.dart';

class DownLoadImg {
  static Future<File> fileImage(String image) async {
    try {
      FidbeeUtils.logD('img - $image');
      var imageId = await ImageDownloader.downloadImage(image);
      var path = await ImageDownloader.findPath(imageId);
      return File(path);
    } catch (e) {
      FidbeeUtils.logD('Error - $e');
      return null;
    }

  }
}
