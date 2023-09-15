import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_cliente.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:validatorless/validatorless.dart';
import 'package:intl/intl.dart';

class FormCliente extends StatefulWidget {
  GlobalKey<FormState> chaveForm = GlobalKey<FormState>();
  ControlePessoa? controle;
  Future<void> Function(BuildContext) salvar;
  Function()? onSaved;
  FormCliente(
      {Key? key,
      this.onSaved,
      this.controle,
      required this.chaveForm,
      required this.salvar})
      : super(key: key);

  @override
  State<FormCliente> createState() => _FormClienteState();
}

class _FormClienteState extends State<FormCliente> {
  DateTime date = DateTime.now();
  var formatterDate = DateFormat('dd/MM/yy');
  late String opEscolhida;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.controle!.clienteEmEdicao.cpf == '' &&
          widget.controle!.clienteEmEdicao.cnpj == '') {
        opEscolhida = 'fisica';
      } else if (widget.controle!.clienteEmEdicao.cpf != '') {
        opEscolhida = 'fisica';
      } else {
        opEscolhida = 'juridica';
      }
      ;
    });
  }

  String? validar(text) {
    if (text == null || text.isEmpty) {
      return 'Campo obrigatório!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            widget.salvar(context);
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
                key: widget.chaveForm,
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
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.nome = text;
                      },
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
                        validator: Validatorless.multiple([
                          Validatorless.required("Campo obrigatório!"),
                          Validatorless.cpf("Esse CPF não é valido!")
                        ]),
                        maxlength: 11,
                        onChanged: (text) {
                          widget.controle!.clienteEmEdicao.cpf = text;
                        }),
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
                        onChanged: (text) {
                          widget.controle!.clienteEmEdicao.numeroRG = text;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                  ] else if (opEscolhida == 'juridica') ...[
                    CustomTextField(
                        label: 'Nome Fantasia',
                        obscureText: false,
                        readonly: false,
                        controller: TextEditingController(
                            text:
                                widget.controle?.clienteEmEdicao.nomeFantasia),
                        validator: validar,
                        onSaved: (String? value) {
                          widget.controle?.clienteEmEdicao.nomeFantasia = value;
                        },
                        maxlength: 100,
                        onChanged: (text) {
                          widget.controle!.clienteEmEdicao.nomeFantasia = text;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        label: 'CNPJ',
                        obscureText: false,
                        readonly: false,
                        validator: Validatorless.multiple([
                          Validatorless.required("Campo obrigatório!"),
                          Validatorless.cnpj("Esse CNPJ não é valido!")
                        ]),
                        onSaved: (String? value) {
                          widget.controle?.clienteEmEdicao.cnpj = value;
                        },
                        controller: TextEditingController(
                            text: widget.controle?.clienteEmEdicao.cnpj),
                        maxlength: 14,
                        onChanged: (text) {
                          widget.controle!.clienteEmEdicao.cnpj = text;
                        }),
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
                        onChanged: (text) {
                          widget.controle!.clienteEmEdicao.ie = text;
                        }),
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
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.endereco = text;
                      }),
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
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.bairro = text;
                      }),
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
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.complemento = text;
                      }),
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
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.cidade = text;
                      }),
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
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.uf = text;
                      }),
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
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.cep = text;
                      }),
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
                      validator: Validatorless.multiple(
                          [Validatorless.email("Esse email não é valido!")]),
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.email = text;
                      }),
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
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.skype = text;
                      }),
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
                      onChanged: (text) {
                        widget.controle!.clienteEmEdicao.obs = text;
                      })
                ]),
              ),
            ),
          ],
        ));
  }
}
