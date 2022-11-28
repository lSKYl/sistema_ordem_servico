import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_veiculo.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

import '../../modelo/veiculo.dart';

class OrdemDialogVeiculos extends StatefulWidget {
  OrdemDialogVeiculos(
      {super.key, required this.ordemServico, required this.callback});
  final OrdemServico ordemServico;
  Function() callback;

  @override
  State<OrdemDialogVeiculos> createState() => _OrdemDialogVeiculosState();
}

class _OrdemDialogVeiculosState extends State<OrdemDialogVeiculos> {
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();

  final ControleVeiculo _controleVeiculo = ControleVeiculo();

  @override
  void initState() {
    super.initState();
    setState(() {
      _controleVeiculo.pesquisarVeiculo();
    });
  }

  Widget _listaVeiculo() {
    return SizedBox(
      width: 500,
      height: 300,
      child: FutureBuilder(
        future: _controleVeiculo.veiculosLista,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("${snapshot.error}");

          if (snapshot.hasData) {
            _controleVeiculo.veiculos = snapshot.data as List<Veiculo>;

            return ListView.builder(
              itemCount: _controleVeiculo.veiculos.length,
              itemBuilder: (context, index) {
                Veiculo veiculo = _controleVeiculo.veiculos[index];
                return SizedBox(
                    child: ListTileDialog(
                  object: veiculo,
                  nome: Text("${veiculo.modelo} ${veiculo.marca.nome}"),
                  subtitulo: veiculo.cliente.nome == ""
                      ? Text(
                          "${veiculo.cliente.nomeFantasia} CNPJ: ${veiculo.cliente.cnpj}")
                      : Text(
                          "${veiculo.cliente.nome} CPF: ${veiculo.cliente.cpf}"),
                  indice: index + 1,
                  onTap: (() {
                    _controleVeiculo.carregarVeiculo(veiculo).then((value) {
                      widget.ordemServico.veiculo.id = veiculo.id;
                      widget.ordemServico.veiculo.modelo = value.modelo;
                      widget.ordemServico.veiculo.marca = value.marca;
                      widget.ordemServico.veiculo.cor = value.cor;
                      widget.ordemServico.veiculo.placa = value.placa;
                      widget.ordemServico.veiculo.tipodeVeiculo =
                          value.tipodeVeiculo;
                      widget.callback();
                      Navigator.pop(context);
                    });
                  }),
                ));
              },
            );
          }

          return const Center(child: Text('Carregando dados'));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: ((context, setState) {
      return AlertDialog(
        title: SearchFieldDialog(
          controller: _controladorCampoPesquisa,
          onChanged: (text) {
            setState(
              () {
                _controleVeiculo.pesquisarVeiculo(
                    filtro: _controladorCampoPesquisa.text.toLowerCase());
                setState;
              },
            );
          },
        ),
        content: _listaVeiculo(),
      );
    }));
  }
}
