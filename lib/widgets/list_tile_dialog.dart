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
  final Widget? nome;
  final Widget? subtitulo;
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
          title: nome,
          subtitle: subtitulo,
          onTap: onTap,
        ),
      ),
    );
  }
}
