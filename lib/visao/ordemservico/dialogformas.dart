import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ordem_servico/controle/controle_formapagamento.dart';
import 'package:sistema_ordem_servico/modelo/formapagamento.dart';
import 'package:sistema_ordem_servico/modelo/formapagamentoOS.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/text_field.dart';

import '../../modelo/ordemservico.dart';

class DialogFormasPagamento extends StatefulWidget {
  const DialogFormasPagamento(
      {super.key, required this.callback, required this.ordem});
  final Function callback;
  final OrdemServico ordem;

  @override
  State<DialogFormasPagamento> createState() => _DialogFormasPagamentoState();
}

class _DialogFormasPagamentoState extends State<DialogFormasPagamento> {
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  final ControleFormaPagamento _controleForma = ControleFormaPagamento();
  final _chaveForm = GlobalKey<FormState>();
  FormaPagamentoOrdemServico formas = FormaPagamentoOrdemServico();
  static const _locale = 'pt_Br';
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();
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

  @override
  void initState() {
    super.initState();
    setState(() {
      _controleForma.pesquisarFormas();
    });
  }

  Widget _listaFormas() {
    return SizedBox(
      width: 400,
      height: 200,
      child: FutureBuilder(
        future: _controleForma.formasPesquisadas,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("${snapshot.error}");
          if (snapshot.hasData) {
            _controleForma.formas = snapshot.data as List<FormaPagamento>;

            return ListView.builder(
              itemCount: _controleForma.formas.length,
              itemBuilder: (context, index) {
                FormaPagamento forma = _controleForma.formas[index];
                return SizedBox(
                  child: ListTileDialog(
                    object: forma,
                    indice: index + 1,
                    nome: Text(forma.nome),
                    onTap: () {
                      setState(() {
                        _controleForma.carregarForma(forma).then((value) {
                          formas.forma = value;
                        });
                      });
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text('Carregando dados'),
          );
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
            title: SearchFieldDialog(
                controller: _controladorCampoPesquisa,
                onChanged: (_) {
                  setState(
                    () {
                      _controleForma.pesquisarFormas(
                          filtroPesquisa:
                              _controladorCampoPesquisa.text.toLowerCase());
                      setState;
                    },
                  );
                }),
            content: SizedBox(
              height: 350,
              child: Column(children: [
                _listaFormas(),
                const SizedBox(height: 10),
                TextFieldBorder(
                  read: true,
                  label: "Forma",
                  controler: TextEditingController(text: formas.forma.nome),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  label: "Valor pago",
                  obscureText: false,
                  readonly: false,
                  controller: TextEditingController(
                      text: formas.valorPago
                          .toStringAsFixed(2)
                          .replaceAll('.', ',')),
                  onSaved: (String? value) {
                    formas.valorPago =
                        double.parse(value!.replaceAll(",", "."));
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  input: [formatadorNumeros(), formatadorVirgula()],
                  prefix: Text(_currency),
                )
              ]),
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
                    Navigator.pop(context);
                    widget.ordem.adicionarForma(formas);
                    widget.callback();
                  },
                  child: const Text("Salvar"))
            ],
          );
        },
      ),
    );
  }
}
