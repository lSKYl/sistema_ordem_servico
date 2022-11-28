import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sistema_ordem_servico/modelo/formapagamentoOS.dart';
import 'package:sistema_ordem_servico/visao/ordemservico/dialogformas.dart';

import '../../modelo/ordemservico.dart';

class DataTableForma extends StatefulWidget {
  const DataTableForma(
      {super.key,
      required this.columns,
      required this.callback,
      required this.ordem});
  final List<String> columns;
  final Function() callback;

  final OrdemServico ordem;

  @override
  State<DataTableForma> createState() => _DataTableFormaState();
}

class _DataTableFormaState extends State<DataTableForma> {
  List<FormaPagamentoOrdemServico> selectedFormas = [];
  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();

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
                      widget.ordem.situacaoAtual = "Em andamento";
                      widget.callback();
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

  List getRowsFormas(List<FormaPagamentoOrdemServico> formas) => formas
      .map((FormaPagamentoOrdemServico forma) => DataRow(
              selected: selectedFormas.contains(forma),
              onSelectChanged: (value) {
                setState(() {
                  final adicionar = value != null && value;

                  adicionar
                      ? selectedFormas.add(forma)
                      : selectedFormas.remove(forma);
                });
              },
              cells: [
                DataCell(Text(forma.forma.nome)),
                DataCell(Text(
                    "R\$${forma.valorPago.toStringAsFixed(2).replaceAll('.', ',')}"))
              ]))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DataTable(
            columns: getColumns(widget.columns),
            rows: getRowsFormas(widget.ordem.formas).cast<DataRow>()),
        const SizedBox(width: 15),
        ElevatedButton(
            onPressed: () {
              if (widget.ordem.situacaoAtual == "Em andamento") {
                showDialog(
                    context: context,
                    builder: (BuildContext builder) {
                      return DialogFormasPagamento(
                          callback: widget.callback, ordem: widget.ordem);
                    });
              } else {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return ordemBloqueada();
                    }));
              }
            },
            child: const Text("Adicionar forma")),
        const SizedBox(width: 10),
        ElevatedButton(
            onPressed: () {
              if (widget.ordem.situacaoAtual == "Em andamento") {
                setState(() {
                  for (var elem in selectedFormas) {
                    widget.ordem.removerForma(elem);
                  }
                });
              } else {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return ordemBloqueada();
                    }));
              }
            },
            child: const Text("Remover forma"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red))
      ],
    );
  }
}
