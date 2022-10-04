import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ordem_servico/controle/controle_produto.dart';
import 'package:sistema_ordem_servico/modelo/marca.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/controle/controle_marca.dart';
import 'package:flutter/material.dart';

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

  FutureBuilder listaMarcas() {
    return FutureBuilder(
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
              return Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width > 1000
                        ? (MediaQuery.of(context).size.width - 1000) / 2
                        : 10,
                    right: MediaQuery.of(context).size.width > 1000
                        ? (MediaQuery.of(context).size.width - 1000) / 2
                        : 10),
                child: CustomListTile(
                  object: _controleMarca.marcas[index],
                  nome: marca.nome,
                ),
              );
            },
          );
        }
        return const Center(
          child: Text('Carregando Dados'),
        );
      },
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
                initialvalue: widget.controle?.produtoServicoEmEdicao.nome,
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
                  initialvalue:
                      widget.controle?.produtoServicoEmEdicao.referenciaProduto,
                  onSaved: (String? value) {
                    widget.controle?.produtoServicoEmEdicao.referenciaProduto =
                        value;
                  },
                  maxlength: 30,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "Marca",
                  obscureText: false,
                  initialvalue:
                      widget.controle?.produtoServicoEmEdicao.marca.nome,
                  onTap: (() {
                    setState(() {
                      _controleMarca.carregarLista();
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext builder) {
                          return listaMarcas();
                        });
                  }),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "UN",
                  obscureText: false,
                  initialvalue: widget.controle?.produtoServicoEmEdicao.un,
                  onSaved: (String? value) {
                    widget.controle?.produtoServicoEmEdicao.un = value;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Descrição Produto',
                  obscureText: false,
                  initialvalue:
                      widget.controle?.produtoServicoEmEdicao.descricaoProduto,
                  onSaved: (String? value) {
                    widget.controle?.produtoServicoEmEdicao.descricaoProduto =
                        value;
                  },
                  maxlines: 3,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Descrição Adicional do Produto',
                  obscureText: false,
                  initialvalue: widget.controle?.produtoServicoEmEdicao
                      .descricaoAdicionalProduto,
                  onSaved: (String? value) {
                    widget.controle?.produtoServicoEmEdicao
                        .descricaoAdicionalProduto = value;
                  },
                  maxlines: 3,
                )
              ],
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        width: 200,
                        height: 200,
                        child: CustomTextField(
                          label: "Custo",
                          obscureText: false,
                          prefix: Text(_currency),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          input: [formatadorNumeros(), formatadorVirgula()],
                          initialvalue: widget
                              .controle?.produtoServicoEmEdicao.custo
                              .toString()
                              .replaceAll('.', ','),
                          onSaved: (String? value) {
                            widget.controle?.produtoServicoEmEdicao.custo =
                                value?.replaceAll(',', '.') as double;
                          },
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CustomTextField(
                        label: "Preço a Vista",
                        prefix: Text(_currency),
                        obscureText: false,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        input: [formatadorNumeros(), formatadorVirgula()],
                        initialvalue: widget
                            .controle?.produtoServicoEmEdicao.valorVista
                            .toString()
                            .replaceAll('.', ','),
                        onSaved: (String? value) {
                          widget.controle?.produtoServicoEmEdicao.valorVista =
                              value as double;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CustomTextField(
                        label: "Preço a Prazo",
                        obscureText: false,
                        prefix: Text(_currency),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        input: [formatadorNumeros(), formatadorVirgula()],
                        initialvalue: widget
                            .controle?.produtoServicoEmEdicao.valorPrazo
                            .toString()
                            .replaceAll('.', ','),
                        onSaved: (value) {
                          widget.controle?.produtoServicoEmEdicao.valorPrazo =
                              value as double;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ]),
          ),
        )
      ]),
    );
  }
}
