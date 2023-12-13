import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.height = 50,
      this.sizeText = 16,
      this.width = 100,
      required this.backgroundColor,
      this.colorContent = Colors.white,
      this.leftIcon,
      this.blockDoubleClick = true,
      this.borderRadio = 40,
      this.padding,
      this.rightIcon,
      this.isFontBold = false})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final double width;
  final double sizeText;
  final double height;
  final bool? blockDoubleClick;
  final Color backgroundColor;
  final Color colorContent;
  final double borderRadio;
  final EdgeInsets? padding;
  final AssetImage? leftIcon;
  final AssetImage? rightIcon;
  final bool isFontBold;

  final RxBool absorbPointer = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx((() => AbsorbPointer(
          absorbing: absorbPointer.value,
          child: (ElevatedButton(
            onPressed: () {
              if (blockDoubleClick!) {
                absorbPointer.value = true;
                onBlockBoubleCLick();
              }
              onPressed.call();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (leftIcon != null)
                  ImageIcon(
                    leftIcon,
                    color: colorContent,
                  ),
                if (leftIcon != null || rightIcon != null) const Spacer(),
                Container(
                  child: AutoSizeText(
                    text,
                    
                    style: TextStyle(
                
                        color: colorContent,
                        fontSize: sizeText,
                       
                        fontWeight:
                            isFontBold ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
                if (leftIcon != null || rightIcon != null) const Spacer(),
                if (rightIcon != null)
                  ImageIcon(
                    rightIcon,
                    color: colorContent,
                  ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: backgroundColor,
              fixedSize: Size(width, height),
              padding: padding,
              // backgroundColor: backgroundColor,
              minimumSize: Size(0, height),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadio),
              ),
            ),
          )),
        )));
  }

  onBlockBoubleCLick() {
    Future.delayed(const Duration(seconds: 2), () {
      absorbPointer.value = false;
    });
  }
}
