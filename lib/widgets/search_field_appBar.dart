import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  SearchField({super.key, this.controller, this.onChanged, this.hint});
  final TextEditingController? controller;
  final void Function(String text)? onChanged;

  final String? hint;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.search,
        color: Colors.white,
      ),
      title: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
