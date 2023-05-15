// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:emart/_pideky/domain/club_ganadores_pideky/service/club_ganadores_service.dart';
import 'package:emart/_pideky/infrastructure/club_ganadores_pideky/club_ganadores_sql.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ClubGanadoresViewModel extends GetxController {
  final clubGanadoresService = ClubGandoresService(ClubGanadoresPidekySql());

  final carouselController = CarouselController();
  var indexCurrentSlider = 0.obs;
  final urlRedimirPuntos = "https://www.clubdeganadorespideky.com/";

  Future launchUrl() async {
    try {
      await launch(
        urlRedimirPuntos,
      );
    } catch (e) {
      return e;
    }
  }

  cargarPuntos() async {
    return clubGanadoresService.consultarPuntos();
  }

  cargarImagenesPremios() async {
    return clubGanadoresService.consultarImagenPremios();
  }

  initData() {
    cargarImagenesPremios();
  }

  static ClubGanadoresViewModel get findOrInitialize {
    try {
      return Get.find<ClubGanadoresViewModel>();
    } catch (e) {
      Get.put(ClubGanadoresViewModel());
      return Get.find<ClubGanadoresViewModel>();
    }
  }
}
