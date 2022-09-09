import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/visao/list_user.dart';
import 'export_widgets.dart';

class Button extends StatelessWidget {
  final Icon icon;
  final String text;
  final Widget formulario;
  const Button({
    Key? key,
    required this.icon,
    required this.text,
    required this.formulario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white),
        height: 100,
        width: 175,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => formulario));
          },
          icon: icon,
          label: Text(text),
          style: ElevatedButton.styleFrom(elevation: 20),
        ));
  }
}
