import 'package:flutter/material.dart';

import '../../modelo/ordemservico.dart';
import '../../widgets/ink.dart';

class VetorSUV extends StatefulWidget {
  VetorSUV(
      {super.key,
      this.callback,
      required this.ordemServico,
      this.ordemBloqueada});

  final Function()? callback;
  OrdemServico ordemServico;

  Function? ordemBloqueada;

  @override
  State<VetorSUV> createState() => _VetorSUVState();
}

class _VetorSUVState extends State<VetorSUV> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            stackInk(),
          ],
        ),
      ],
    );
  }

  bool _exibirDialog(bool parametro) {
    if (widget.ordemServico.situacaoAtual == "Finalizado") {
      showDialog(
          context: context,
          builder: ((context) {
            return widget.ordemBloqueada!();
          }));
      return parametro;
    } else {
      return widget.ordemServico.sedan.alterar(parametro);
    }
  }

  Stack suvInk() {
    return Stack(children: [
      SizedBox(
        height: 350,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.asset("assets/img/suv.png"),
        ),
      ),
      //Parte de cima do veiculo

      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte1 =
                _exibirDialog(widget.ordemServico.suv.parte1);
          });
        },
        marca: widget.ordemServico.suv.parte1,
        altura: 70,
        esquerda: 100,
        alturaCont: 40,
        largura: 40,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte2 =
                _exibirDialog(widget.ordemServico.suv.parte2);
          });
        },
        marca: widget.ordemServico.suv.parte2,
        altura: 45,
        esquerda: 105,
        alturaCont: 25,
        largura: 40,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte3 =
                _exibirDialog(widget.ordemServico.suv.parte3);
          });
        },
        marca: widget.ordemServico.suv.parte3,
        altura: 100,
        esquerda: 105,
        alturaCont: 25,
        largura: 40,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte4 =
                _exibirDialog(widget.ordemServico.suv.parte4);
          });
        },
        marca: widget.ordemServico.suv.parte4,
        altura: 70,
        esquerda: 185,
        alturaCont: 40,
        largura: 70,
      ),

      //Finalizado parte de cima do veiculo

      //Inicio frente do veiculo.

      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte5 =
                _exibirDialog(widget.ordemServico.suv.parte5);
          });
        },
        marca: widget.ordemServico.suv.parte5,
        altura: 170,
        esquerda: 45,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte5 =
                _exibirDialog(widget.ordemServico.suv.parte5);
          });
        },
        marca: widget.ordemServico.suv.parte5,
        altura: 170,
        esquerda: 45,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte6 =
                _exibirDialog(widget.ordemServico.suv.parte6);
          });
        },
        marca: widget.ordemServico.suv.parte6,
        altura: 165,
        esquerda: 75,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte7 =
                _exibirDialog(widget.ordemServico.suv.parte7);
          });
        },
        marca: widget.ordemServico.suv.parte7,
        altura: 170,
        esquerda: 105,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte8 =
                _exibirDialog(widget.ordemServico.suv.parte8);
          });
        },
        marca: widget.ordemServico.suv.parte8,
        altura: 190,
        esquerda: 105,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte9 =
                _exibirDialog(widget.ordemServico.suv.parte9);
          });
        },
        marca: widget.ordemServico.suv.parte9,
        altura: 190,
        esquerda: 45,
        alturaCont: 25,
        largura: 30,
      ),

      //Finalizado parte da frente do veiculo

      //Inicio da parte de tras do veiculo

      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte10 =
                _exibirDialog(widget.ordemServico.suv.parte10);
          });
        },
        marca: widget.ordemServico.suv.parte10,
        baixo: 60,
        alturaCont: 25,
        largura: 30,
        esquerda: 50,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte11 =
                _exibirDialog(widget.ordemServico.suv.parte11);
          });
        },
        marca: widget.ordemServico.suv.parte11,
        baixo: 60,
        alturaCont: 25,
        largura: 30,
        esquerda: 75,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte12 =
                _exibirDialog(widget.ordemServico.suv.parte12);
          });
        },
        marca: widget.ordemServico.suv.parte12,
        baixo: 60,
        alturaCont: 25,
        largura: 30,
        esquerda: 100,
      ),

      //Fim da parte de tras do veiculo

      //Lateral direita do veículo

      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte13 =
                _exibirDialog(widget.ordemServico.suv.parte13);
          });
        },
        marca: widget.ordemServico.suv.parte13,
        baixo: 50,
        direita: 63,
        alturaCont: 30,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte14 =
                _exibirDialog(widget.ordemServico.suv.parte14);
          });
        },
        marca: widget.ordemServico.suv.parte14,
        baixo: 72,
        direita: 85,
        alturaCont: 30,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte15 =
                _exibirDialog(widget.ordemServico.suv.parte15);
          });
        },
        marca: widget.ordemServico.suv.parte15,
        baixo: 55,
        direita: 125,
        alturaCont: 40,
        largura: 40,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte16 =
                _exibirDialog(widget.ordemServico.suv.parte16);
          });
        },
        marca: widget.ordemServico.suv.parte16,
        baixo: 55,
        direita: 165,
        alturaCont: 40,
        largura: 40,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte17 =
                _exibirDialog(widget.ordemServico.suv.parte17);
          });
        },
        marca: widget.ordemServico.suv.parte17,
        baixo: 75,
        direita: 200,
        alturaCont: 30,
        largura: 30,
      ),

      //Fim lateral direita do veiculo

      //Inicio lateral esquerda do veiculo

      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte18 =
                _exibirDialog(widget.ordemServico.suv.parte18);
          });
        },
        marca: widget.ordemServico.suv.parte18,
        baixo: 130,
        direita: 215,
        alturaCont: 30,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte19 =
                _exibirDialog(widget.ordemServico.suv.parte19);
          });
        },
        marca: widget.ordemServico.suv.parte19,
        baixo: 155,
        direita: 190,
        alturaCont: 30,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte20 =
                _exibirDialog(widget.ordemServico.suv.parte20);
          });
        },
        marca: widget.ordemServico.suv.parte20,
        baixo: 140,
        direita: 145,
        alturaCont: 40,
        largura: 40,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte21 =
                _exibirDialog(widget.ordemServico.suv.parte21);
          });
        },
        marca: widget.ordemServico.suv.parte21,
        baixo: 140,
        direita: 100,
        alturaCont: 40,
        largura: 40,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.suv.parte22 =
                _exibirDialog(widget.ordemServico.suv.parte22);
          });
        },
        marca: widget.ordemServico.suv.parte22,
        baixo: 155,
        direita: 75,
        alturaCont: 30,
        largura: 30,
      ),

      //Finalizado lateral esquerda
    ]);
  }

  stackInk() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [suvInk()]),
    );
  }
}
