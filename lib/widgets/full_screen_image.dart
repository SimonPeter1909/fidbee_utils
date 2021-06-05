import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  final String imageURL;
  final ImageProvider imageProvider;

  FullScreenImage({@required this.imageURL, this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: PhotoView(
        imageProvider: imageProvider ?? NetworkImage(imageURL),
        loadingBuilder: (context, load) => Center(
          child: CircularProgressIndicator(),
        ),
        loadFailedChild: Center(
          child: Text('Something went Wrong!'),
        ),
      )),
    );
  }
}
