import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/visao/export_visao.dart';
import 'package:sistema_ordem_servico/visao/funcionario_dados.dart';
import 'form_funcionario.dart';
import 'package:sistema_ordem_servico/modelo/funcionario.dart';
import 'package:sistema_ordem_servico/controle/controle_funcionario.dart';

class ListFuncionario extends StatefulWidget {
  ListFuncionario({Key? key}) : super(key: key);

  @override
  State<ListFuncionario> createState() => _ListFuncionarioState();
}

class _ListFuncionarioState extends State<ListFuncionario> {
  final ControleFuncionario _controle = ControleFuncionario();

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.carregarLista();
    });
  }

  Widget _listaFuncionario(Funcionario funcionario, int indice) {
    return Card(
        elevation: 15,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                "${indice + 1}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(funcionario.nome!),
            subtitle: Text(funcionario.funcao!),
            trailing: Container(
              width: 100,
              child: Row(children: [
                IconButton(
                  onPressed: () {
                    _controle.carregarFuncionario(funcionario).then((value) {
                      _controle.funcionarioEmEdicao = value;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FuncionarioDados(
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
                          // ignore: prefer_const_constructors
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            title: const Text('ATENÇÃO'),
                            content: const Text(
                              'Deseja realmente excluir este funcionario ?',
                              textAlign: TextAlign.center,
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _controle
                                        .carregarFuncionario(funcionario)
                                        .then((value) {
                                      _controle.funcionarioEmEdicao = value;
                                      _controle.excluirFuncionario().then((_) {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _controle.funcionarios
                                              .remove(funcionario);
                                        });
                                      });
                                    });
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
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lista de Funcionarios'),
        actions: [
          IconButton(
              onPressed: () {
                _controle.funcionarioEmEdicao = Funcionario();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FuncionarioDados(
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
      body: FutureBuilder(
        future: _controle.funcionariosPesquisados,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          if (snapshot.hasData) {
            _controle.funcionarios = snapshot.data as List<Funcionario>;

            return ListView.builder(
                itemCount: _controle.funcionarios.length,
                itemBuilder: (BuildContext context, int index) {
                  return _listaFuncionario(
                      _controle.funcionarios[index], index);
                });
          }
          return Center(
            child: Text('Carregando dados'),
          );
        },
      ),
    );
  }
}
