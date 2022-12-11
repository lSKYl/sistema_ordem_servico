import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/widgets/ink.dart';

class VetorSedan extends StatefulWidget {
  VetorSedan(
      {super.key,
      this.callback,
      required this.ordemServico,
      this.ordemBloqueada});

  final Function()? callback;
  OrdemServico ordemServico;

  Function? ordemBloqueada;
  @override
  State<VetorSedan> createState() => _VetorSedanState();
}

class _VetorSedanState extends State<VetorSedan> {
  ScreenshotController controller = ScreenshotController();

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

  Stack carroInk() {
    return Stack(
      children: [
        SizedBox(
          height: 350,
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image.asset("assets/img/carro.png"),
          ),
        ),
        //Parte de cima do carro
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte1 =
                  _exibirDialog(widget.ordemServico.sedan.parte1);
            });
          },
          marca: widget.ordemServico.sedan.parte1,
          altura: 70,
          esquerda: 90,
          largura: 40,
          alturaCont: 40,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte2 =
                  _exibirDialog(widget.ordemServico.sedan.parte2);
            });
          },
          marca: widget.ordemServico.sedan.parte2,
          altura: 60,
          esquerda: 175,
          largura: 60,
          alturaCont: 60,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte3 =
                  _exibirDialog(widget.ordemServico.sedan.parte3);
            });
          },
          marca: widget.ordemServico.sedan.parte3,
          altura: 60,
          esquerda: 250,
          largura: 60,
          alturaCont: 60,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte4 =
                  _exibirDialog(widget.ordemServico.sedan.parte4);
            });
          },
          marca: widget.ordemServico.sedan.parte4,
          altura: 40,
          esquerda: 100,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte5 =
                  _exibirDialog(widget.ordemServico.sedan.parte5);
            });
          },
          marca: widget.ordemServico.sedan.parte5,
          altura: 105,
          esquerda: 100,
          largura: 40,
          alturaCont: 30,
        ),
        // Finalização da parte de cima

        //Frente do carro
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte6 =
                  _exibirDialog(widget.ordemServico.sedan.parte6);
            });
          },
          marca: widget.ordemServico.sedan.parte6,
          altura: 170,
          esquerda: 50,
          alturaCont: 30,
          largura: 20,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte7 =
                  _exibirDialog(widget.ordemServico.sedan.parte7);
            });
          },
          marca: widget.ordemServico.sedan.parte7,
          altura: 163,
          esquerda: 65,
          alturaCont: 40,
          largura: 50,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte8 =
                  _exibirDialog(widget.ordemServico.sedan.parte8);
            });
          },
          marca: widget.ordemServico.sedan.parte8,
          altura: 170,
          esquerda: 110,
          alturaCont: 30,
          largura: 20,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte9 =
                  _exibirDialog(widget.ordemServico.sedan.parte9);
            });
          },
          marca: widget.ordemServico.sedan.parte9,
          altura: 190,
          esquerda: 110,
          alturaCont: 30,
          largura: 20,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte10 =
                  _exibirDialog(widget.ordemServico.sedan.parte10);
            });
          },
          marca: widget.ordemServico.sedan.parte10,
          altura: 190,
          esquerda: 50,
          alturaCont: 30,
          largura: 20,
        ),
        //Finalização da frente do carro

        //Parte de trás do carro
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte11 =
                  _exibirDialog(widget.ordemServico.sedan.parte11);
            });
          },
          marca: widget.ordemServico.sedan.parte11,
          baixo: 55,
          esquerda: 70,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte12 =
                  _exibirDialog(widget.ordemServico.sedan.parte12);
            });
          },
          marca: widget.ordemServico.sedan.parte12,
          baixo: 55,
          esquerda: 40,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte13 =
                  _exibirDialog(widget.ordemServico.sedan.parte13);
            });
          },
          marca: widget.ordemServico.sedan.parte13,
          baixo: 55,
          esquerda: 100,
          largura: 40,
          alturaCont: 30,
        ),
        //Finalização da parte de trás do carro

        //Lateral direita do carro
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte14 =
                  _exibirDialog(widget.ordemServico.sedan.parte14);
            });
          },
          marca: widget.ordemServico.sedan.parte14,
          baixo: 55,
          direita: 150,
          largura: 40,
          alturaCont: 40,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte15 =
                  _exibirDialog(widget.ordemServico.sedan.parte15);
            });
          },
          marca: widget.ordemServico.sedan.parte15,
          baixo: 70,
          direita: 190,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte16 =
                  _exibirDialog(widget.ordemServico.sedan.parte16);
            });
          },
          marca: widget.ordemServico.sedan.parte16,
          baixo: 50,
          direita: 43,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte17 =
                  _exibirDialog(widget.ordemServico.sedan.parte17);
            });
          },
          marca: widget.ordemServico.sedan.parte17,
          baixo: 68,
          direita: 60,
          largura: 50,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte18 =
                  _exibirDialog(widget.ordemServico.sedan.parte18);
            });
          },
          marca: widget.ordemServico.sedan.parte18,
          baixo: 50,
          direita: 215,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte19 =
                  _exibirDialog(widget.ordemServico.sedan.parte19);
            });
          },
          marca: widget.ordemServico.sedan.parte19,
          baixo: 85,
          direita: 190,
          largura: 20,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte20 =
                  _exibirDialog(widget.ordemServico.sedan.parte20);
            });
          },
          marca: widget.ordemServico.sedan.parte20,
          baixo: 55,
          direita: 110,
          largura: 40,
          alturaCont: 40,
        ),
        //Finalização Lateral direita do carro

        //Inicio lateral esquerda
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte21 =
                  _exibirDialog(widget.ordemServico.sedan.parte21);
            });
          },
          marca: widget.ordemServico.sedan.parte21,
          baixo: 135,
          direita: 45,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte22 =
                  _exibirDialog(widget.ordemServico.sedan.parte22);
            });
          },
          marca: widget.ordemServico.sedan.parte22,
          baixo: 170,
          direita: 75,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte23 =
                  _exibirDialog(widget.ordemServico.sedan.parte23);
            });
          },
          marca: widget.ordemServico.sedan.parte23,
          baixo: 155,
          direita: 180,
          largura: 50,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte24 =
                  _exibirDialog(widget.ordemServico.sedan.parte24);
            });
          },
          marca: widget.ordemServico.sedan.parte24,
          baixo: 135,
          direita: 215,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte25 =
                  _exibirDialog(widget.ordemServico.sedan.parte25);
            });
          },
          marca: widget.ordemServico.sedan.parte25,
          baixo: 133,
          direita: 140,
          largura: 50,
          alturaCont: 50,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte26 =
                  _exibirDialog(widget.ordemServico.sedan.parte26);
            });
          },
          marca: widget.ordemServico.sedan.parte26,
          baixo: 133,
          direita: 100,
          largura: 40,
          alturaCont: 50,
        ),
        InkCustomStack(
          onTap: () {
            setState(() {
              widget.ordemServico.sedan.parte27 =
                  _exibirDialog(widget.ordemServico.sedan.parte27);
            });
          },
          marca: widget.ordemServico.sedan.parte27,
          baixo: 155,
          direita: 70,
          largura: 30,
          alturaCont: 30,
        ),
      ],
    );
  }

  stackInk() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [carroInk()]),
    );
  }
}
