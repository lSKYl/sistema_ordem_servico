import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sistema_ordem_servico/controle/controle_marca_veiculo.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

class FormMarcaVeiculo extends StatefulWidget {
  ControleMarcaVeiculo? controleMarcaVeiculo;
  Function? onSaved;
  FormMarcaVeiculo({super.key, this.controleMarcaVeiculo, this.onSaved});

  @override
  State<FormMarcaVeiculo> createState() => _FormMarcaVeiculoState();
}

class _FormMarcaVeiculoState extends State<FormMarcaVeiculo> {
  final _chaveForm = GlobalKey<FormState>();

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();
      widget.controleMarcaVeiculo?.salvarMarcaEmEdicao().then((_) {
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
        title: const Text('Cadastro de Marcas de Veiculos'),
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
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            CustomTextField(
              label: 'Nome',
              obscureText: false,
              readonly: false,
              controller: TextEditingController(
                  text: widget.controleMarcaVeiculo?.marcaEmEdicao.nome),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Campo obrigatório';
                }
              },
              maxlength: 45,
              onSaved: (String? value) {
                widget.controleMarcaVeiculo?.marcaEmEdicao.nome = value;
              },
            )
          ]),
        ),
      ),
    );
  }
}
