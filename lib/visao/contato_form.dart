import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

import '../controle/controle_cliente.dart';
import '../modelo/contato.dart';

class ContatoForm extends StatefulWidget {
  ControlePessoa? controle;
  Function()? onSaved;
  ContatoForm({Key? key, this.controle, this.onSaved}) : super(key: key);

  @override
  State<ContatoForm> createState() => _ContatoFormState();
}

class _ContatoFormState extends State<ContatoForm> {
  final _chaveForm = GlobalKey<FormState>();
  Widget _listaContatos(Contato contato, int indice) {
    return Container(
      decoration: const BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide())),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 205, right: 205),
        title: Text(
          contato.numero!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: Text(
          contato.tipo!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  String? validar(text) {
    if (text == null || text.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Contato contato = Contato();
          showDialog(
              context: context,
              builder: (BuildContext builder) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  title: const Text('Cadastro Contato'),
                  content: Form(
                    key: _chaveForm,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width > 1000
                          ? (MediaQuery.of(context).size.width - 1000) / 2
                          : 10,
                      height: 170,
                      child: Column(
                        children: [
                          CustomTextField(
                            obscureText: false,
                            label: 'Número',
                            validator: validar,
                            onSaved: (String? value) {
                              contato.numero = value;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            label: 'Tipo',
                            obscureText: false,
                            validator: validar,
                            onSaved: (String? value) {
                              contato.tipo = value;
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    TextButton(
                        onPressed: () {
                          salvar(context);
                          widget.controle!.clienteEmEdicao.contatos
                              .add(contato);
                          setState(() {
                            widget.controle!.contatos.add(contato);
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text('Salvar'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: MediaQuery.of(context).size.width > 1000
                ? (MediaQuery.of(context).size.width - 1000) / 2
                : 10,
            right: MediaQuery.of(context).size.width > 1000
                ? (MediaQuery.of(context).size.width - 1000) / 2
                : 10),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 2)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(border: Border.all()),
                      child: const Center(
                        child: Text(
                          'Número',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(border: Border.all()),
                      child: const Center(
                        child: Text(
                          'Tipo',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: widget.controle!.contatosPesquisados,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    if (snapshot.hasData) {
                      widget.controle!.contatos =
                          snapshot.data as List<Contato>;

                      return ListView.builder(
                        itemCount: widget.controle!.contatos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _listaContatos(
                              widget.controle!.contatos[index], index);
                        },
                      );
                    }
                    return const Center(
                      child: Text('Carregando dados'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
