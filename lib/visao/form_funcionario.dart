import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ordem_servico/controle/controle_funcionario.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

class FormFuncionario extends StatefulWidget {
  ControleFuncionario? controle;
  Function()? onSaved;
  FormFuncionario({Key? key, this.controle, this.onSaved}) : super(key: key);

  @override
  State<FormFuncionario> createState() => _FormFuncionarioState();
}

class _FormFuncionarioState extends State<FormFuncionario> {
  final _chaveForm = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  var formatterDate = DateFormat('dd/MM/yy');

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();

      widget.controle?.salvarFuncionarioEmEdicao().then((_) {
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          salvar(context);
        },
        label: const Text('Salvar'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: MediaQuery.of(context).size.width > 1000
                  ? (MediaQuery.of(context).size.width - 1000) / 2
                  : 10,
              right: MediaQuery.of(context).size.width > 1000
                  ? (MediaQuery.of(context).size.width - 1000) / 2
                  : 10),
          child: Form(
            key: _chaveForm,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Data Cadastrado: '),
                  Text(formatterDate.format(
                      widget.controle!.funcionarioEmEdicao.dataCadastro)),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Nome',
                obscureText: false,
                readonly: false,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Campo obrigatório';
                  }
                },
                controller: TextEditingController(
                    text: widget.controle?.funcionarioEmEdicao.nome),
                onSaved: (String? value) {
                  widget.controle?.funcionarioEmEdicao.nome = value;
                },
                maxlength: 80,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Funcão',
                obscureText: false,
                readonly: false,
                controller: TextEditingController(
                    text: widget.controle!.funcionarioEmEdicao.funcao),
                onSaved: (String? value) {
                  widget.controle?.funcionarioEmEdicao.funcao = value;
                },
                maxlength: 40,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Endereço',
                obscureText: false,
                readonly: false,
                onSaved: (String? value) {
                  widget.controle?.funcionarioEmEdicao.endereco = value;
                },
                controller: TextEditingController(
                    text: widget.controle?.funcionarioEmEdicao.endereco),
                maxlength: 80,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Bairro',
                obscureText: false,
                readonly: false,
                onSaved: (String? value) {
                  widget.controle?.funcionarioEmEdicao.bairro = value;
                },
                controller: TextEditingController(
                    text: widget.controle?.funcionarioEmEdicao.bairro),
                maxlength: 45,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Obs',
                obscureText: false,
                readonly: false,
                maxlines: 5,
                controller: TextEditingController(
                    text: widget.controle?.funcionarioEmEdicao.obs),
                onSaved: (String? value) {
                  widget.controle?.funcionarioEmEdicao.obs = value;
                },
                maxlength: 300,
              )
            ]),
          ),
        )
      ]),
    );
  }
}
