import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ordem_servico/controle/controle_cliente.dart';
import 'package:sistema_ordem_servico/controle/controle_ordemservico.dart';
import 'package:sistema_ordem_servico/controle/controle_produto.dart';
import 'package:sistema_ordem_servico/controle/controle_veiculo.dart';
import 'package:sistema_ordem_servico/pdfs/ordem_servico_pdf.dart';
import 'package:sistema_ordem_servico/visao/ordemservico/datatable_formapagamento.dart';
import 'package:sistema_ordem_servico/visao/ordemservico/dialog_funcionario.dart';
import 'package:sistema_ordem_servico/visao/ordemservico/stackcarroecamionete.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'export_ordemservico.dart';
import 'package:screenshot/screenshot.dart';

class FormOrdemServico extends StatefulWidget {
  FormOrdemServico({super.key, this.controle, this.onSaved});
  ControleOrdemServico? controle;
  Function()? onSaved;

  @override
  State<FormOrdemServico> createState() => _FormOrdemServicoState();
}

class _FormOrdemServicoState extends State<FormOrdemServico> {
  final _chaveForm = GlobalKey<FormState>();
  late TextEditingController valorEntrada = TextEditingController(
      text: widget.controle!.ordemServicoEmEdicao.valorEntrada
          .toStringAsFixed(2)
          .replaceAll('.', ','));
  final ControlePessoa _controlePessoa = ControlePessoa();
  final ControleVeiculo _controleVeiculo = ControleVeiculo();
  final ControleProdutoServico _controleProdutoServico =
      ControleProdutoServico();
  DateTime date = DateTime.now();
  var formatterData = DateFormat('dd/MM/yy');
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  static const _locale = 'pt_Br';
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  final PdfInvoiceService service = PdfInvoiceService();
  List<int> prazo = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  int number = 0;
  Uint8List? bytes;
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();

