import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_marca.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:string_validator/string_validator.dart';

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
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            CustomTextField(
              label: 'Nome',
              obscureText: false,
              initialvalue: widget.controle?.marcaEmEdicao.nome,
              icon: Icon(Icons.branding_watermark),
              onSaved: (String? value) {
                widget.controle?.marcaEmEdicao.nome = value;
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Este campo é obirgatório';
                }
                if (text.length > 25) {
                  return 'Limite caracteres atingido';
                }
                return null;
              },
            )
          ]),
        ),
      ),
    );
  }
}
