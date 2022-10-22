import 'package:flutter/material.dart';

class SearchFieldDialog extends StatelessWidget {
  const SearchFieldDialog(
      {super.key, this.controller, this.onChanged, this.hint});
  final void Function(String text)? onChanged;
  final TextEditingController? controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
          icon: const Icon(Icons.search),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)))),
      style: const TextStyle(color: Colors.black),
    );
  }
}
