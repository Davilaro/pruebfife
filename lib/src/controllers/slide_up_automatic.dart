import 'dart:async';
import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/service/notification_push_in_app_slide_up_service.dart';
import 'package:emart/_pideky/infrastructure/notification_push_in_app_slide_up/notification_push_in_app_slide_up_sql.dart';
import 'package:emart/shared/widgets/automatic_card_notifiaction_slide_up.dart';
import 'package:get/get.dart';

class SlideUpAutomatic extends GetxController {
  final slideUpService =
      NotificationPushInAppSlideUpService(NotificationPushInUpAndSlideUpSql());
  RxList automaticSlideUpList = [].obs;
  RxList automaticSlideUpSelected = [].obs;
  RxList listaProductosCarrito = [].obs;
  Timer? _timer;
  RxInt counter = 0.obs;
  Timer? get timer => _timer;

  Future getAutomaticSlideUp() async {
    automaticSlideUpList.value = await slideUpService.getAutomaticSlideUp();
  }

  bool selectSlideUpAutomatic(negocio) {
    if (automaticSlideUpList.isNotEmpty) {
      for (var element in automaticSlideUpList) {
        if (element.negocio == negocio) {
          automaticSlideUpSelected.assign(element);
          return true;
        }
      }
    }
    return false;
  }

  void mostrarSlide(negocio) async {
    final requestSeeSlideUp =
        await slideUpService.showSlideUpValidation(negocio);
    if (requestSeeSlideUp == 1) {
      if (automaticSlideUpList.isNotEmpty) {
        if (selectSlideUpAutomatic(negocio)) {
          iniciarTimer(negocio);
        }
      }
    }
  }

  void iniciarTimer(negocio) {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: automaticSlideUpSelected[0].tiempo ?? 60),
        () async {
      if (Get.isSnackbarOpen) {
        await Get.closeCurrentSnackbar();
      }
      showSlideUpNotificationAutomatic(automaticSlideUpSelected[0]);
      await slideUpService.sendShowedSlideUp(negocio);

      _timer?.cancel();
    });
  }

  void validarMostrarSlide() async {
    RxString negocio = ''.obs;

    if (listaProductosCarrito.isNotEmpty && automaticSlideUpList.isNotEmpty) {
      listaProductosCarrito.forEach((producto) {
        for (var element in automaticSlideUpList) {
          if (element.negocio == producto.negocio) {
            negocio.value = element.negocio;
            automaticSlideUpSelected.assign(element);
            break;
          }
        }
      });
      final requestSeeSlideUp =
          await slideUpService.showSlideUpValidation(negocio.value);
      if (automaticSlideUpSelected.isNotEmpty && requestSeeSlideUp == 1) {
        showSlideUpNotificationAutomatic(automaticSlideUpSelected[0]);
        await slideUpService.sendShowedSlideUp(negocio.value);
      }
    }
  }
}
