import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_funcionario.dart';
import 'package:sistema_ordem_servico/visao/contato_form_func.dart';
import 'package:sistema_ordem_servico/visao/form_funcionario.dart';

class FuncionarioDados extends StatefulWidget {
  FuncionarioDados({super.key, required this.controle, this.onSaved});
  ControleFuncionario controle;
  Function()? onSaved;

  @override
  State<FuncionarioDados> createState() => _FuncionarioDadosState();
}

class _FuncionarioDadosState extends State<FuncionarioDados> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Funcionário'),
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.phone),
              )
            ]),
          ),
          body: TabBarView(children: [
            FormFuncionario(
              controle: widget.controle,
              onSaved: widget.onSaved,
            ),
            ContatoFuncForm(
              controle: widget.controle,
              onSaved: widget.onSaved,
            )
          ]),
        ));
  }
}
