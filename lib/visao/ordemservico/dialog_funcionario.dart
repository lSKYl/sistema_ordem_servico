import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_funcionario.dart';
import 'package:sistema_ordem_servico/modelo/funcionario.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

class DialogFuncionario extends StatefulWidget {
  DialogFuncionario({super.key, required this.ordem, required this.callback});
  final OrdemServico ordem;
  Function() callback;

  @override
  State<DialogFuncionario> createState() => _DialogFuncionarioState();
}

class _DialogFuncionarioState extends State<DialogFuncionario> {
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  final ControleFuncionario _controleFuncionario = ControleFuncionario();

  @override
  void initState() {
    super.initState();
    setState(() {
      _controleFuncionario.pesquisarFuncionario();
    });
  }

  Widget _listaFuncionario() {
    return SizedBox(
      width: 500,
      height: 300,
      child: FutureBuilder(
        future: _controleFuncionario.funcionariosPesquisados,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          if (snapshot.hasData) {
            _controleFuncionario.funcionarios =
                snapshot.data as List<Funcionario>;

            return ListView.builder(
              itemCount: _controleFuncionario.funcionarios.length,
              itemBuilder: (context, index) {
                Funcionario funcionario =
                    _controleFuncionario.funcionarios[index];
                return SizedBox(
                  child: ListTileDialog(
                    object: funcionario,
                    nome: Text(funcionario.nome),
                    subtitulo: const Text(""),
                    indice: index + 1,
                    onTap: (() {
                      _controleFuncionario
                          .carregarFuncionario(funcionario)
                          .then((value) {
                        setState(() {
                          widget.ordem.funcionario = value;
                        });
                        widget.callback();
                        Navigator.pop(context);
                      });
                    }),
                  ),
                );
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
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: SearchFieldDialog(
            hint: "Escreva o funcionario que deseja pesquisar...",
            controller: _controladorCampoPesquisa,
            onChanged: (_) {
              setState(
                () {
                  _controleFuncionario.pesquisarFuncionario(
                      filtro: _controladorCampoPesquisa.text.toLowerCase());
                },
              );
            },
          ),
          content: _listaFuncionario(),
        );
      },
    );
  }
}
