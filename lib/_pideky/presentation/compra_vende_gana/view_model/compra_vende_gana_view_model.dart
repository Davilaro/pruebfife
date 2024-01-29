import 'package:emart/_pideky/domain/compra_vende_gana/service/compra_vende_gana_service.dart';
import 'package:emart/_pideky/infrastructure/compra_vende_gana/compra_vende_gana_repository.dart';
import 'package:get/get.dart';

class CompraVendeGanaViewModel extends GetxController {
  final compraVendeGanaService =
      CompraVendeGanaService(CompraVendeGanaRepository());
  RxList _compraVendeGanaList = [].obs;
  RxList get compraVendeGanaList => _compraVendeGanaList;

  Future<void> getCompraVendeGana() async {
    final compraVendeGana = await compraVendeGanaService.getCompraVendeGana();
    _compraVendeGanaList.value = compraVendeGana;
  }


  static CompraVendeGanaViewModel get findOrInitialize {
    try {
      return Get.find<CompraVendeGanaViewModel>();
    } catch (e) {
      Get.put(CompraVendeGanaViewModel());
      return Get.find<CompraVendeGanaViewModel>();
    }
  }
}
