import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TituloPideky extends StatelessWidget {
  const TituloPideky({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(-10.0, 3.0, 0.0),
      child: Container(
          height: 30,
          width: size.width * 0.3,
          child: SvgPicture.asset('assets/app_bar.svg', fit: BoxFit.fill)),
    );
  }
}
