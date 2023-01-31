import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductoViewModel extends GetxController {
  String getCurrency(dynamic valor) {
    NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

    var result = '${getFormat().currencySymbol}' +
        formatNumber.format(valor).replaceAll(',00', '');

    return result;
  }

  NumberFormat getFormat() {
    var locale = Intl().locale;
    var format = locale.toString() != 'es_CO'
        ? locale.toString() == 'es_CR'
            ? NumberFormat.currency(locale: locale.toString(), symbol: '\₡')
            : NumberFormat.simpleCurrency(locale: locale.toString())
        : NumberFormat.currency(locale: locale.toString(), symbol: '\$');

    return format;
  }

  static ProductoViewModel get findOrInitialize {
    try {
      return Get.find<ProductoViewModel>();
    } catch (e) {
      Get.put(ProductoViewModel());
      return Get.find<ProductoViewModel>();
    }
  }
}
