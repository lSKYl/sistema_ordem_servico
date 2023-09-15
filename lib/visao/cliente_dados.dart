import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/visao/contato_form_cliente.dart';
import 'package:sistema_ordem_servico/visao/export_visao.dart';

import '../controle/controle_cliente.dart';

class ClienteDados extends StatefulWidget {
  ClienteDados({Key? key, required this.controle, this.onSaved})
      : super(key: key);
  ControlePessoa controle;
  Function()? onSaved;

  @override
  State<ClienteDados> createState() => _ClienteDadosState();
}

class _ClienteDadosState extends State<ClienteDados> {
  final _chaveForm = GlobalKey<FormState>();

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();

      widget.controle.salvarClienteEmEdicao().then((_) {
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Cliente'),
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
          FormCliente(
            salvar: salvar,
            chaveForm: _chaveForm,
            controle: widget.controle,
            onSaved: widget.onSaved,
          ),
          ContatoClienteForm(
            chaveForm: _chaveForm,
            controle: widget.controle,
            onSaved: widget.onSaved,
          )
        ]),
      ),
    );
  }
}
