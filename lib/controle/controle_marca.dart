import 'package:sistema_ordem_servico/dao/marca_dao.dart';
import 'package:sistema_ordem_servico/modelo/marca.dart';

class ControleMarca {
  MarcaDAO dao = MarcaDAO();
  Marca marcaEmEdicao = Marca();
  List<Marca> marcas = [];
  Future<List<Marca>>? marcasPesquisadas;

  Future<void> pesquisarMarcas({String filtroPesquisa = ""}) async {
    marcasPesquisadas = dao.pesquisar(filtro: filtroPesquisa);
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

  Future<void> ativar() async {
    dao.ativar(marcaEmEdicao);
  }

  Future<void> pesquisarDesativadas({String filtroPesquisa = ""}) async {
    marcasPesquisadas = dao.pesquisarDesativados(filtro: filtroPesquisa);
  }
}
