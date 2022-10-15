import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_cliente.dart';
import 'package:sistema_ordem_servico/modelo/pessoa.dart';
import 'package:sistema_ordem_servico/modelo/contato.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:string_validator/string_validator.dart';
import 'package:validatorless/validatorless.dart';
import 'package:intl/intl.dart';

class FormCliente extends StatefulWidget {
  ControlePessoa? controle;
  Function()? onSaved;
  FormCliente({Key? key, this.onSaved, this.controle}) : super(key: key);

  @override
  State<FormCliente> createState() => _FormClienteState();
}

class _FormClienteState extends State<FormCliente> {
  final _chaveForm = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  var formatterDate = DateFormat('dd/MM/yy');
  late String opEscolhida;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.controle!.clienteEmEdicao.cpf != '') {
        opEscolhida = 'fisica';
      } else {
        opEscolhida = 'juridica';
      }
      ;
    });
  }

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();

      widget.controle?.salvarClienteEmEdicao().then((_) {
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            salvar(context);
          },
          label: const Text('SALVAR'),
          icon: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
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
                // ignore: prefer_const_literals_to_create_immutables
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Radio(
                        value: "fisica",
                        groupValue: opEscolhida,
                        onChanged: (value) => setState(() {
                          widget.controle?.clienteEmEdicao.nomeFantasia = '';
                          widget.controle?.clienteEmEdicao.cnpj = '';
                          widget.controle?.clienteEmEdicao.ie = '';
                          opEscolhida = 'fisica';
                        }),
                      ),
                      const Text('Pessoa Fisica'),
                      // ignore: prefer_const_constructors
                      SizedBox(
                        width: 10,
                      ),
                      Radio(
                          value: 'juridica',
                          groupValue: opEscolhida,
                          onChanged: (value) => setState(() {
                                widget.controle?.clienteEmEdicao.nome = '';
                                widget.controle?.clienteEmEdicao.cpf = '';
                                widget.controle?.clienteEmEdicao.numeroRG = '';
                                opEscolhida = 'juridica';
                              })),
                      const Text('Pessoa Juridica'),

                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(formatterDate.format(
                              widget.controle!.clienteEmEdicao.dataCadastro)))
                    ],
                  ),
                  if (opEscolhida == 'fisica') ...[
                    // ignore: prefer_const_constructors
                    CustomTextField(
                      label: 'Nome',
                      readonly: false,
                      controller: TextEditingController(
                          text: widget.controle?.clienteEmEdicao.nome),
                      obscureText: false,
                      onSaved: (String? value) {
                        widget.controle?.clienteEmEdicao.nome = value;
                      },
                      validator: validar,
                      maxlength: 80,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      label: 'CPF',
                      obscureText: false,
                      readonly: false,
                      controller: TextEditingController(
                          text: widget.controle?.clienteEmEdicao.cpf),
                      onSaved: (String? value) {
                        widget.controle?.clienteEmEdicao.cpf = value;
                      },
                      validator: validar,
                      maxlength: 11,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      label: 'Numero RG',
                      obscureText: false,
                      readonly: false,
                      controller: TextEditingController(
                          text: widget.controle?.clienteEmEdicao.numeroRG),
                      onSaved: (String? value) {
                        widget.controle?.clienteEmEdicao.numeroRG = value;
                      },
                      maxlength: 9,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ] else if (opEscolhida == 'juridica') ...[
                    CustomTextField(
                      label: 'Nome Fantasia',
                      obscureText: false,
                      readonly: false,
                      controller: TextEditingController(
                          text: widget.controle?.clienteEmEdicao.nomeFantasia),
                      validator: validar,
                      onSaved: (String? value) {
                        widget.controle?.clienteEmEdicao.nomeFantasia = value;
                      },
                      maxlength: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      label: 'CNPJ',
                      obscureText: false,
                      readonly: false,
                      validator: validar,
                      onSaved: (String? value) {
                        widget.controle?.clienteEmEdicao.cnpj = value;
                      },
                      controller: TextEditingController(
                          text: widget.controle?.clienteEmEdicao.cnpj),
                      maxlength: 14,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      label: 'IE',
                      obscureText: false,
                      readonly: false,
                      onSaved: (String? value) {
                        widget.controle?.clienteEmEdicao.ie = value;
                      },
                      controller: TextEditingController(
                          text: widget.controle?.clienteEmEdicao.ie),
                      maxlength: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                  CustomTextField(
                    label: 'Endereço',
                    obscureText: false,
                    readonly: false,
                    onSaved: (String? value) {
                      widget.controle?.clienteEmEdicao.endereco = value;
                    },
                    controller: TextEditingController(
                        text: widget.controle?.clienteEmEdicao.endereco),
                    maxlength: 80,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    label: 'Bairro',
                    obscureText: false,
                    readonly: false,
                    onSaved: (String? value) {
                      widget.controle?.clienteEmEdicao.bairro = value;
                    },
                    controller: TextEditingController(
                        text: widget.controle?.clienteEmEdicao.bairro),
                    maxlength: 45,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    label: 'Complemento',
                    obscureText: false,
                    readonly: false,
                    onSaved: (String? value) {
                      widget.controle?.clienteEmEdicao.complemento = value;
                    },
                    controller: TextEditingController(
                        text: widget.controle?.clienteEmEdicao.complemento),
                    maxlength: 45,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    label: 'Cidade',
                    obscureText: false,
                    readonly: false,
                    onSaved: (String? value) {
                      widget.controle?.clienteEmEdicao.cidade = value;
                    },
                    controller: TextEditingController(
                        text: widget.controle?.clienteEmEdicao.cidade),
                    maxlength: 45,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    label: 'UF',
                    obscureText: false,
                    readonly: false,
                    onSaved: (String? value) {
                      widget.controle?.clienteEmEdicao.uf = value;
                    },
                    controller: TextEditingController(
                        text: widget.controle?.clienteEmEdicao.uf),
                    maxlength: 15,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    label: 'CEP',
                    obscureText: false,
                    readonly: false,
                    onSaved: (String? value) {
                      widget.controle?.clienteEmEdicao.cep = value;
                    },
                    maxlength: 8,
                    controller: TextEditingController(
                        text: widget.controle?.clienteEmEdicao.cep),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    label: 'Email',
                    obscureText: false,
                    readonly: false,
                    onSaved: (String? value) {
                      widget.controle?.clienteEmEdicao.email = value;
                    },
                    controller: TextEditingController(
                        text: widget.controle?.clienteEmEdicao.email),
                    maxlength: 40,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: 'Skype',
                    obscureText: false,
                    readonly: false,
                    onSaved: (String? value) {
                      widget.controle?.clienteEmEdicao.skype = value;
                    },
                    controller: TextEditingController(
                        text: widget.controle?.clienteEmEdicao.skype),
                    maxlength: 40,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    label: 'OBS',
                    obscureText: false,
                    readonly: false,
                    maxlines: 5,
                    onSaved: (String? value) {
                      widget.controle?.clienteEmEdicao.obs = value;
                    },
                    controller: TextEditingController(
                        text: widget.controle?.clienteEmEdicao.obs),
                    maxlength: 300,
                  )
                ]),
              ),
            ),
          ],
        ));
  }
}
