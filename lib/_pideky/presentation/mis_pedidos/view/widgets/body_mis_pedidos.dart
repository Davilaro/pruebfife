import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/body_historico.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/body_transito.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/src/controllers/controller_historico.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyMisPedidos extends StatelessWidget {
  BodyMisPedidos({
    Key? key,
    required this.misPedidosViewModel, 
  }) : super(key: key);

  final MisPedidosViewModel misPedidosViewModel;

  final controllerHistorico = Get.find<ControllerHistorico>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Expanded(
                  child: PageView(
                    controller: misPedidosViewModel.pageController,
                    onPageChanged: (index) {
                      misPedidosViewModel.cambiarTab(index);
                    },
                    children: [
                      SingleChildScrollView(
                        child: BodyHistorico(),
                      ),
                      SingleChildScrollView(
                        child: BodyTransito(),
                      ),
                    ],
                  ),
                )
    );
  }
}
