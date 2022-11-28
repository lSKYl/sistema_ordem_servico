import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/modelo/ordemservicoprodutos.dart';

import 'dialogprodutos.dart';

class DataTableProdutos extends StatefulWidget {
  DataTableProdutos(
      {super.key,
      required this.columns,
      required this.ordem,
      required this.callback});
  final List<String> columns;
  final Function() callback;

  final OrdemServico ordem;

  @override
  State<DataTableProdutos> createState() => _DataTableProdutosState();
}

class _DataTableProdutosState extends State<DataTableProdutos> {
  List<OrdemServicoProdutos> selectedProdutos = [];
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

  List getRowsProduto(List<OrdemServicoProdutos> produtos) => produtos
      .map((OrdemServicoProdutos produto) => DataRow(
              selected: selectedProdutos.contains(produto),
              onSelectChanged: (value) {
                setState(() {
                  final adicionar = value != null && value;

                  adicionar
                      ? selectedProdutos.add(produto)
                      : selectedProdutos.remove(produto);
                });
              },
              cells: [
                DataCell(Row(
                  children: [
                    Text("${produto.produtoServico.nome}"),
                    const SizedBox(width: 10),
                    produto.produtoServico.marca.nome == null
                        ? const Text("")
                        : Text(produto.produtoServico.marca.nome)
                  ],
                )),
                DataCell(produto.produtoServico.tipoProduto == true
                    ? Text(
                        "R\$${produto.custoProdutos.toStringAsFixed(2).replaceAll(".", ",")}")
                    : Text(
                        "R\$${produto.custoMaoObra.toStringAsFixed(2).replaceAll(".", ",")}")),
                DataCell(produto.produtoServico.un == null
                    ? Text(
                        "${produto.qtd.toStringAsFixed(2).replaceAll(".", ",")}")
                    : Text(
                        "${produto.qtd.toStringAsFixed(2).replaceAll(".", ",")} ${produto.produtoServico.un}")),
                DataCell(Text(
                    "R\$${produto.produtoServico.valorVista.toStringAsFixed(2).replaceAll(".", ",")}")),
                DataCell(Text(
                    "R\$${produto.desconto.toStringAsFixed(2).replaceAll(".", ",")}")),
                DataCell(Text(
                    "R\$${produto.precoTotalVista.toStringAsFixed(2).replaceAll(".", ",")}")),
              ]))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataTable(
            columns: getColumns(widget.columns),
            rows: getRowsProduto(widget.ordem.ordemservicoprodutos)
                .cast<DataRow>()),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      if (widget.ordem.situacaoAtual == "Em andamento") {
                        showDialog(
                            context: context,
                            builder: (BuildContext builder) {
                              return DialogProdutos(
                                ordem: widget.ordem,
                                callback: widget.callback,
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
                    child: const Text("Adicionar serviço ou produto")),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.ordem.situacaoAtual == "Em andamento") {
                        setState(() {
                          for (var elem in selectedProdutos) {
                            widget.ordem.removerServico(elem);
                          }
                          selectedProdutos.clear();
                        });
                        widget.callback();
                      } else {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return ordemBloqueada();
                            }));
                      }
                    },
                    child: const Text("Remover Produtos"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  )),
            )
          ],
        )
      ],
    );
  }
}
