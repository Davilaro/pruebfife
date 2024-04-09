import 'package:emart/_pideky/domain/customers_school/use_cases/customers_school_use_cases.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewModelPrincipalPage extends GetxController {
  final CustomersSchoolUseCases customersSchool = CustomersSchoolUseCases();
  Object video = Object;

  Future getVideo() async {
    video = await customersSchool.getVideo();
  }


  launchUrlcustomersSchool() async {
    const String url = 'https://escueladeclientesnutresa.com';
     final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'No se pudo abrir la URL $url';
    }
  }
}
