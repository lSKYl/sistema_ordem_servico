import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key, this.nome, this.subtitulo, this.onTap, required this.object});
  final Object object;
  final String? nome;
  final String? subtitulo;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          title: Text(nome!),
          onTap: onTap,
        ),
      ),
    );
  }
}
