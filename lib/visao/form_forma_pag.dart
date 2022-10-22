import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_formapagamento.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

class FormFormaPag extends StatefulWidget {
  ControleFormaPagamento? controle;
  Function()? onSaved;
  FormFormaPag({super.key, this.controle, this.onSaved});

  @override
  State<FormFormaPag> createState() => _FormFormaPagState();
}

class _FormFormaPagState extends State<FormFormaPag> {
  final _chaveForm = GlobalKey<FormState>();

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();
      widget.controle?.salvarFormaEmEdicao().then((_) {
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.of(context).pop();
      });
    }
  }

  String? validar(text) {
    if (text == null || text.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastro de Formas de Pagamento'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          salvar(context);
        },
        label: const Text('Salvar'),
        icon: const Icon(Icons.add),
      ),
      body: Form(
        key: _chaveForm,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: MediaQuery.of(context).size.width > 1000
                  ? (MediaQuery.of(context).size.width - 1000) / 2
                  : 10,
              right: MediaQuery.of(context).size.width > 1000
                  ? (MediaQuery.of(context).size.width - 1000) / 2
                  : 10),
          child: Column(
            children: [
              CustomTextField(
                label: 'Nome',
                obscureText: false,
                readonly: false,
                validator: validar,
                onSaved: (String? value) {
                  widget.controle?.formaEmEdicao.nome = value;
                },
                maxlength: 45,
              )
            ],
          ),
        ),
      ),
    );
  }
}
