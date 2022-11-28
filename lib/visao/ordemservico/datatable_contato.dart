import 'package:flutter/material.dart';

import '../../modelo/contato.dart';

class DataTableContato extends StatelessWidget {
  DataTableContato({super.key, required this.columns, required this.contatos});
  List<String> columns = [];
  List<Contato> contatos = [];

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();

  List getRowsContato(List<Contato> contatos) => contatos
      .map((Contato contato) => DataRow(cells: [
            DataCell(Text(contato.numero)),
            DataCell(Text(contato.tipo))
          ]))
      .toList();

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: getColumns(columns),
        rows: getRowsContato(contatos).cast<DataRow>());
  }
}
