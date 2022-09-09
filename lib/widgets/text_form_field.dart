import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.label,
      this.initialvalue,
      this.icon,
      this.hint,
      this.suffix,
      this.validator,
      this.onSaved,
      this.onChanged,
      required this.obscureText,
      this.maxlines})
      : super(key: key);
  final String label;
  final Icon? icon;
  final String? hint;
  final Widget? suffix;
  final String? Function(String? text)? validator;
  final void Function(String? text)? onSaved;
  final void Function(String text)? onChanged;
  final bool obscureText;
  final String? initialvalue;
  final int? maxlines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      maxLines: maxlines,
      initialValue: initialvalue,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon,
          suffix: suffix,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
    );
  }
}
