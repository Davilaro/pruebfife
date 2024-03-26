// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:emart/_pideky/domain/winners_club_pideky/use_cases/winners_club_use_cases.dart';
import 'package:emart/_pideky/infrastructure/winners_club_pideky/winners_club_pideky.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WinnersClubViewModel extends GetxController {
  final clubGanadoresService = WinnersClubUseCases(WinnersClubPideky());

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

  static WinnersClubViewModel get findOrInitialize {
    try {
      return Get.find<WinnersClubViewModel>();
    } catch (e) {
      Get.put(WinnersClubViewModel());
      return Get.find<WinnersClubViewModel>();
    }
  }
}
