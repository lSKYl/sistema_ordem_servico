import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/visao/export_visao.dart';
import 'package:sistema_ordem_servico/visao/funcionario_dados.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
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
    return CustomListTile(
      object: funcionario,
      index: indice + 1,
      title: Text(
        funcionario.nome!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        funcionario.funcao!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      button1: () {
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
      button2: () {
        _controle.carregarFuncionario(funcionario).then((value) {
          _controle.funcionarioEmEdicao = value;
          _controle.excluirFuncionario().then((_) {
            Navigator.of(context).pop();
            setState(() {
              _controle.funcionarios.remove(funcionario);
            });
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
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
        label: const Text('Adicionar'),
        icon: const Icon(Icons.add),
      ),
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