      widget.controle?.salvarOrdemEmEdicao().then((_) {
        if (widget.onSaved != null) widget.onSaved!();
      });
    }
  }

  String? validar(text) {
    if (text == null || text.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  TextInputFormatter formatadorNumeros() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*'));
  }

  TextInputFormatter formatadorVirgula() {
    return TextInputFormatter.withFunction(
      (oldValue, newValue) => newValue.copyWith(
        text: newValue.text.replaceAll('.', ','),
      ),
    );
  }

  callback() {
    setState(() {
      FormOrdemServico;
    });
  }

  StatefulBuilder ordemBloqueada() {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text("Atenção!"),
          content: const Text(
              "A ordem de serviço ja foi finalizada, \npara voltar a edita-la ela precisa ser reaberta, \ndeseja reabrir ela ?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Não")),
            TextButton(
                onPressed: () {
                  setState(
                    () {
                      widget.controle!.ordemServicoEmEdicao.situacaoAtual =
                          "Em andamento";
                      callback();
                      Navigator.pop(context);
                    },
                  );
                },
                child: const Text("Sim"))
          ],
        );
      },
    );
  }

  _datePickerDialog() {
    return showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2022),
            lastDate: DateTime(2050))
        .then((value) {
      if (value == null) return;

      setState(() {
        date = value;

        widget.controle!.ordemServicoEmEdicao.previsaoEntrega = date;
      });
    });
  }

  ScreenshotController controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ordem de Serviço'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: [
          if (widget.controle!.ordemServicoEmEdicao.situacaoAtual !=
              "Finalizado")
            (FloatingActionButton.extended(
              onPressed: () {
                salvar(context);
              },
              label: const Text('Salvar'),
              icon: const Icon(Icons.add),
            )),
          const SizedBox(height: 10),
          if (widget.controle!.ordemServicoEmEdicao.id > 0) ...[
            FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  if (widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                      "Em andamento") {
                    widget.controle!.ordemServicoEmEdicao.situacaoAtual =
                        "Finalizado";
                  } else {
                    widget.controle!.ordemServicoEmEdicao.situacaoAtual =
                        "Em andamento";
                  }
                });
              },
              label: widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                      "Em andamento"
                  ? const Text("Finalizar ordem de serviço")
                  : const Text("Reabrir ordem de serviço"),
              icon: widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                      "Em andamento"
                  ? const Icon(Icons.lock)
                  : const Icon(Icons.lock_open),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              onPressed: () async {
                final data = await service
                    .createOrdemServico(widget.controle!.ordemServicoEmEdicao);
                service.savePdfFile("ordem_servico$number", data);
                number++;
              },
              label: const Text("Imprimir"),
              icon: const Icon(Icons.print),
            )
          ]
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width > 1400
                ? (MediaQuery.of(context).size.width - 1400) / 2
                : 10,
            right: MediaQuery.of(context).size.width > 1400
                ? (MediaQuery.of(context).size.width - 1400) / 2
                : 10,
            top: 10,
            bottom: 10,
          ),
          child: Form(
            key: _chaveForm,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 165,
                        child: CustomTextField(
                          label: 'Data de Cadastro',
                          obscureText: false,
                          readonly: true,
                          controller: TextEditingController(
                              text: formatterData.format(widget.controle!
                                  .ordemServicoEmEdicao.dataCadastro)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        width: 165,
                        child: CustomTextField(
                          label: 'Previsão de Entrega',
                          obscureText: false,
                          readonly: true,
                          onTap: () {
                            if (widget.controle!.ordemServicoEmEdicao
                                    .situacaoAtual ==
                                "Em andamento") {
                              setState(() {
                                _datePickerDialog();
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return ordemBloqueada();
                                  }));
                            }
                          },
                          controller: TextEditingController(
                              text: formatterData.format(widget.controle!
                                  .ordemServicoEmEdicao.previsaoEntrega)),
                          hint: "Escolha uma data!",
                          validator: validar,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "Nome do Cliente",
                  obscureText: false,
                  readonly: true,
                  validator: validar,
                  onTap: (() {
                    if (widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                        "Em andamento") {
                      showDialog(
                          context: context,
                          builder: (BuildContext builder) {
                            return OrdemDialogCliente(
                                ordem: widget.controle!.ordemServicoEmEdicao,
                                callback: callback);
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return ordemBloqueada();
                          }));
                    }
                  }),
                  controller: TextEditingController(
                      text: widget.controle!.ordemServicoEmEdicao.cliente
                                  .nome ==
                              ""
                          ? widget.controle!.ordemServicoEmEdicao.cliente
                              .nomeFantasia
                          : widget.controle!.ordemServicoEmEdicao.cliente.nome),
                ),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              title: const Text('Numeros do contato'),
                              content: DataTableContato(
                                columns: const ["Numero", "Tipo"],
                                contatos: widget.controle!.ordemServicoEmEdicao
                                    .cliente.contatos,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Ok'))
                              ],
                            );
                          }));
                    },
                    child: Row(
                      children: [
                        const Text(
                            'Verificar os números de contato do cliente...'),
                      ],
                    )),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "CPF ou CNPJ",
                  obscureText: false,
                  readonly: true,
                  onTap: (() {
                    if (widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                        "Em andamento") {
                      showDialog(
                          context: context,
                          builder: (BuildContext builder) {
                            return OrdemDialogCliente(
                                ordem: widget.controle!.ordemServicoEmEdicao,
                                callback: callback);
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return ordemBloqueada();
                          }));
                    }
                  }),
                  controller: TextEditingController(
                      text: widget.controle!.ordemServicoEmEdicao.cliente.cpf ==
                              ""
                          ? widget.controle!.ordemServicoEmEdicao.cliente.cnpj
                          : widget.controle!.ordemServicoEmEdicao.cliente.cpf),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "Endereço",
                  obscureText: false,
                  readonly: true,
                  controller: TextEditingController(
                      text: widget
                          .controle!.ordemServicoEmEdicao.cliente.endereco),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Bairro',
                  obscureText: false,
                  readonly: true,
                  controller: TextEditingController(
                      text:
                          widget.controle!.ordemServicoEmEdicao.cliente.bairro),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Cidade',
                  obscureText: false,
                  readonly: true,
                  controller: TextEditingController(
                      text:
                          widget.controle!.ordemServicoEmEdicao.cliente.cidade),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'CEP',
                  obscureText: false,
                  readonly: true,
                  controller: TextEditingController(
                      text: widget.controle!.ordemServicoEmEdicao.cliente.cep),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Modelo do Veiculo",
                        obscureText: false,
                        readonly: true,
                        validator: validar,
                        onTap: () {
                          if (widget.controle!.ordemServicoEmEdicao
                                  .situacaoAtual ==
                              "Em andamento") {
                            showDialog(
                                context: context,
                                builder: (BuildContext builder) {
                                  return OrdemDialogVeiculos(
                                    ordemServico:
                                        widget.controle!.ordemServicoEmEdicao,
                                    callback: callback,
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return ordemBloqueada();
                                }));
                          }
                        },
                        controller: TextEditingController(
                            text: widget
                                .controle!.ordemServicoEmEdicao.veiculo.modelo),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Marca',
                        obscureText: false,
                        readonly: true,
                        controller: TextEditingController(
                            text: widget.controle!.ordemServicoEmEdicao.veiculo
                                .marca.nome),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Placa',
                        obscureText: false,
                        readonly: true,
                        controller: TextEditingController(
                            text: widget
                                .controle!.ordemServicoEmEdicao.veiculo.placa),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Tipo do Veiculo',
                        obscureText: false,
                        readonly: true,
                        controller: TextEditingController(
                            text: widget.controle!.ordemServicoEmEdicao.veiculo
                                .tipodeVeiculo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "Funcionario",
                  obscureText: false,
                  readonly: false,
                  validator: validar,
                  controller: TextEditingController(
                      text: widget
                          .controle!.ordemServicoEmEdicao.funcionario.nome),
                  onTap: () {
                    if (widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                        "Em andamento") {
                      showDialog(
                          context: context,
                          builder: (BuildContext builder) {
                            return DialogFuncionario(
                                ordem: widget.controle!.ordemServicoEmEdicao,
                                callback: callback);
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return ordemBloqueada();
                          }));
                    }
                  },
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Lista de Produtos e Serviços",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    child: DataTableProdutos(
                      columns: [
                        "Produto",
                        "Custo",
                        "Quantidade",
                        "Valor",
                        "Desconto",
                        "Valor Total",
                      ],
                      ordem: widget.controle!.ordemServicoEmEdicao,
                      callback: callback,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Entrada",
                        obscureText: false,
                        readonly: false,
                        controller: valorEntrada,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        input: [formatadorNumeros(), formatadorVirgula()],
                        prefix: Text(_currency),
                        onSaved: (String? value) {
                          widget.controle!.ordemServicoEmEdicao.valorEntrada =
                              double.parse(value!.replaceAll(",", "."));
                        },
                        onTap: () {
                          if (widget.controle!.ordemServicoEmEdicao
                                  .situacaoAtual !=
                              "Em andamento") {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return ordemBloqueada();
                                }));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                          label: "Custo",
                          obscureText: false,
                          readonly: true,
                          controller: TextEditingController(
                              text: widget
                                  .controle!.ordemServicoEmEdicao.valorCusto
                                  .toStringAsFixed(2)
                                  .replaceAll('.', ',')),
                          prefix: Text(_currency),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          input: [formatadorNumeros(), formatadorVirgula()]),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                          label: "Valor em peças",
                          obscureText: false,
                          readonly: true,
                          controller: TextEditingController(
                              text: widget
                                  .controle!.ordemServicoEmEdicao.valorPecas
                                  .toStringAsFixed(2)
                                  .replaceAll('.', ',')),
                          prefix: Text(_currency),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          input: [formatadorNumeros(), formatadorVirgula()]),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: CustomTextField(
                      label: "Valor mao de Obra",
                      obscureText: false,
                      readonly: true,
                      controller: TextEditingController(
                          text: widget
                              .controle!.ordemServicoEmEdicao.valorMaodeObra
                              .toStringAsFixed(2)
                              .replaceAll('.', ',')),
                      prefix: Text(_currency),
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: "Valor por parcela",
                        obscureText: false,
                        readonly: true,
                        controller: TextEditingController(
                            text: widget
                                .controle!.ordemServicoEmEdicao.valorPrazo
                                .toStringAsFixed(2)
                                .replaceAll('.', ',')),
                        prefix: Text(_currency),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: "Valor total",
                        obscureText: false,
                        readonly: true,
                        controller: TextEditingController(
                            text: widget
                                .controle!.ordemServicoEmEdicao.valorTotalVista
                                .toStringAsFixed(2)
                                .replaceAll('.', ',')),
                        prefix: Text(_currency),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(children: [
                  if (widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                      "Em andamento") ...[
                    const Text("Parcelas a prazo: "),
                    SizedBox(
                      width: 70,
                      child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.blue)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.blue))),
                          value: widget.controle!.ordemServicoEmEdicao.qtdPrazo,
                          items: prazo
                              .map((prazo) => DropdownMenuItem<int>(
                                  value: prazo,
                                  child: Text(
                                    prazo.toString(),
                                    style: TextStyle(fontSize: 18),
                                  )))
                              .toList(),
                          onChanged: ((prazo) {
                            setState(() {
                              widget.controle!.ordemServicoEmEdicao.qtdPrazo =
                                  prazo!;

                              widget.controle!.ordemServicoEmEdicao
                                  .calcularPrazo();
                              print(widget
                                  .controle!.ordemServicoEmEdicao.qtdPrazo);
                            });
                          })),
                    )
                  ] else ...[
                    const Text("Parcelas a prazo: "),
                    SizedBox(
                      width: 50,
                      child: CustomTextField(
                        label: "",
                        obscureText: false,
                        readonly: true,
                        controller: TextEditingController(
                            text: widget.controle!.ordemServicoEmEdicao.qtdPrazo
                                .toString()),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return ordemBloqueada();
                              }));
                        },
                      ),
                    )
                  ],
                ]),
                const Text(
                  "Formas de Pagamento",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    child: DataTableForma(
                        columns: ["Nome", "Valor Pago"],
                        callback: callback,
                        ordem: widget.controle!.ordemServicoEmEdicao),
                  ),
                ),
                const SizedBox(height: 10),
                VetorCarros(
                    ordemServico: widget.controle!.ordemServicoEmEdicao),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "Problema constado",
                  obscureText: false,
                  readonly:
                      widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                              "Em andamento"
                          ? false
                          : true,
                  maxlines: 5,
                  controller: TextEditingController(
                      text: widget
                          .controle!.ordemServicoEmEdicao.problemaConstado),
                  onSaved: (String? value) {
                    widget.controle!.ordemServicoEmEdicao.problemaConstado =
                        value;
                  },
                  onTap: () {
                    if (widget.controle!.ordemServicoEmEdicao.situacaoAtual !=
                        "Em andamento") {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return ordemBloqueada();
                          }));
                    }
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "Serviço executado",
                  obscureText: false,
                  readonly:
                      widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                              "Em andamento"
                          ? false
                          : true,
                  maxlines: 5,
                  controller: TextEditingController(
                      text: widget
                          .controle!.ordemServicoEmEdicao.servicoExecutado),
                  onSaved: (String? value) {
                    widget.controle!.ordemServicoEmEdicao.servicoExecutado =
                        value;
                  },
                  onTap: () {
                    if (widget.controle!.ordemServicoEmEdicao.situacaoAtual !=
                        "Em andamento") {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return ordemBloqueada();
                          }));
                    }
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "Obs complementares",
                  obscureText: false,
                  readonly:
                      widget.controle!.ordemServicoEmEdicao.situacaoAtual ==
                              "Em andamento"
                          ? false
                          : true,
                  maxlines: 5,
                  controller: TextEditingController(
                      text: widget
                          .controle!.ordemServicoEmEdicao.obsComplementares),
                  onSaved: (String? value) {
                    widget.controle!.ordemServicoEmEdicao.obsComplementares =
                        value;
                  },
                  onTap: () {
                    if (widget.controle!.ordemServicoEmEdicao.situacaoAtual !=
                        "Em andamento") {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return ordemBloqueada();
                          }));
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
