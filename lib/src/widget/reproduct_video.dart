import 'package:chewie/chewie.dart';
import 'package:emart/src/controllers/controller_multimedia.dart';
import 'package:emart/src/modelos/multimedia.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReproductVideo extends StatefulWidget {
  final Multimedia multimedia;

  const ReproductVideo(this.multimedia);

  @override
  _ReproductVideoState createState() => _ReproductVideoState();
}

class _ReproductVideoState extends State<ReproductVideo> {
  late final playerWidget;
  late ChewieController _chewieController;

  ControllerMultimedia multimediaController = Get.find<ControllerMultimedia>();

  @override
  void initState() {
    multimediaController.setUrlMultimedia(widget.multimedia.link);
    _chewieController = ChewieController(
        videoPlayerController: multimediaController.controllerVideo,
        aspectRatio: widget.multimedia.orientacion == 'Horizontal'
            ? Get.size.height / Get.size.width
            : Get.size.width / Get.size.height,
        autoInitialize: false,
        autoPlay: false,
        looping: false,
        showControls: true,
        customControls: CupertinoControls(
          backgroundColor: Color.fromRGBO(75, 199, 147, 0.88),
          iconColor: Colors.white,
        ),
        placeholder: Container(
          color: Colors.black87,
          child: Container(
            child: Center(
                child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            )),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text('No se ha logrado cargar correctamente',
                style: TextStyle(color: Colors.white)),
          );
        });

    playerWidget = Chewie(
      controller: _chewieController,
    );
    //FIREBASE: Llamamos el evento VIEW_MULTI_MEDIA
    TagueoFirebase().sendAnalityticViewMultimedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          height: Get.height * 0.25,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.transparent,
          ),
          child: playerWidget),
    );
  }
}
