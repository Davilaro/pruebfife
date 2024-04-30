import 'package:emart/_pideky/presentation/customers_prospection/view_model/customers_prospect_view_model.dart';
import 'package:emart/shared/widgets/custom_textFormField.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class TextFormFieldCustomerProspection extends StatelessWidget {
  const TextFormFieldCustomerProspection({
    Key? key,
    required this.customersProspectionViewModel,
  }) : super(key: key);

  final CustomersProspectionViewModel customersProspectionViewModel;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: customersProspectionViewModel.formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              'Nombre cliente',
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontWeight: FontWeight.bold),
            ),
          ),
          CustomTextFormField(
            hintText: 'Ingrese su nombre completo',
            onChanged: (value) =>
                customersProspectionViewModel.nameController = value,
            hintStyle:
                TextStyle(color: ConstantesColores.gris_textos),
            backgroundColor: HexColor("#E4E3EC"),
            textColor: HexColor("#41398D"),
            borderRadius: 35,
            validator: (value) => customersProspectionViewModel.validateFields(value!),
            prefixIcon: SvgPicture.asset(
              'assets/icon/cliente.svg',
              fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'Número de cédula',
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontWeight: FontWeight.bold),
            ),
          ),
          CustomTextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                customersProspectionViewModel.idController = value,
            hintText: 'Ingrese su numero de identificación',
            hintStyle:
                TextStyle(color: ConstantesColores.gris_textos),
            backgroundColor: HexColor("#E4E3EC"),
            textColor: HexColor("#41398D"),
            borderRadius: 35,
            validator: (value) => customersProspectionViewModel.validateFields(value!),
            prefixIcon: SvgPicture.asset(
              'assets/icon/cliente.svg',
              fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'Celular de contacto',
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontWeight: FontWeight.bold),
            ),
          ),
          CustomTextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) => customersProspectionViewModel
                  .phoneController = value,
              hintText: 'Ingrese su número de celular',
              hintStyle:
                  TextStyle(color: ConstantesColores.gris_textos),
              backgroundColor: HexColor("#E4E3EC"),
              textColor: HexColor("#41398D"),
              borderRadius: 35,
              validator: (value) => customersProspectionViewModel.validateFields(value!),
              prefixIcon: Icon(
                Icons.phone_in_talk_outlined,
                color: ConstantesColores.azul_precio,
              )),
        ],
      ),
    );
  }
}