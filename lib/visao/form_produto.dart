import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ordem_servico/controle/controle_produto.dart';
import 'package:sistema_ordem_servico/modelo/marca.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/controle/controle_marca.dart';
import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/widgets/search_field.dart';

class FormProduto extends StatefulWidget {
  ControleProdutoServico? controle;
  Function()? onSaved;
  FormProduto({super.key, this.controle, this.onSaved});

  @override
  State<FormProduto> createState() => _FormProdutoState();
}

class _FormProdutoState extends State<FormProduto> {
  final _chaveForm = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  var formatterData = DateFormat('dd/MM/yy');
  static const _locale = 'pt_Br';
  final ControleMarca _controleMarca = ControleMarca();
  late TextEditingController marcaController = TextEditingController(
      text: widget.controle!.produtoServicoEmEdicao.marca.nome);
  TextEditingController _controladorCampoPesquisa = TextEditingController();

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();

      widget.controle?.salvarProdutoEmEdicao().then((_) {
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.of(context).pop();
      });
    }
  }

  Widget _listaMarcas() {
    return SizedBox(
      width: 500,
      height: 500,
      child: FutureBuilder(
        future: _controleMarca.marcasPesquisadas,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          if (snapshot.hasData) {
            _controleMarca.marcas = snapshot.data as List<Marca>;

            return ListView.builder(
              itemCount: _controleMarca.marcas.length,
              itemBuilder: (BuildContext context, int index) {
                Marca marca = _controleMarca.marcas[index];
                return SizedBox(
                  child: ListTileDialog(
                    object: _controleMarca.marcas[index],
                    nome: marca.nome!,
                    subtitulo: "",
                    indice: index + 1,
                    onTap: () {
                      _controleMarca.carregarMarca(marca).then((value) {
                        setState(() {
                          marcaController.text = value.nome!;

                          widget.controle!.produtoServicoEmEdicao.marca = value;
                          Navigator.pop(context);
                        });
                      });
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text('Carregando Dados'),
          );
        },
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Serviço ou Produto'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (() {
          salvar(context);
        }),
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
                children: [
                  Radio(
                      value: true,
                      groupValue:
                          widget.controle!.produtoServicoEmEdicao.tipoProduto,
                      onChanged: ((value) {
                        setState(() {
                          widget.controle?.produtoServicoEmEdicao.tipoProduto =
                              true;
                          widget.controle?.produtoServicoEmEdicao.tipoServico =
                              false;
                        });
                      })),
                  const Text('Produto'),
                  const SizedBox(
                    width: 10,
                  ),
                  Radio(
                      value: true,
                      groupValue:
                          widget.controle!.produtoServicoEmEdicao.tipoServico,
                      onChanged: ((value) {
                        setState(() {
                          widget.controle?.produtoServicoEmEdicao.tipoProduto =
                              false;
                          widget.controle?.produtoServicoEmEdicao.tipoServico =
                              true;
                        });
                      })),
                  const Text('Serviço'),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(formatterData.format(widget
                          .controle!.produtoServicoEmEdicao.dataCadastro)))
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(
                label: "Nome",
                obscureText: false,
                readonly: false,
                controller: TextEditingController(
                    text: widget.controle!.produtoServicoEmEdicao.nome),
                maxlength: 50,
                onSaved: (String? value) {
                  widget.controle?.produtoServicoEmEdicao.nome = value;
                },
                validator: validar,
              ),
              if (widget.controle?.produtoServicoEmEdicao.tipoProduto ==
                  true) ...[
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "Referência Produto",
                  obscureText: false,
                  readonly: false,
                  controller: TextEditingController(
                      text: widget
                          .controle!.produtoServicoEmEdicao.referenciaProduto),
                  onSaved: (String? value) {
                    widget.controle?.produtoServicoEmEdicao.referenciaProduto =
                        value;
                  },
                  maxlength: 30,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: marcaController,
                  label: "Marca",
                  obscureText: false,
                  readonly: true,
                  onTap: (() {
                    setState(() {
                      _controleMarca.pesquisarMarcas();
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext builder) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                                title: SearchFieldDialog(
                                  controller: _controladorCampoPesquisa,
                                  onChanged: (text) {
                                    setState(
                                      () {
                                        _controleMarca.pesquisarMarcas(
                                            filtroPesquisa:
                                                _controladorCampoPesquisa.text
                                                    .toLowerCase());
                                        setState;
                                      },
                                    );
                                  },
                                  hint:
                                      "Digite a marca que deseja pesquisar...",
                                ),
                                content: _listaMarcas());
                          });
                        });
                  }),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "UN",
                  obscureText: false,
                  readonly: false,
                  controller: TextEditingController(
                      text: widget.controle!.produtoServicoEmEdicao.un),
                  onSaved: (String? value) {
                    widget.controle?.produtoServicoEmEdicao.un = value;
                  },
                  maxlength: 12,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Descrição Produto',
                  obscureText: false,
                  readonly: false,
                  controller: TextEditingController(
                      text: widget
                          .controle!.produtoServicoEmEdicao.descricaoProduto),
                  onSaved: (String? value) {
                    widget.controle?.produtoServicoEmEdicao.descricaoProduto =
                        value;
                  },
                  maxlines: 3,
                  maxlength: 200,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Descrição Adicional do Produto',
                  obscureText: false,
                  readonly: false,
                  controller: TextEditingController(
                      text: widget.controle?.produtoServicoEmEdicao
                          .descricaoAdicionalProduto),
                  onSaved: (String? value) {
                    widget.controle?.produtoServicoEmEdicao
                        .descricaoAdicionalProduto = value;
                  },
                  maxlines: 3,
                  maxlength: 150,
                )
              ],
              if (!widget.controle!.produtoServicoEmEdicao.tipoProduto ==
                  true) ...[
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: 'Descrição do serviço',
                  obscureText: false,
                  readonly: false,
                  maxlines: 3,
                  controller: TextEditingController(
                      text: widget
                          .controle!.produtoServicoEmEdicao.descricaoServico),
                  onSaved: (String? value) {
                    widget.controle!.produtoServicoEmEdicao.descricaoServico =
                        value;
                  },
                  maxlength: 200,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Descrição Adicional do Serviço',
                  obscureText: false,
                  readonly: false,
                  controller: TextEditingController(
                      text: widget.controle!.produtoServicoEmEdicao
                          .descricaoAdicionalServico),
                  onSaved: (String? value) {
                    widget.controle!.produtoServicoEmEdicao
                        .descricaoAdicionalServico = value;
                  },
                  maxlines: 3,
                  maxlength: 150,
                )
              ],
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: CustomTextField(
                          label: "Custo",
                          obscureText: false,
                          readonly: false,
                          prefix: Text(_currency),
                          controller: TextEditingController(
                              text: widget
                                  .controle?.produtoServicoEmEdicao.custo
                                  .toStringAsFixed(2)
                                  .replaceAll('.', ',')),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          input: [formatadorNumeros(), formatadorVirgula()],
                          onSaved: (String? value) {
                            widget.controle?.produtoServicoEmEdicao.custo =
                                double.parse(value!.replaceAll(',', '.'));
                          },
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: CustomTextField(
                        label: "Preço a Vista",
                        readonly: false,
                        prefix: Text(_currency),
                        obscureText: false,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        input: [formatadorNumeros(), formatadorVirgula()],
                        controller: TextEditingController(
                            text: widget
                                .controle?.produtoServicoEmEdicao.valorVista
                                .toStringAsFixed(2)
                                .replaceAll('.', ',')),
                        onSaved: (String? value) {
                          widget.controle?.produtoServicoEmEdicao.valorVista =
                              double.parse(value!.replaceAll(',', '.'));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: CustomTextField(
                        readonly: false,
                        label: "Preço a Prazo",
                        obscureText: false,
                        controller: TextEditingController(
                            text: widget
                                .controle?.produtoServicoEmEdicao.valorPrazo
                                .toStringAsFixed(2)
                                .replaceAll('.', ',')),
                        prefix: Text(_currency),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        input: [formatadorNumeros(), formatadorVirgula()],
                        onSaved: (value) {
                          widget.controle?.produtoServicoEmEdicao.valorPrazo =
                              double.parse(value!.replaceAll(',', '.'));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              CustomTextField(
                label: 'Obs',
                obscureText: false,
                readonly: false,
                controller: TextEditingController(
                    text: widget.controle!.produtoServicoEmEdicao.obs),
                onSaved: (String? value) {
                  widget.controle?.produtoServicoEmEdicao.obs = value;
                },
                maxlines: 5,
                maxlength: 200,
              )
            ]),
          ),
        )
      ]),
    );
  }
}
