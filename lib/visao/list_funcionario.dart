import 'package:flutter/material.dart';

import 'package:sistema_ordem_servico/visao/funcionario_dados.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/search_field_appBar.dart';

import 'package:sistema_ordem_servico/modelo/funcionario.dart';
import 'package:sistema_ordem_servico/controle/controle_funcionario.dart';

class ListFuncionario extends StatefulWidget {
  ListFuncionario({Key? key}) : super(key: key);

  @override
  State<ListFuncionario> createState() => _ListFuncionarioState();
}

class _ListFuncionarioState extends State<ListFuncionario> {
  final ControleFuncionario _controle = ControleFuncionario();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Lista de Funcionarios');
  bool funcionariosAtivos = true;
  bool funcionariosDesativados = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.pesquisarFuncionario();
    });
  }

  Widget _listaFuncionario(Funcionario funcionario, int indice) {
    return CustomListTile(
      registro: funcionario.registroAtivo,
      color: funcionario.registroAtivo
          ? Colors.white
          : Color.fromARGB(255, 136, 1, 1),
      object: funcionario,
      textoExcluir: "Deseja realmente excluir este funcionário ?",
      textoAtivar: "Deseja realmente ativar este funcionário ?",
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
                            _controle.pesquisarFuncionario();
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
      button3: () {
        _controle.carregarFuncionario(funcionario).then((value) {
          _controle.funcionarioEmEdicao = value;
          _controle.ativarFuncionario().then((_) {
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
                            _controle.pesquisarFuncionario();
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
        title: customSearchBar,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customSearchBar = SearchField(
                      controller: _controladorCampoPesquisa,
                      onChanged: ((text) {
                        setState(() {
                          if (funcionariosAtivos) {
                            _controle.pesquisarFuncionario(
                                filtro: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          } else if (funcionariosDesativados) {
                            _controle.pesquisarFuncionarioDesativado(
                                filtro: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          }
                        });
                      }),
                      hint: 'Digite o funcionário que deseja pesquisar...',
                    );
                  }
                });
              },
              icon: customIcon),
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
                                  _controle.pesquisarFuncionario();
                                });
                              },
                            )));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              children: [
                Radio(
                    value: true,
                    groupValue: funcionariosAtivos,
                    onChanged: (_) {
                      setState(() {
                        funcionariosAtivos = true;
                        funcionariosDesativados = false;
                        _controle.pesquisarFuncionario();
                      });
                    }),
                const Text("Funcionários ativos"),
                Radio(
                    value: true,
                    groupValue: funcionariosDesativados,
                    onChanged: (_) {
                      setState(() {
                        funcionariosAtivos = false;
                        funcionariosDesativados = true;
                        _controle.pesquisarFuncionarioDesativado();
                      });
                    }),
                const Text("Funcionários desativados")
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _controle.funcionariosPesquisados,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
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
          ),
        ],
      ),
    );
  }
}
