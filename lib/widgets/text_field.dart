import 'package:flutter/material.dart';

class TextFieldBorder extends StatelessWidget {
  TextFieldBorder(
      {super.key,
      this.label,
      this.controler,
      required this.read,
      this.suffix,
      this.preffix});
  final String? label;
  final TextEditingController? controler;
  final bool read;
  final Widget? suffix;
  final Widget? preffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
        readOnly: read,
        controller: controler,
        decoration: InputDecoration(
            suffix: suffix,
            prefix: preffix,
            counterText: "",
            labelText: label,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))));
  }
}
