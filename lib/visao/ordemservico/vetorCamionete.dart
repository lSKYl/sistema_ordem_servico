import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../../modelo/ordemservico.dart';
import '../../widgets/ink.dart';

class VetorCamionete extends StatefulWidget {
  VetorCamionete(
      {super.key,
      this.callback,
      required this.ordemServico,
      this.ordemBloqueada});
  final Function()? callback;
  OrdemServico ordemServico;
  Function? ordemBloqueada;

  @override
  State<VetorCamionete> createState() => _VetorCamioneteState();
}

class _VetorCamioneteState extends State<VetorCamionete> {
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

  Stack camioneteInk() {
    return Stack(children: [
      SizedBox(
        height: 350,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.asset("assets/img/camionete.png"),
        ),
      ),
      //Parte de cima da camionete
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte1 =
                _exibirDialog(widget.ordemServico.pickup.parte1);
          });
        },
        marca: widget.ordemServico.pickup.parte1,
        baixo: 135,
        esquerda: 110,
        largura: 70,
        alturaCont: 60,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte2 =
                _exibirDialog(widget.ordemServico.pickup.parte2);
          });
        },
        marca: widget.ordemServico.pickup.parte2,
        baixo: 135,
        largura: 50,
        alturaCont: 50,
        esquerda: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte3 =
                _exibirDialog(widget.ordemServico.pickup.parte3);
          });
        },
        marca: widget.ordemServico.pickup.parte3,
        baixo: 115,
        esquerda: 30,
        largura: 60,
        alturaCont: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte4 =
                _exibirDialog(widget.ordemServico.pickup.parte4);
          });
        },
        marca: widget.ordemServico.pickup.parte4,
        baixo: 175,
        esquerda: 30,
        largura: 60,
        alturaCont: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte5 =
                _exibirDialog(widget.ordemServico.pickup.parte5);
          });
        },
        marca: widget.ordemServico.pickup.parte5,
        baixo: 135,
        esquerda: 185,
        largura: 70,
        alturaCont: 60,
      ),
      //Finalizado parte de cima da camionete

      //Lateral esquerda camionete
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte6 =
                _exibirDialog(widget.ordemServico.pickup.parte6);
          });
        },
        marca: widget.ordemServico.pickup.parte6,
        altura: 70,
        largura: 45,
        alturaCont: 30,
        esquerda: 45,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte7 =
                _exibirDialog(widget.ordemServico.pickup.parte7);
          });
        },
        marca: widget.ordemServico.pickup.parte7,
        altura: 95,
        largura: 30,
        alturaCont: 30,
        esquerda: 25,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte8 =
                _exibirDialog(widget.ordemServico.pickup.parte8);
          });
        },
        marca: widget.ordemServico.pickup.parte8,
        altura: 85,
        largura: 30,
        alturaCont: 30,
        esquerda: 80,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte9 =
                _exibirDialog(widget.ordemServico.pickup.parte9);
          });
        },
        marca: widget.ordemServico.pickup.parte9,
        altura: 75,
        largura: 40,
        alturaCont: 40,
        esquerda: 100,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte10 =
                _exibirDialog(widget.ordemServico.pickup.parte10);
          });
        },
        marca: widget.ordemServico.pickup.parte10,
        altura: 75,
        largura: 40,
        alturaCont: 40,
        esquerda: 143,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte11 =
                _exibirDialog(widget.ordemServico.pickup.parte11);
          });
        },
        marca: widget.ordemServico.pickup.parte11,
        altura: 70,
        largura: 60,
        alturaCont: 30,
        esquerda: 180,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte12 =
                _exibirDialog(widget.ordemServico.pickup.parte12);
          });
        },
        marca: widget.ordemServico.pickup.parte12,
        altura: 90,
        largura: 30,
        alturaCont: 30,
        esquerda: 230,
      ),
      // Finalizado lateral esquerda do veiculo

      //Inicio lateral direita
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte13 =
                _exibirDialog(widget.ordemServico.pickup.parte13);
          });
        },
        marca: widget.ordemServico.pickup.parte13,
        baixo: 35,
        alturaCont: 30,
        largura: 30,
        esquerda: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte14 =
                _exibirDialog(widget.ordemServico.pickup.parte14);
          });
        },
        marca: widget.ordemServico.pickup.parte14,
        baixo: 50,
        alturaCont: 30,
        largura: 60,
        esquerda: 48,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte15 =
                _exibirDialog(widget.ordemServico.pickup.parte15);
          });
        },
        marca: widget.ordemServico.pickup.parte15,
        baixo: 38,
        alturaCont: 40,
        largura: 40,
        esquerda: 105,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte16 =
                _exibirDialog(widget.ordemServico.pickup.parte16);
          });
        },
        marca: widget.ordemServico.pickup.parte16,
        baixo: 38,
        alturaCont: 40,
        largura: 40,
        esquerda: 150,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte17 =
                _exibirDialog(widget.ordemServico.pickup.parte17);
          });
        },
        marca: widget.ordemServico.pickup.parte17,
        baixo: 40,
        alturaCont: 30,
        largura: 30,
        esquerda: 185,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte18 =
                _exibirDialog(widget.ordemServico.pickup.parte18);
          });
        },
        marca: widget.ordemServico.pickup.parte18,
        baixo: 50,
        alturaCont: 30,
        largura: 50,
        esquerda: 195,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte19 =
                _exibirDialog(widget.ordemServico.pickup.parte19);
          });
        },
        marca: widget.ordemServico.pickup.parte19,
        baixo: 30,
        alturaCont: 30,
        largura: 30,
        esquerda: 230,
      ),

      //Frente do veiculo
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte20 =
                _exibirDialog(widget.ordemServico.pickup.parte20);
          });
        },
        marca: widget.ordemServico.pickup.parte20,
        altura: 95,
        direita: 62,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte21 =
                _exibirDialog(widget.ordemServico.pickup.parte21);
          });
        },
        marca: widget.ordemServico.pickup.parte21,
        altura: 95,
        direita: 90,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte22 =
                _exibirDialog(widget.ordemServico.pickup.parte22);
          });
        },
        marca: widget.ordemServico.pickup.parte22,
        altura: 95,
        direita: 30,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte23 =
                _exibirDialog(widget.ordemServico.pickup.parte23);
          });
        },
        marca: widget.ordemServico.pickup.parte23,
        altura: 70,
        direita: 62,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte24 =
                _exibirDialog(widget.ordemServico.pickup.parte24);
          });
        },
        marca: widget.ordemServico.pickup.parte24,
        altura: 70,
        direita: 90,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte25 =
                _exibirDialog(widget.ordemServico.pickup.parte25);
          });
        },
        marca: widget.ordemServico.pickup.parte25,
        altura: 70,
        direita: 30,
        alturaCont: 25,
        largura: 30,
      ),
      //Finalizado parte da frente do veiculo

      //Inicio de trás do veiculo

      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte26 =
                _exibirDialog(widget.ordemServico.pickup.parte26);
          });
        },
        marca: widget.ordemServico.pickup.parte26,
        altura: 150,
        direita: 35,
        alturaCont: 30,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte27 =
                _exibirDialog(widget.ordemServico.pickup.parte27);
          });
        },
        marca: widget.ordemServico.pickup.parte27,
        altura: 150,
        direita: 63,
        alturaCont: 30,
        largura: 30,
      ),
      InkCustomStack(
        onTap: () {
          setState(() {
            widget.ordemServico.pickup.parte28 =
                _exibirDialog(widget.ordemServico.pickup.parte28);
          });
        },
        marca: widget.ordemServico.pickup.parte28,
        altura: 150,
        direita: 90,
        alturaCont: 30,
        largura: 30,
      ),
    ]);
  }

  stackInk() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [camioneteInk()]),
    );
  }
}
