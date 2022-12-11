import 'package:flutter/material.dart';

import '../../modelo/ordemservico.dart';
import '../../widgets/ink.dart';

class VetorHatch extends StatefulWidget {
  VetorHatch(
      {super.key,
      this.callback,
      required this.ordemServico,
      this.ordemBloqueada});
  final Function()? callback;
  OrdemServico ordemServico;
  Function? ordemBloqueada;

  @override
  State<VetorHatch> createState() => _VetorHatchState();
}

class _VetorHatchState extends State<VetorHatch> {
  bool _exibirDialog(bool parametro) {
    if (widget.ordemServico.situacaoAtual == "Finalizado") {
      showDialog(
          context: context,
          builder: ((context) {
            return widget.ordemBloqueada!();
          }));
      return parametro;
    } else {
      return widget.ordemServico.hatch.alterar(parametro);
    }
  }

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

  Stack carroInk() {
    return Stack(
      children: [
        SizedBox(
          height: 350,
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image.asset("assets/img/hatch.jpg"),
          ),
        ),
        //Parte de frente do carro

        InkCustomStack(
          marca: widget.ordemServico.hatch.parte1,
          altura: 45,
          esquerda: 51,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte1 =
                  _exibirDialog(widget.ordemServico.hatch.parte1);
            });
          }),
          alturaCont: 30,
          largura: 50,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte2,
          altura: 68,
          esquerda: 25,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte2 =
                  _exibirDialog(widget.ordemServico.hatch.parte2);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte3,
          altura: 68,
          esquerda: 60,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte3 =
                  _exibirDialog(widget.ordemServico.hatch.parte3);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte4,
          altura: 68,
          esquerda: 95,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte4 =
                  _exibirDialog(widget.ordemServico.hatch.parte4);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),

        //Parte da frente finalizada

        //Parte traseira do carro

        InkCustomStack(
          marca: widget.ordemServico.hatch.parte5,
          baixo: 160,
          esquerda: 40,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte5 =
                  _exibirDialog(widget.ordemServico.hatch.parte5);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte6,
          baixo: 160,
          esquerda: 78,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte6 =
                  _exibirDialog(widget.ordemServico.hatch.parte6);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte7,
          baixo: 140,
          esquerda: 25,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte7 =
                  _exibirDialog(widget.ordemServico.hatch.parte7);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte8,
          baixo: 140,
          esquerda: 60,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte8 =
                  _exibirDialog(widget.ordemServico.hatch.parte8);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte9,
          baixo: 140,
          esquerda: 95,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte9 =
                  _exibirDialog(widget.ordemServico.hatch.parte9);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        //Finalizado parte traseira do veiculo

        //Inicio lateral direita

        InkCustomStack(
          marca: widget.ordemServico.hatch.parte10,
          altura: 75,
          direita: 35,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte10 =
                  _exibirDialog(widget.ordemServico.hatch.parte10);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte11,
          altura: 50,
          direita: 60,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte11 =
                  _exibirDialog(widget.ordemServico.hatch.parte11);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte11,
          altura: 50,
          direita: 60,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte11 =
                  _exibirDialog(widget.ordemServico.hatch.parte11);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte12,
          altura: 50,
          direita: 110,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte12 =
                  _exibirDialog(widget.ordemServico.hatch.parte12);
            });
          }),
          alturaCont: 50,
          largura: 50,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte13,
          altura: 50,
          direita: 165,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte13 =
                  _exibirDialog(widget.ordemServico.hatch.parte13);
            });
          }),
          alturaCont: 50,
          largura: 50,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte14,
          altura: 45,
          direita: 215,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte14 =
                  _exibirDialog(widget.ordemServico.hatch.parte14);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte15,
          altura: 65,
          direita: 240,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte15 =
                  _exibirDialog(widget.ordemServico.hatch.parte15);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        //Finalização lateral direita

        //Inicio teto do veiculo

        InkCustomStack(
          marca: widget.ordemServico.hatch.parte16,
          baixo: 145,
          direita: 35,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte16 =
                  _exibirDialog(widget.ordemServico.hatch.parte16);
            });
          }),
          alturaCont: 60,
          largura: 45,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte17,
          baixo: 200,
          direita: 50,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte17 =
                  _exibirDialog(widget.ordemServico.hatch.parte17);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte18,
          baixo: 125,
          direita: 50,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte18 =
                  _exibirDialog(widget.ordemServico.hatch.parte18);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte19,
          baixo: 145,
          direita: 140,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte19 =
                  _exibirDialog(widget.ordemServico.hatch.parte19);
            });
          }),
          alturaCont: 60,
          largura: 80,
        ),

        //Finalizado teto do veiculo

        //Inicio lateral esquerda

        InkCustomStack(
          marca: widget.ordemServico.hatch.parte20,
          baixo: 40,
          direita: 25,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte20 =
                  _exibirDialog(widget.ordemServico.hatch.parte20);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte21,
          baixo: 60,
          direita: 50,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte21 =
                  _exibirDialog(widget.ordemServico.hatch.parte21);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte22,
          baixo: 40,
          direita: 85,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte22 =
                  _exibirDialog(widget.ordemServico.hatch.parte22);
            });
          }),
          alturaCont: 50,
          largura: 50,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte23,
          baixo: 40,
          direita: 140,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte23 =
                  _exibirDialog(widget.ordemServico.hatch.parte23);
            });
          }),
          alturaCont: 50,
          largura: 50,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte24,
          baixo: 60,
          direita: 210,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte24 =
                  _exibirDialog(widget.ordemServico.hatch.parte24);
            });
          }),
          alturaCont: 30,
          largura: 30,
        ),
        InkCustomStack(
          marca: widget.ordemServico.hatch.parte25,
          baixo: 30,
          direita: 240,
          onTap: (() {
            setState(() {
              widget.ordemServico.hatch.parte25 =
                  _exibirDialog(widget.ordemServico.hatch.parte25);
            });
          }),
          alturaCont: 30,
          largura: 30,
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
