import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TituloPidekyCarrito extends StatelessWidget {
  const TituloPidekyCarrito({
    Key? key,
    required this.widget,
    required this.size,
  }) : super(key: key);

  final Size size;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context, listen: false);
    return Transform(
      transform: Matrix4.translationValues(-10.0, 3.0, 0.0),
      child: GestureDetector(
        child: Container(
            height: size.width * 0.078,
            width: size.width * 0.3,
            child:
                SvgPicture.asset('assets/image/app_bar.svg', fit: BoxFit.fill)),
        onTap: () => {
          provider.selectOptionMenu = 0,
          Navigator.of(context).pushNamedAndRemoveUntil(
              'tab_opciones', (Route<dynamic> route) => false),
        },
      ),
    );
  }
}
