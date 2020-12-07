import 'package:bikerr/models/document.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final Document doc;
  ImageViewer(this.doc);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doc.name)),
      body: Hero(
        tag: doc,
        child: Container(
            child: PhotoView(
          enableRotation: true,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
          imageProvider: CachedNetworkImageProvider(doc.url),
        )),
      ),
    );
  }
}
