import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_marca.dart';

import 'package:sistema_ordem_servico/modelo/marca.dart';

import 'package:sistema_ordem_servico/visao/form_marca.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/search_field_appBar.dart';

class ListMarca extends StatefulWidget {
  const ListMarca({Key? key}) : super(key: key);

  @override
  State<ListMarca> createState() => _ListMarcaState();
}

class _ListMarcaState extends State<ListMarca> {
  final ControleMarca _controle = ControleMarca();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Lista de Marcas');

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.pesquisarMarcas();
    });
  }

  Widget _listaMarca(Marca marca, int indice) {
    return CustomListTile(
      object: marca,
      index: indice + 1,
      title: Text(
        marca.nome,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      button1: () {
        _controle.carregarMarca(marca).then((value) {
          _controle.marcaEmEdicao = value;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormMarca(
                        controle: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.pesquisarMarcas();
                          });
                        },
                      )));
        });
      },
      button2: () {
        _controle.carregarMarca(marca).then(
          (value) {
            _controle.marcaEmEdicao = value;
            _controle.excluirMarcaEmEdicao().then((_) {
              Navigator.of(context).pop();
              setState(() {
                _controle.marcas.remove(marca);
              });
            });
          },
        );
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
                        onChanged: (text) {
                          setState(() {
                            _controle.pesquisarMarcas(
                                filtroPesquisa: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          });
                        },
                        hint: 'Digite a marca que deseja pesquisar...',
                      );
                    } else {
                      customIcon = const Icon(Icons.search);
                      customSearchBar = const Text('Lista de Marcas');
                    }
                  });
                },
                icon: customIcon),
            IconButton(
                onPressed: () {
                  _controle.marcaEmEdicao = Marca();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FormMarca(
                                controle: _controle,
                                onSaved: () {
                                  setState(() {
                                    _controle.pesquisarMarcas();
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
            _controle.marcaEmEdicao = Marca();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FormMarca(
                          controle: _controle,
                          onSaved: () {
                            setState(() {
                              _controle.pesquisarMarcas();
                            });
                          },
                        )));
          },
          icon: const Icon(Icons.add),
          label: const Text('Adicionar'),
        ),
        body: FutureBuilder(
            future: _controle.marcasPesquisadas,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              if (snapshot.hasData) {
                _controle.marcas = snapshot.data as List<Marca>;

                return ListView.builder(
                    itemCount: _controle.marcas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _listaMarca(_controle.marcas[index], index);
                    });
              }
              return const Center(child: Text('Carregando dados'));
            }));
  }
}
