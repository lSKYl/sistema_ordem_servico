import 'package:sistema_ordem_servico/dao/marca_veiculo_dao.dart';
import 'package:sistema_ordem_servico/modelo/marcaveiculo.dart';

class ControleMarcaVeiculo {
  MarcaVeiculoDAO dao = MarcaVeiculoDAO();
  MarcaVeiculo marcaEmEdicao = MarcaVeiculo();
  List<MarcaVeiculo> marcas = [];
  Future<List<MarcaVeiculo>>? marcasPesquisadas;

  Future<void> pesquisarMarcas({String filtropesquisa = ""}) async {
    marcasPesquisadas = dao.pesquisar(filtro: filtropesquisa);
  }

  Future<void> pesquisarMarcasDesativadas({String filtropesquisa = ""}) async {
    marcasPesquisadas = dao.pesquisarDesativado(filtro: filtropesquisa);
  }

  Future<MarcaVeiculo> carregarMarca(MarcaVeiculo marca) async {
    return dao.carregarObjetoPorId(marca.id);
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
}
