import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ControllerWebView extends GetxController {
  
  final urlPaymentLink = "https://pagos.gruponutresa.com/#/home";

  Future launchUrl() async {
    try {
      await launch(
        urlPaymentLink,
      );
    } catch (e) {
      return e;
    }
  }
}
