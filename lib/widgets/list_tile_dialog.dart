import 'package:flutter/material.dart';

class ListTileDialog extends StatelessWidget {
  const ListTileDialog(
      {super.key,
      required this.object,
      this.nome,
      this.subtitulo,
      this.onTap,
      this.indice});
  final Object object;
  final String? nome;
  final String? subtitulo;
  final int? indice;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: CircleAvatar(child: Text("$indice")),
          title: Text(nome!),
          subtitle: Text(subtitulo!),
          onTap: onTap,
        ),
      ),
    );
  }
}
