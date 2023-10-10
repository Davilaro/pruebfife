// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

class DialogDetailsImage extends StatefulWidget {
  String image;
  String title;
  DialogDetailsImage(this.image, this.title, {Key? key}) : super(key: key);

  @override
  _DialogDetailsImageState createState() => _DialogDetailsImageState();
}

class _DialogDetailsImageState extends State<DialogDetailsImage> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        hasLeftButton: false,
        hasRightButton: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, color: Colors.red, size: 30)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        content: Expanded(
          child: Center(
            child: Container(
              child: PinchZoomImage(
                image: CachedNetworkImage(
                    imageUrl: widget.image,
                    placeholder: (context, url) =>
                        Image.asset('assets/image/jar-loading.gif'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/image/logo_login.png'),
                    fit: BoxFit.contain),
                zoomedBackgroundColor: Colors.white,
                hideStatusBarWhileZooming: true,
                onZoomStart: () {
                  print('Zoom started');
                },
                onZoomEnd: () {
                  print('Zoom finished');
                },
              ),
            ),
          ),
        ));
  }
}
