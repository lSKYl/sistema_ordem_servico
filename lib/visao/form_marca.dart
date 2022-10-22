import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_marca.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

class FormMarca extends StatefulWidget {
  ControleMarca? controle;
  Function()? onSaved;
  FormMarca({Key? key, this.controle, this.onSaved}) : super(key: key);

  @override
  State<FormMarca> createState() => _FormMarcaState();
}

class _FormMarcaState extends State<FormMarca> {
  final _chaveForm = GlobalKey<FormState>();

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();
      widget.controle?.salvarMarcaEmEdicao().then((_) {
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastro de Marcas'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          salvar(context);
        },
        label: const Text('Salvar'),
        icon: Icon(Icons.add),
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
          child: Column(children: [
            CustomTextField(
              label: 'Nome',
              obscureText: false,
              readonly: false,
              controller: TextEditingController(
                  text: widget.controle?.marcaEmEdicao.nome),
              onSaved: (String? value) {
                widget.controle?.marcaEmEdicao.nome = value;
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Este campo é obirgatório';
                }

                return null;
              },
              maxlength: 45,
            )
          ]),
        ),
      ),
    );
  }
}
