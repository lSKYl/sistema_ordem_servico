import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:intl/intl.dart';

class PdfInvoiceService {
  var formatterData = DateFormat('dd/MM/yy');
  Future<Uint8List> createOrdemServico(OrdemServico ordem) async {
    final image =
        (await rootBundle.load('assets/img/logo.png')).buffer.asUint8List();
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        margin: EdgeInsets.all(20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            buildHeader(image, ordem),
            Divider(),
            buildCliente(ordem),
            Divider(),
            buildVeiculo(ordem),
            Divider(),
            tabelaServicosEProdutos(ordem),
            Divider(),
            valorTotal(ordem),
            buildFooter()
          ];
        },
      ),
    );
    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenDocument.openDocument(filePath: filePath);
  }

  static Widget tableFormas(OrdemServico ordem) {
    final headers = ["Forma", "Valor Pago"];

    final data = ordem.formas.map((forma) {
      return [
        "${forma.forma.nome}",
        "R\$${forma.valorPago.toStringAsFixed(2).replaceAll('.', ',')}"
      ];
    }).toList();
    return Table.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        cellStyle: TextStyle(fontSize: 10),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        cellHeight: 10,
        cellAlignments: {0: Alignment.centerLeft, 1: Alignment.centerLeft});
  }

  static Widget tabelaServicosEProdutos(OrdemServico ordem) {
    final headers = [
      "Produto/Serviço",
      "Quantidade",
      "Valor",
      "Desconto",
      "Valor Total"
    ];
    final data = ordem.ordemservicoprodutos.map((produto) {
      return [
        "${produto.produtoServico.nome} ${produto.produtoServico.marca.nome == null ? "" : produto.produtoServico.marca.nome}",
        "${produto.qtd.toStringAsFixed(2).replaceAll(".", ",")}",
        "R\$${produto.valorProduto.toStringAsFixed(2).replaceAll(".", ",")}",
        "R\$${produto.desconto.toStringAsFixed(2).replaceAll(".", ",")}",
        "R\$${produto.precoTotalVista.toStringAsFixed(2).replaceAll(".", ",")}"
      ];
    }).toList();
    return Table.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        cellStyle: TextStyle(fontSize: 10),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        cellHeight: 10,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          3: Alignment.centerRight,
          4: Alignment.centerRight,
        });
  }

  static Widget observacoes(OrdemServico ordem) {
    return Padding(
        padding: const EdgeInsets.all(4),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            buildText(title: "Problema Constado: ", size: 10),
            buildTextUnderline(
                ordem.problemaConstado! == "" ? "_" : ordem.problemaConstado!)
          ]),
          SizedBox(height: 10),
          Row(children: [
            buildText(title: "Serviço executado: ", size: 10),
            buildTextUnderline(
                ordem.servicoExecutado! == "" ? "_" : ordem.servicoExecutado!)
          ]),
          SizedBox(height: 10),
          Row(children: [
            buildText(title: "Obs: ", size: 10),
            buildTextUnderline(
                ordem.obsComplementares! == "" ? "_" : ordem.obsComplementares!)
          ])
        ]));
  }

  static Widget valorTotal(OrdemServico ordem) {
    return Container(
        alignment: Alignment.centerRight,
        child: Row(children: [
          Column(children: [
            Text("Formas de Pagamento"),
            Container(child: tableFormas(ordem)),
          ]),
          Spacer(flex: 6),
          Expanded(
              flex: 4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                        title:
                            "Valor em peças: R\$${ordem.valorPecas.toStringAsFixed(2).replaceAll(".", ",")}",
                        size: 8,
                        peso: FontWeight.bold),
                    buildText(
                        title:
                            "Valor em mão de obra: R\$${ordem.valorMaodeObra.toStringAsFixed(2).replaceAll(".", ",")}",
                        size: 8,
                        peso: FontWeight.bold),
                    Container(width: 200, child: Divider()),
                    if (ordem.valorEntrada > 0) ...[
                      buildText(
                          title:
                              "Entrada: R\$${ordem.valorEntrada.toStringAsFixed(2).replaceAll(".", ",")}",
                          size: 12,
                          peso: FontWeight.bold)
                    ],
                    if (ordem.qtdPrazo > 1) ...[
                      buildText(
                          title: "Parcelas: ${ordem.qtdPrazo}",
                          size: 8,
                          peso: FontWeight.bold),
                      buildText(
                          title:
                              "Valor por parcela: R\$${ordem.valorPrazo.toStringAsFixed(2).replaceAll(".", ",")}",
                          size: 12,
                          peso: FontWeight.bold)
                    ],
                    buildText(
                        title:
                            "Valor total: R\$${ordem.valorTotalVista.toStringAsFixed(2).replaceAll(".", ",")}",
                        size: 14,
                        peso: FontWeight.bold)
                  ]))
        ]));
  }

  Widget buildHeader(Uint8List image, OrdemServico ordem) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(2)),
          child: Row(children: [
            Container(child: Image(MemoryImage(image), width: 120, height: 75)),
            Padding(
                padding: EdgeInsets.all(2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText(
                          title: "Sandro Martelinho de Ouro",
                          size: 10,
                          alinhamento: TextAlign.center,
                          peso: FontWeight.bold),
                      buildText(
                          title: "Av. Dorgival P. de Souza, 1520",
                          size: 10,
                          alinhamento: TextAlign.center),
                      buildText(
                          title: "Centro (em frente a Maquisul)",
                          size: 10,
                          alinhamento: TextAlign.center),
                      buildText(
                          title: "Imperatriz - MA",
                          size: 10,
                          alinhamento: TextAlign.center),
                      buildText(
                          title: "Contato: (99) 98113-6952",
                          size: 10,
                          alinhamento: TextAlign.center)
                    ]))
          ])),
      Container(
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(2)),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(children: [
                buildText(
                    title: "Nº da OS: ${ordem.id}",
                    size: 10,
                    peso: FontWeight.bold),
                buildText(
                    title:
                        "Abertura da OS: ${formatterData.format(ordem.dataCadastro)}",
                    size: 10,
                    peso: FontWeight.bold),
                buildText(
                    title:
                        "Finalização Prevista: ${formatterData.format(ordem.previsaoEntrega)}",
                    size: 10,
                    peso: FontWeight.bold),
                buildText(
                    title: "Situação Atual: ${ordem.situacaoAtual}",
                    size: 10,
                    peso: FontWeight.bold),
                buildText(
                    title: "Funcionario: ${ordem.funcionario.nome}",
                    size: 10,
                    peso: FontWeight.bold)
              ])))
    ]);
  }

  static Widget buildCliente(OrdemServico ordemServico) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(2)),
        child: Padding(
            padding: EdgeInsets.all(4),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    buildText(title: "Nome: ", size: 10),
                    SizedBox(
                        width: 225,
                        child: buildTextUnderline(
                            ordemServico.cliente.nome == ""
                                ? ordemServico.cliente.nomeFantasia
                                : ordemServico.cliente.nome)),
                    SizedBox(width: 25),
                    buildText(title: "CPF/CNPJ: ", size: 10),
                    buildTextUnderline(ordemServico.cliente.cpf == ""
                        ? ordemServico.cliente.cnpj
                        : ordemServico.cliente.cpf),
                  ]),
                  SizedBox(height: 10),
                  Row(children: [
                    buildText(title: "Endereço: ", size: 10),
                    SizedBox(
                        width: 209,
                        child: buildTextUnderline(
                            ordemServico.cliente.endereco == ""
                                ? "_"
                                : ordemServico.cliente.endereco)),
                    SizedBox(width: 25),
                    buildText(title: "Bairro: ", size: 10),
                    buildTextUnderline(ordemServico.cliente.bairro == ""
                        ? "_"
                        : ordemServico.cliente.bairro),
                  ]),
                  SizedBox(height: 10),
                  Row(children: [
                    buildText(title: "Cidade: ", size: 10),
                    SizedBox(
                        width: 220,
                        child: buildTextUnderline(
                            ordemServico.cliente.cidade! == ""
                                ? "_"
                                : ordemServico.cliente.cidade!)),
                    SizedBox(width: 25),
                    buildText(title: "CEP: ", size: 10),
                    buildTextUnderline(ordemServico.cliente.cep == ""
                        ? "_"
                        : ordemServico.cliente.cep)
                  ]),
                  SizedBox(height: 10),
                  Row(children: [
                    buildText(title: "Contato: ", size: 10),
                    if (ordemServico.cliente.contatos.isEmpty) ...[
                      buildTextUnderline("(       )"),
                      SizedBox(height: 10)
                    ] else ...[
                      buildTextUnderline(
                          ordemServico.cliente.contatos.elementAt(0).numero),
                      SizedBox(height: 10)
                    ]
                  ]),
                ])));
  }

  static Widget buildVeiculo(OrdemServico ordemServico) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(children: [
          Row(
            children: [
              buildText(title: "Modelo: ", size: 10),
              buildTextUnderline(ordemServico.veiculo.modelo),
              SizedBox(width: 10),
              buildText(title: "Marca: ", size: 10),
              buildTextUnderline(ordemServico.veiculo.marca.nome == ""
                  ? "_"
                  : ordemServico.veiculo.marca.nome),
              SizedBox(width: 10),
              buildText(title: "Placa: ", size: 10),
              buildTextUnderline(ordemServico.veiculo.placa),
              SizedBox(width: 10),
              buildText(title: "Cor: ", size: 10),
              buildTextUnderline(ordemServico.veiculo.cor == ""
                  ? "_"
                  : ordemServico.veiculo.cor)
            ],
          ),
          SizedBox(height: 10),
          Text("Partes do veiculo trabalhada", style: TextStyle(fontSize: 6)),
          SizedBox(
              child: Center(
                  child: Image(MemoryImage(ordemServico.vetorVeiculo!)))),
          SizedBox(height: 10),
          Row(children: [
            buildText(title: "Problema Constado: ", size: 10),
            buildTextUnderline(ordemServico.problemaConstado! == ""
                ? "_"
                : ordemServico.problemaConstado!)
          ]),
          SizedBox(height: 10),
          Row(children: [
            buildText(title: "Serviço executado: ", size: 10),
            buildTextUnderline(ordemServico.servicoExecutado! == ""
                ? "_"
                : ordemServico.servicoExecutado!)
          ]),
          SizedBox(height: 10),
        ]),
      ),
    );
  }

  static Widget buildFooter() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Divider(),
      buildText(
          title:
              "Autorizo a realização dos serviços acima nesta O.S, bem como, realizar manobras no veículo durante execução dos mesmos.",
          size: 9),
      SizedBox(height: 30),
      Container(width: 300, child: Divider(thickness: 1)),
      buildText(title: "Assinatura do Cliente", size: 8)
    ]);
  }

  static buildTextUnderline(String text) {
    return Expanded(
      child: Container(
        child: buildText(title: text, size: 10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      ),
    );
  }

  static buildText(
      {required String title,
      required double size,
      FontWeight? peso,
      TextAlign? alinhamento,
      TextDecoration? linha}) {
    return Container(
        child: Text(title,
            textAlign: alinhamento,
            style: TextStyle(
              decoration: linha,
              fontWeight: peso,
              fontSize: size,
            )));
  }
}
