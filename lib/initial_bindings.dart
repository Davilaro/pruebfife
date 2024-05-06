import 'package:emart/_pideky/presentation/general_search/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/winners_club/view_mdel/club_ganadores_view_model.dart';
import 'package:emart/_pideky/presentation/my_business/view_model/my_business_view_model.dart';
import 'package:emart/_pideky/presentation/my_statistics/view_model/my_statistics_view_model.dart';
import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/_pideky/presentation/my_payments/view_model/my_payments_view_model.dart';
import 'package:emart/_pideky/presentation/my_orders/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/my_orders/view_model/transit_orders_view_model.dart';
import 'package:emart/_pideky/presentation/suggested_order/view_model/suggested_order_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_multimedia.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    ControllerMultimedia.findOrInitialize;
    ControlBaseDatos.findOrInitialize;
    MyOrdersViewModel.findOrInitialize;
    TransitOrdersViewModel.findOrInitialize;
    MyBusinessVieModel.findOrInitialize;
    MyStatisticsViewModel.findOrInitialize;
    SuggestedOrderViewModel.findOrInitialize;
    MyPaymentsViewModel.findOrInitialize;
    ProductViewModel.findOrInitialize;
    WinnersClubViewModel.findOrInitialize;
    NotificationsSlideUpAndPushInUpControllers.findOrInitialize;
    ValidationForms.findOrInitialize;
    BotonesProveedoresVm.findOrInitialize;
    SearchFuzzyViewModel.findOrInitialize;
    MyListsViewModel.findOrInitialize;
  }
}
