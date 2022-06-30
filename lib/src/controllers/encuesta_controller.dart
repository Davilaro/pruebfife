import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EncuestaControllers extends GetxController {
  RxBool isVisibleEncuesta = true.obs;
  late FocusNode focusEncuesta;

  void setIsVisibleEncuesta(bool val) {
    isVisibleEncuesta.value = val;
  }
}
