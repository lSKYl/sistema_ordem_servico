import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/widgets/ink.dart';

class VetorCarros extends StatefulWidget {
  VetorCarros(
      {super.key, this.callback, required this.ordemServico, this.bytes});

  final Function()? callback;
  OrdemServico ordemServico;
  Uint8List? bytes;

  @override
  State<VetorCarros> createState() => _VetorCarrosState();
}

class _VetorCarrosState extends State<VetorCarros> {
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
        const SizedBox(height: 15),
        if (widget.ordemServico.vetorVeiculo == null)
          (ElevatedButton(
              onPressed: () async {
                widget.bytes = await controller.capture();
                widget.ordemServico.vetorVeiculo = widget.bytes;
                widget.callback!();
              },
              child: Text("Salvar")))
        else
          (ElevatedButton(
              onPressed: () {
                widget.ordemServico.vetorVeiculo = null;
                widget.callback!();
              },
              child: Text("Editar")))
      ],
    );
  }

  Stack carroInk() {
    return Stack(
      children: [
        SizedBox(
          height: 500,
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image.asset("assets/img/carro.png"),
          ),
        ),
        //Parte de cima do carro
        InkCustomStack(
          altura: 130,
          esquerda: 80,
          largura: 40,
          alturaCont: 40,
        ),
        InkCustomStack(
          altura: 120,
          esquerda: 180,
          largura: 60,
          alturaCont: 60,
        ),
        InkCustomStack(
          altura: 120,
          esquerda: 260,
          largura: 60,
          alturaCont: 60,
        ),
        InkCustomStack(
          altura: 100,
          esquerda: 90,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          altura: 170,
          esquerda: 90,
          largura: 40,
          alturaCont: 30,
        ),
        // Finalização da parte de cima

        //Frente do carro
        InkCustomStack(
          altura: 245,
          esquerda: 30,
          alturaCont: 30,
          largura: 20,
        ),
        InkCustomStack(
          altura: 240,
          esquerda: 50,
          alturaCont: 40,
          largura: 50,
        ),
        InkCustomStack(
          altura: 270,
          esquerda: 55,
          alturaCont: 30,
          largura: 40,
        ),
        InkCustomStack(
          altura: 245,
          esquerda: 100,
          alturaCont: 30,
          largura: 20,
        ),
        InkCustomStack(
          altura: 270,
          esquerda: 100,
          alturaCont: 40,
          largura: 20,
        ),
        InkCustomStack(
          altura: 265,
          esquerda: 30,
          alturaCont: 40,
          largura: 20,
        ),
        //Finalização da frente do carro

        //Parte de trás do carro
        InkCustomStack(
          baixo: 115,
          esquerda: 55,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 115,
          esquerda: 20,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 115,
          esquerda: 80,
          largura: 50,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 135,
          esquerda: 55,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 135,
          esquerda: 25,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 135,
          esquerda: 85,
          largura: 40,
          alturaCont: 30,
        ),
        //Finalização da parte de trás do carro

        //Lateral direita do carro
        InkCustomStack(
          baixo: 130,
          direita: 90,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 130,
          direita: 145,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 135,
          direita: 185,
          largura: 40,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 130,
          direita: 45,
          largura: 50,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 110,
          direita: 145,
          largura: 40,
          alturaCont: 25,
        ),
        InkCustomStack(
          baixo: 110,
          direita: 110,
          largura: 40,
          alturaCont: 25,
        ),
        InkCustomStack(
          baixo: 110,
          direita: 80,
          largura: 40,
          alturaCont: 25,
        ),
        InkCustomStack(
          baixo: 105,
          direita: 13,
          largura: 50,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 110,
          direita: 220,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 130,
          direita: 220,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 155,
          direita: 185,
          largura: 20,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 125,
          direita: 40,
          largura: 20,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 125,
          direita: 120,
          largura: 20,
          alturaCont: 30,
        ),

        //Finalização Lateral direita do carro

        //Inicio lateral esquerda
        InkCustomStack(
          baixo: 205,
          direita: 25,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 230,
          direita: 20,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 205,
          direita: 90,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 245,
          direita: 55,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 225,
          direita: 90,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 205,
          direita: 125,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 205,
          direita: 155,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 225,
          direita: 185,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 205,
          direita: 220,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 220,
          direita: 150,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 220,
          direita: 120,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 225,
          direita: 45,
          largura: 30,
          alturaCont: 30,
        ),
        InkCustomStack(
          baixo: 225,
          direita: 205,
          largura: 30,
          alturaCont: 30,
        )
      ],
    );
  }

  Stack camioneteInk() {
    return Stack(children: [
      SizedBox(
        height: 500,
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.asset("assets/img/camionete.png"),
        ),
      ),
      //Parte de cima da camionete
      InkCustomStack(
        baixo: 210,
        esquerda: 110,
        largura: 70,
        alturaCont: 60,
      ),
      InkCustomStack(
        baixo: 210,
        largura: 50,
        alturaCont: 50,
        esquerda: 20,
      ),
      InkCustomStack(
        baixo: 255,
        esquerda: 20,
        largura: 60,
        alturaCont: 30,
      ),
      InkCustomStack(
        baixo: 185,
        esquerda: 20,
        largura: 60,
        alturaCont: 30,
      ),
      InkCustomStack(
        baixo: 210,
        esquerda: 185,
        largura: 70,
        alturaCont: 60,
      ),
      //Finalizado parte de cima da camionete

      //Lateral esquerda camionete
      InkCustomStack(
        altura: 140,
        largura: 30,
        alturaCont: 30,
        esquerda: 30,
      ),
      InkCustomStack(
        altura: 140,
        largura: 30,
        alturaCont: 30,
        esquerda: 50,
      ),
      InkCustomStack(
        altura: 160,
        largura: 30,
        alturaCont: 30,
        esquerda: 20,
      ),
      InkCustomStack(
        altura: 150,
        largura: 30,
        alturaCont: 30,
        esquerda: 100,
      ),
      InkCustomStack(
        altura: 150,
        largura: 30,
        alturaCont: 30,
        esquerda: 70,
      ),
      InkCustomStack(
        altura: 150,
        largura: 30,
        alturaCont: 30,
        esquerda: 130,
      ),
      InkCustomStack(
        altura: 150,
        largura: 30,
        alturaCont: 30,
        esquerda: 155,
      ),
      InkCustomStack(
        altura: 145,
        largura: 30,
        alturaCont: 30,
        esquerda: 185,
      ),
      InkCustomStack(
        altura: 145,
        largura: 30,
        alturaCont: 30,
        esquerda: 213,
      ),
      InkCustomStack(
        altura: 155,
        largura: 30,
        alturaCont: 30,
        esquerda: 235,
      ),
      // Finalizado lateral esquerda do veiculo

      //Inicio lateral direita
      InkCustomStack(
        baixo: 105,
        alturaCont: 30,
        largura: 30,
        esquerda: 20,
      ),
      InkCustomStack(
        baixo: 120,
        alturaCont: 30,
        largura: 30,
        esquerda: 40,
      ),
      InkCustomStack(
        baixo: 120,
        alturaCont: 30,
        largura: 30,
        esquerda: 70,
      ),
      InkCustomStack(
        baixo: 110,
        alturaCont: 30,
        largura: 30,
        esquerda: 100,
      ),
      InkCustomStack(
        baixo: 110,
        alturaCont: 30,
        largura: 30,
        esquerda: 130,
      ),
      InkCustomStack(
        baixo: 110,
        alturaCont: 30,
        largura: 30,
        esquerda: 160,
      ),
      InkCustomStack(
        baixo: 110,
        alturaCont: 30,
        largura: 30,
        esquerda: 185,
      ),
      InkCustomStack(
        baixo: 120,
        alturaCont: 30,
        largura: 30,
        esquerda: 205,
      ),
      InkCustomStack(
        baixo: 120,
        alturaCont: 30,
        largura: 30,
        esquerda: 225,
      ),
      InkCustomStack(
        baixo: 100,
        alturaCont: 30,
        largura: 30,
        esquerda: 235,
      ),

      //Frente do veiculo
      InkCustomStack(
        altura: 170,
        direita: 55,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        altura: 170,
        direita: 80,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        altura: 170,
        direita: 30,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        altura: 150,
        direita: 30,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        altura: 150,
        direita: 55,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        altura: 150,
        direita: 80,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        altura: 135,
        direita: 55,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        altura: 135,
        direita: 80,
        alturaCont: 25,
        largura: 30,
      ),
      InkCustomStack(
        altura: 135,
        direita: 30,
        alturaCont: 25,
        largura: 30,
      ),
      //Finalizado parte da frente do veiculo

      //Inicio de trás do veiculo
      InkCustomStack(
        altura: 235,
        direita: 25,
        alturaCont: 25,
        largura: 25,
      ),
      InkCustomStack(
        altura: 235,
        direita: 45,
        alturaCont: 25,
        largura: 25,
      ),
      InkCustomStack(
        altura: 235,
        direita: 65,
        alturaCont: 25,
        largura: 25,
      ),
      InkCustomStack(
        altura: 235,
        direita: 85,
        alturaCont: 25,
        largura: 25,
      ),
      InkCustomStack(
        altura: 220,
        direita: 25,
        alturaCont: 25,
        largura: 25,
      ),
      InkCustomStack(
        altura: 220,
        direita: 45,
        alturaCont: 25,
        largura: 25,
      ),
      InkCustomStack(
        altura: 220,
        direita: 65,
        alturaCont: 25,
        largura: 25,
      ),
      InkCustomStack(
        altura: 220,
        direita: 85,
        alturaCont: 25,
        largura: 25,
      ),
    ]);
  }

  stackInk() {
    if (widget.ordemServico.vetorVeiculo == null) {
      return Screenshot(
        controller: controller,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [carroInk(), camioneteInk()],
          ),
        ),
      );
    } else {
      return Image.memory((widget.ordemServico.vetorVeiculo!));
    }
  }
}
