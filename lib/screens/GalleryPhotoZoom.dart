import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoZoom extends StatelessWidget {
  List<String> urlPhoto = [];

  GalleryPhotoZoom(this.urlPhoto);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(urlPhoto[index]),
                  initialScale: PhotoViewComputedScale.contained * 1,
                  minScale: PhotoViewComputedScale.contained * 1,
                  maxScale: PhotoViewComputedScale.covered * 2,
//              scaleStateChangedCallback: print("test"),
//              heroAttributes: PhotoViewHeroAttributes(tag: index),
                );
              },
              itemCount: urlPhoto.length,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes,
                  ),
                ),
              ),
            ),
            Positioned(
                right: 0,
                top: 50,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(right: 0),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50)),
                        width: 50,
                        height: 50,
                        child: Center(
                            child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ))),
                  ),
                ))
          ],
        ));
  }
}
