import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ordem_servico/controle/controle_produto.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/modelo/ordemservicoprodutos.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/text_field.dart';
import '../../modelo/produto_servico.dart';

class DialogProdutos extends StatefulWidget {
  DialogProdutos({
    super.key,
    required this.ordem,
    required this.callback,
  });
  final Function callback;
  final OrdemServico ordem;

  @override
  State<DialogProdutos> createState() => _DialogProdutosState();
}

class _DialogProdutosState extends State<DialogProdutos> {
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  final ControleProdutoServico _controleProdutoServico =
      ControleProdutoServico();

  final _chaveForm = GlobalKey<FormState>();
  OrdemServicoProdutos produtos = OrdemServicoProdutos();
  static const _locale = 'pt_Br';
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  bool produtosServicos = true;
  bool produto = false;
  bool servicos = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controleProdutoServico.pesquisar();
    });
  }

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();
      produtos.calculoCusto();
      produtos.calcularTotal();

      widget.ordem.adicionarServico(produtos);

      widget.callback();
      Navigator.of(context).pop();
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

  Widget textRadio(String dado) {
    return Text(
      dado,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _listaProduto() {
    return SizedBox(
      width: 700,
      height: 300,
      child: FutureBuilder(
        future: _controleProdutoServico.produtosLista,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("${snapshot.error}");

          if (snapshot.hasData) {
            _controleProdutoServico.produtos =
                snapshot.data as List<ProdutoServico>;

            return ListView.builder(
              itemCount: _controleProdutoServico.produtos.length,
              itemBuilder: (context, index) {
                ProdutoServico produto =
                    _controleProdutoServico.produtos[index];
                return SizedBox(
                  child: ListTileDialog(
                      object: produto,
                      onTap: () {
                        setState(() {
                          _controleProdutoServico
                              .carregarProduto(produto)
                              .then((value) {
                            produtos.produtoServico = value;
                            produtos.valorProduto = value.valorVista;
                          });
                        });
                      },
                      indice: index + 1,
                      nome: Text("${produto.nome} ${produto.marca.nome}"),
                      subtitulo: produto.tipoProduto == true
                          ? Text(
                              "Produto no valor a vista: R\$${produto.valorVista.toStringAsFixed(2).replaceAll('.', ',')},  custo: R\$${produto.custo.toStringAsFixed(2)}",
                            )
                          : Text(
                              "Serviço no valor a vista: R\$${produto.valorVista.toStringAsFixed(2).replaceAll('.', ',')},  custo: R\$${produto.custo.toStringAsFixed(2)}",
                            )),
                );
              },
            );
          }
          return const Center(child: Text('Carregando dados'));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _chaveForm,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                SearchFieldDialog(
                  controller: _controladorCampoPesquisa,
                  onChanged: (text) {
                    setState(
                      () {
                        if (produtosServicos) {
                          _controleProdutoServico.pesquisar(
                              filtroPesquisa:
                                  _controladorCampoPesquisa.text.toLowerCase());
                        } else if (produto) {
                          _controleProdutoServico.pesquisarProdutos(
                              filtroPesquisa:
                                  _controladorCampoPesquisa.text.toLowerCase());
                        } else if (servicos) {
                          _controleProdutoServico.pesquisarServicos(
                              filtroPesquisa:
                                  _controladorCampoPesquisa.text.toLowerCase());
                        }
                        setState;
                      },
                    );
                  },
                ),
                Row(
                  children: [
                    Radio(
                        value: true,
                        groupValue: produtosServicos,
                        onChanged: (_) {
                          setState(
                            () {
                              produtosServicos = true;
                              produto = false;
                              servicos = false;
                              _controleProdutoServico.pesquisar();
                            },
                          );
                        }),
                    textRadio("Produtos/Serviços"),
                    Radio(
                        value: true,
                        groupValue: produto,
                        onChanged: (_) {
                          setState(
                            () {
                              produtosServicos = false;
                              produto = true;
                              servicos = false;
                              _controleProdutoServico.pesquisarProdutos();
                            },
                          );
                        }),
                    textRadio("Produtos"),
                    Radio(
                      value: true,
                      groupValue: servicos,
                      onChanged: (_) {
                        setState(
                          () {
                            produtosServicos = false;
                            produto = false;
                            servicos = true;
                            _controleProdutoServico.pesquisarServicos();
                          },
                        );
                      },
                    ),
                    textRadio("Serviços")
                  ],
                )
              ],
            ),
            content: SizedBox(
              height: 500,
              child: Column(
                children: [
                  _listaProduto(),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          validator: validar,
                          obscureText: false,
                          readonly: true,
                          label: "Produto",
                          controller: TextEditingController(
                              text: produtos.produtoServico.nome),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFieldBorder(
                          read: true,
                          label: "Marca",
                          controler: TextEditingController(
                              text: produtos.produtoServico.marca.nome),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldBorder(
                          read: true,
                          label: "Custo",
                          controler: TextEditingController(
                              text: produtos.produtoServico.custo
                                  .toStringAsFixed(2)
                                  .replaceAll('.', ',')),
                          preffix: Text(_currency),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: CustomTextField(
                              obscureText: false,
                              validator: validar,
                              readonly: false,
                              label: "Valor",
                              onChanged: (text) {
                                produtos.produtoServico.valorVista =
                                    double.parse(text);
                              },
                              onSaved: (String? value) {
                                produtos.valorProduto =
                                    double.parse(value!.replaceAll(',', '.'));
                              },
                              controller: TextEditingController(
                                  text: produtos.valorProduto
                                      .toStringAsFixed(2)
                                      .replaceAll('.', ',')),
                              prefix: Text(_currency))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                            obscureText: false,
                            readonly: false,
                            label: "Desconto",
                            controller: TextEditingController(
                                text: produtos.desconto
                                    .toStringAsFixed(2)
                                    .replaceAll('.', ',')),
                            onSaved: (String? value) {
                              produtos.desconto =
                                  double.parse(value!.replaceAll(',', '.'));
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            input: [formatadorNumeros(), formatadorVirgula()],
                            validator: validar,
                            prefix: Text(_currency)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          obscureText: false,
                          readonly: false,
                          label: "Quantidade",
                          controller: TextEditingController(
                              text: produtos.qtd
                                  .toStringAsFixed(2)
                                  .replaceAll('.', ',')),
                          onSaved: (String? value) {
                            produtos.qtd =
                                double.parse(value!.replaceAll(',', '.'));
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          input: [formatadorNumeros(), formatadorVirgula()],
                          validator: validar,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    salvar(context);
                  },
                  child: const Text("Salvar"))
            ],
          );
        },
      ),
    );
  }
}
