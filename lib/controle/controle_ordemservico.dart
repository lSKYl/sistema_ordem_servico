import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/dao/ordem_servico_dao.dart';

class ControleOrdemServico {
  OrdemServicoDAO dao = OrdemServicoDAO();
  OrdemServico ordemServicoEmEdicao = OrdemServico();
  List<OrdemServico> ordens = [];
  Future<List<OrdemServico>>? ordensLista;

  Future<OrdemServico> carregarOrdem(OrdemServico ordem) async {
    return dao.carregarObjetoPorId(ordem.id);
  }

  Future<void> salvarOrdemEmEdicao() async {
    await dao.gravar(ordemServicoEmEdicao);
  }

  Future<void> excluirOrdem() async {
    dao.excluir(ordemServicoEmEdicao);
  }

  Future<void> pesquisarOrdem({String filtropesquisa = ""}) async {
    ordensLista = dao.pesquisarOrdem(filtro: filtropesquisa);
  }
}
