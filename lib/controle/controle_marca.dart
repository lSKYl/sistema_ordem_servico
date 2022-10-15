import 'package:flutter/cupertino.dart';
import 'package:sistema_ordem_servico/dao/marca_dao.dart';
import 'package:sistema_ordem_servico/modelo/marca.dart';

class ControleMarca {
  MarcaDAO dao = MarcaDAO();
  Marca marcaEmEdicao = Marca();
  List<Marca> marcas = [];
  Future<List<Marca>>? marcasPesquisadas;
  Future<List<Marca>>? futureMarcasPesquisas;
  late Widget widget;

  Future<void> pesquisarMarcas({String filtroPesquisa = ""}) async {
    futureMarcasPesquisas = dao.pesquisar(filtro: filtroPesquisa);
  }

  Future<Marca> carregarMarca(Marca marca) async {
    return dao.carregarObjetoPorID(marca.id);
  }

  Future<void> salvarMarcaEmEdicao() async {
    await dao.gravar(marcaEmEdicao);
  }

  Future<void> excluirMarcaEmEdicao() async {
    dao.excluir(marcaEmEdicao);
  }

  Future<void> carregarLista() async {
    //await Future.delayed(Duration(seconds: 5));
    marcasPesquisadas = dao.carregar();
  }
}
