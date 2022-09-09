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

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.carregarLista();
    });
  }

  Widget _listaMarca(Marca marca) {
    return Card(
      elevation: 15,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              marca.id.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: Row(
            children: [
              Text(
                marca.nome!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(children: [
              IconButton(
                onPressed: () {
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
                icon: Icon(Icons.edit),
                color: Colors.orange,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext builder) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          title: const Text('ATENÇÃO'),
                          content: const Text(
                            'Deseja realmente excluir esta marca ?',
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _controle.carregarMarca(marca).then(
                                    (value) {
                                      _controle.marcaEmEdicao = value;
                                      _controle
                                          .excluirMarcaEmEdicao()
                                          .then((_) {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _controle.marcas.remove(marca);
                                        });
                                      });
                                    },
                                  );
                                },
                                child: Text('SIM')),
                            const SizedBox(
                              width: 20,
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('NÃO'))
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              )
            ]),
          ),
          // ignore: dead_code
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: Text('Lista de Marcas'),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
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
                icon: Icon(Icons.add))
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
        body: FutureBuilder(
            future: _controle.marcasPesquisadas,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasError) {
                return new Text("${snapshot.error}");
              }
              if (snapshot.hasData) {
                _controle.marcas = snapshot.data as List<Marca>;

                return ListView.builder(
                    itemCount: _controle.marcas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _listaMarca(_controle.marcas[index]);
                    });
              }
              return Center(child: Text('Carregando dados'));
            }));
  }
}
