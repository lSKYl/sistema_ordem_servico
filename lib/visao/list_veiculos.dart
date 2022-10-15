import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/modelo/veiculo.dart';
import 'package:sistema_ordem_servico/controle/controle_veiculo.dart';
import 'package:sistema_ordem_servico/visao/form_veiculo.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

class ListaVeiculo extends StatefulWidget {
  ListaVeiculo({super.key});

  @override
  State<ListaVeiculo> createState() => _ListaVeiculoState();
}

class _ListaVeiculoState extends State<ListaVeiculo> {
  final ControleVeiculo _controle = ControleVeiculo();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.carregarListaVeiculo();
    });
  }

  Widget _listaVeiculo(Veiculo veiculo, int indice) {
    return CustomListTile(
      object: veiculo,
      index: indice + 1,
      title: Text('${veiculo.modelo} ${veiculo.marca.nome} ${veiculo.placa}'),
      subtitle: Row(children: [
        if (veiculo.cliente.nome == '') ...[
          Text(veiculo.cliente.nomeFantasia!),
          Text(veiculo.cliente.cnpj!)
        ] else ...[
          Text(veiculo.cliente.nome!),
          Text(veiculo.cliente.cpf!)
        ]
      ]),
      button1: () {
        _controle.carregarVeiculo(veiculo).then((value) {
          _controle.veiculoEmEdicao = value;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => FormVeiculo(
                        controle: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.carregarListaVeiculo();
                          });
                        },
                      ))));
        });
      },
      button2: () {
        _controle.carregarVeiculo(veiculo).then((value) {
          _controle.veiculoEmEdicao = value;
          _controle.excluirVeiculo().then((_) {
            Navigator.of(context).pop();
            setState(() {
              _controle.veiculos.remove(veiculo);
            });
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Lista de veiculos'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _controle.veiculoEmEdicao = Veiculo();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormVeiculo(
                              controle: _controle,
                              onSaved: () {
                                setState(() {
                                  _controle.carregarListaVeiculo();
                                });
                              },
                            )));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _controle.veiculoEmEdicao = Veiculo();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormVeiculo(
                        controle: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.carregarListaVeiculo();
                          });
                        },
                      )));
        },
        label: const Text('Adicionar'),
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _controle.veiculosLista,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            if (snapshot.hasData) {
              _controle.veiculos = snapshot.data as List<Veiculo>;

              return ListView.builder(
                  itemCount: _controle.veiculos.length,
                  itemBuilder: ((context, index) {
                    return _listaVeiculo(_controle.veiculos[index], index);
                  }));
            }
            return const Center(
              child: Text('Carregando Dados'),
            );
          }),
    );
  }
}
