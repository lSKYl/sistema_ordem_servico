import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter/services.dart';

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
      this.maxlines,
      this.maxlength,
      this.prefix,
      this.onTap,
      this.keyboardType,
      this.input})
      : super(key: key);
  final String label;
  final Icon? icon;
  final String? hint;
  final Widget? suffix;
  final String? Function(String? text)? validator;
  final void Function()? onTap;
  final void Function(String? text)? onSaved;
  final void Function(String text)? onChanged;
  final bool obscureText;
  final String? initialvalue;
  final int? maxlines;
  final int? maxlength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? input;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      maxLines: maxlines,
      initialValue: initialvalue,
      keyboardType: keyboardType,
      inputFormatters: input,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefix: prefix,
          prefixStyle: const TextStyle(color: Colors.black),
          prefixIcon: icon,
          suffix: suffix,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
    );
  }
}
