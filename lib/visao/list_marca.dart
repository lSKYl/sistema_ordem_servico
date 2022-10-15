import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_marca.dart';
import 'package:sistema_ordem_servico/dao/marca_dao.dart';
import 'package:sistema_ordem_servico/modelo/marca.dart';
import 'package:sistema_ordem_servico/visao/export_visao.dart';
import 'package:sistema_ordem_servico/visao/form_marca.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

class ListMarca extends StatefulWidget {
  ListMarca({Key? key}) : super(key: key);

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
      _controle.carregarLista();
    });
  }

  Widget _listaMarca(Marca marca, int indice) {
    return CustomListTile(
      object: marca,
      index: indice + 1,
      title: Text(
        marca.nome!,
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
                            _controle.carregarLista();
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
                  // setState(() {
                  //   if (customIcon.icon == Icons.search) {
                  //     customIcon = const Icon(Icons.cancel);
                  //     customSearchBar = ListTile(
                  //       leading: const Icon(
                  //         Icons.search,
                  //         color: Colors.white,
                  //         size: 28,
                  //       ),
                  //       title: TextField(
                  //         controller: _controladorCampoPesquisa,
                  //         onChanged: ((value) {
                  //           _controladorCampoPesquisa.text = value;
                  //           _controle.pesquisarMarcas(
                  //               filtroPesquisa: _controladorCampoPesquisa.text);
                  //           setState(() {});
                  //         }),
                  //         decoration: const InputDecoration(
                  //           hintText: 'Digite a marca que deseja pesquisar...',
                  //           hintStyle: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 18,
                  //             fontStyle: FontStyle.italic,
                  //           ),
                  //           border: InputBorder.none,
                  //         ),
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     );
                  //   } else {
                  //     customIcon = const Icon(Icons.search);
                  //     customSearchBar = const Text('Lista de Marcas');
                  //   }
                  // });
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
                                    _controle.carregarLista();
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
                              _controle.carregarLista();
                            });
                          },
                        )));
          },
          icon: const Icon(Icons.add),
          label: const Text('Adicionar'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _controladorCampoPesquisa,
              onChanged: ((value) {
                setState(() {
                  _controle.pesquisarMarcas(filtroPesquisa: value);
                });
              }),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                  future: _controle.marcasPesquisadas,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
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
                  }),
            ),
          ],
        ));
  }
}
