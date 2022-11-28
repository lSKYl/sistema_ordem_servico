import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_marca_veiculo.dart';

import 'package:sistema_ordem_servico/modelo/marcaveiculo.dart';
import 'package:sistema_ordem_servico/visao/form_marca_veiculo.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/search_field_appBar.dart';

class ListMarcaVeiculo extends StatefulWidget {
  const ListMarcaVeiculo({super.key});

  @override
  State<ListMarcaVeiculo> createState() => _ListMarcaVeiculoState();
}

class _ListMarcaVeiculoState extends State<ListMarcaVeiculo> {
  final ControleMarcaVeiculo _controle = ControleMarcaVeiculo();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Lista de Marcas de Veiculos');

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.pesquisarMarcas();
    });
  }

  Widget _listaMarca(MarcaVeiculo marca, int indice) {
    return CustomListTile(
      object: marca,
      textoExcluir: "Deseja realmente excluir está marca ?",
      index: indice + 1,
      title: Text(
        marca.nome!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      button1: () {
        _controle.carregarMarca(marca).then((value) {
          _controle.marcaEmEdicao = value;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => FormMarcaVeiculo(
                        controleMarcaVeiculo: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.pesquisarMarcas();
                          });
                        },
                      ))));
        });
      },
      button2: () {
        _controle.carregarMarca(marca).then((value) {
          _controle.marcaEmEdicao = value;
          _controle.excluirMarcaEmEdicao().then((_) {
            Navigator.of(context).pop();
            setState(() {
              _controle.marcas.remove(marca);
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
        title: customSearchBar,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = SearchField(
                      controller: _controladorCampoPesquisa,
                      onChanged: ((text) {
                        setState(() {
                          _controle.pesquisarMarcas(
                              filtropesquisa:
                                  _controladorCampoPesquisa.text.toLowerCase());
                        });
                      }),
                      hint: 'Digite a marca que deseja pesquisar...',
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Lista de Marcas de Veiculos');
                  }
                });
              },
              icon: customIcon),
          IconButton(
              onPressed: () {
                _controle.marcaEmEdicao = MarcaVeiculo();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => FormMarcaVeiculo(
                              controleMarcaVeiculo: _controle,
                              onSaved: () {
                                setState(() {
                                  _controle.pesquisarMarcas();
                                });
                              },
                            ))));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (() {
          _controle.marcaEmEdicao = MarcaVeiculo();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => FormMarcaVeiculo(
                        controleMarcaVeiculo: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.pesquisarMarcas();
                          });
                        },
                      ))));
        }),
        label: const Text('Adicionar'),
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _controle.marcasPesquisadas,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            if (snapshot.hasData) {
              _controle.marcas = snapshot.data as List<MarcaVeiculo>;

              return ListView.builder(
                  itemCount: _controle.marcas.length,
                  itemBuilder: ((context, index) {
                    return _listaMarca(_controle.marcas[index], index);
                  }));
            }
            return const Center(
              child: Text('Carregando dados'),
            );
          }),
    );
  }
}
