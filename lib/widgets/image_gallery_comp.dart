import 'package:ecommerceapp/models/products.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGalleryComp extends StatelessWidget {
  final List<WooProductImage> images;
  final int currentPageIndex;

  const ImageGalleryComp(this.images, {Key key, this.currentPageIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: images.length,
      pageController: PageController(initialPage: currentPageIndex),
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(images[index].src),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        );
      },
      scrollPhysics: BouncingScrollPhysics(),
      backgroundDecoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
      ),
      loadingBuilder: (context, f) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
