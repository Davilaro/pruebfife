import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final bool showShadow;
  final bool? obscureText;
  final String? errorMessage;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;

  CustomTextFormField({
    this.controller,
    this.hintText,
    this.hintStyle,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.icon,
    this.onChanged,
    this.showShadow = true,
    this.obscureText,
    this.validator,
    this.errorMessage,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: widget.textColor, fontSize: 15),
      onChanged: widget.onChanged,
      obscureText: _isObscured && (widget.obscureText ?? false),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(35),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[500]!),
          borderRadius: BorderRadius.circular(35),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
        filled: true,
        fillColor: widget.backgroundColor,
        errorText: widget.errorMessage,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        prefixIcon: widget.prefixIcon ?? Icon(
          widget.icon,
          color: widget.textColor,
        ),
        suffixIcon: widget.obscureText != null
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: widget.textColor,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      ),
    );
  }
}

// class CustomTextFormField extends StatelessWidget {
//   final TextEditingController? controller;
//   final String? hintText;
//   final TextStyle? hintStyle;
//   final Color? backgroundColor;
//   final Color? textColor;
//   final double? borderRadius;
//   final IconData? icon;
//   final ValueChanged<String>? onChanged;
//   final bool showShadow;
//   final bool? obscureText;
//   final String? errorMessage;
//   final String? Function(String?)? validator;
//   final TextInputType? keyboardType;
//   final Widget? prefixIcon;

//   CustomTextFormField({
//     this.controller,
//     this.hintText,
//     this.hintStyle,
//     this.backgroundColor,
//     this.textColor,
//     this.borderRadius,
//     this.icon,
//     this.onChanged,
//     this.showShadow = true,
//     this.obscureText,
//     this.validator,
//     this.errorMessage,
//     this.keyboardType,  
//     this.prefixIcon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     bool _isObscured = true;

//     return TextFormField(
//       validator: validator,
//       controller: controller,
//       keyboardType: keyboardType,
//       style: TextStyle(color: textColor, fontSize: 15),
//       onChanged: onChanged,
//       obscureText: _isObscured && (obscureText ?? false),
//       decoration: InputDecoration(
//         enabledBorder: OutlineInputBorder(
//           borderSide:
//               BorderSide(color: Colors.grey[300]!), // Cambia el color aquí
//           borderRadius: BorderRadius.circular(35),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//               color: Colors.grey[
//                   500]!), // Cambia el color del borde cuando está enfocado
//           borderRadius: BorderRadius.circular(35),
//         ),
//         contentPadding: EdgeInsets.symmetric(vertical: 10),
//         filled: true,
//         fillColor: backgroundColor,
//         errorText: errorMessage,
//         hintText: hintText,
//         hintStyle: hintStyle,
//         prefixIcon: prefixIcon ?? Icon(
//           icon,
//           color: textColor,
//         ),
//         suffixIcon: obscureText != null
//             ? IconButton(
//                 icon: Icon(
//                   _isObscured ? Icons.visibility : Icons.visibility_off,
//                   color: textColor,
//                 ),
//                 onPressed: () {
//                   _isObscured = !_isObscured;
//                 },
//               )
//             : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(35), // Radio de borde redondeado
//         ),
//       ),
//     );
//   }
// }
