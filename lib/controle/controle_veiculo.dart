import 'package:sistema_ordem_servico/modelo/veiculo.dart';
import 'package:sistema_ordem_servico/dao/veiculo_dao.dart';

class ControleVeiculo {
  VeiculoDAO dao = VeiculoDAO();
  Veiculo veiculoEmEdicao = Veiculo();
  List<Veiculo> veiculos = [];
  Future<List<Veiculo>>? veiculosLista;

  Future<Veiculo> carregarVeiculo(Veiculo veiculo) async {
    return dao.carregarObjetorPorId(
        veiculo.id, veiculo.marca.id, veiculo.cliente.id);
  }

  Future<void> salvarVeiculoEmEdiao() async {
    await dao.gravar(veiculoEmEdicao);
  }

  Future<void> excluirVeiculo() async {
    dao.excluir(veiculoEmEdicao);
  }

  Future<void> pesquisarVeiculo({String filtro = ""}) async {
    veiculosLista = dao.pesquisarVeiculo(filtro: filtro);
  }
}
