import 'package:flutter/material.dart';

class InkCustomStack extends StatefulWidget {
  InkCustomStack(
      {super.key,
      this.altura,
      this.baixo,
      this.esquerda,
      this.direita,
      this.alturaCont,
      this.largura,
      this.onTap,
      this.marca});
  final double? baixo;
  final double? esquerda;
  final double? direita;
  final double? altura;
  bool? marca;
  final double? alturaCont;
  final double? largura;
  final void Function()? onTap;

  @override
  State<InkCustomStack> createState() => _InkCustomStackState();
}

class _InkCustomStackState extends State<InkCustomStack> {
  String data = "";

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: widget.baixo,
        left: widget.esquerda,
        right: widget.direita,
        top: widget.altura,
        child: InkWell(
          onTap: () {
            setState(() {
              if (data == "X") {
                data = "";
                widget.marca = false;
              } else {
                data = "X";
                widget.marca = true;
              }
              widget.onTap;
            });
          },
          child: SizedBox(
            height: widget.alturaCont,
            width: widget.largura,
            child: Center(
              child: data == ""
                  ? const Text("")
                  : const Text(
                      "X",
                      style: TextStyle(color: Colors.red, fontSize: 24),
                    ),
            ),
          ),
        ));
  }
}
