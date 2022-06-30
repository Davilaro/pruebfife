import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ControllerMultimedia extends GetxController {
  late VideoPlayerController controllerVideo;
  RxString urlMultimedia = ''.obs;

  void setUrlMultimedia(String value) {
    urlMultimedia.value = value;
    initControllerMultimedia();
  }

  void initControllerMultimedia() {
    controllerVideo = VideoPlayerController.network('${urlMultimedia.value}')
      ..initialize();
  }
}
