import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_funcionario.dart';

import '../modelo/contato.dart';
import '../widgets/text_form_field.dart';

class ContatoFuncForm extends StatefulWidget {
  ContatoFuncForm({super.key, this.controle, this.onSaved});
  ControleFuncionario? controle;
  Function()? onSaved;

  @override
  State<ContatoFuncForm> createState() => _ContatoFuncFormState();
}

class _ContatoFuncFormState extends State<ContatoFuncForm> {
  final _chaveForm = GlobalKey<FormState>();

  Widget _listaContatos(Contato contato, int indice) {
    return Container(
      decoration: const BoxDecoration(
          border: Border.symmetric(horizontal: BorderSide())),
      child: ListTile(
        title: Row(
          children: [
            SizedBox(
              width: 195,
            ),
            Text(
              contato.numero!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 260,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(contato.tipo!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext builder) {
                        // ignore: prefer_const_constructors
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          title: const Text('ATENÇÃO'),
                          content: const Text(
                            'Deseja realmente excluir este contato ?',
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    widget
                                        .controle!.funcionarioEmEdicao.contatos
                                        .removeWhere((element) =>
                                            element.numero == contato.numero);
                                    Navigator.of(context).pop();
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
                color: Colors.red,
              ),
            ],
          ),
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

  @override
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
                            maxlength: 14,
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
                            maxlength: 14,
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
                          widget.controle!.funcionarioEmEdicao.contatos
                              .add(contato);
                          setState(() {
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
                  child: widget.controle!.funcionarioEmEdicao.contatos.isEmpty
                      ? const Center(
                          child: Text(
                            'Não há contatos cadastrados',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget
                              .controle!.funcionarioEmEdicao.contatos.length,
                          itemBuilder: ((context, index) {
                            final Contato contato = widget
                                .controle!.funcionarioEmEdicao.contatos
                                .elementAt(index);
                            return _listaContatos(contato, index);
                          }))),
            ],
          ),
        ),
      ),
    );
  }
}
