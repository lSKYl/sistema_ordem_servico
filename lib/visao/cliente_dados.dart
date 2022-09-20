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
            controle: widget.controle,
            onSaved: widget.onSaved,
          ),
          ContatoClienteForm(
            controle: widget.controle,
            onSaved: widget.onSaved,
          )
        ]),
      ),
    );
  }
}
