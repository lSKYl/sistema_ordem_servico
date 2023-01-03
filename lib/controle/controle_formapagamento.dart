import 'package:sistema_ordem_servico/dao/formagapamento_dao.dart';
import 'package:sistema_ordem_servico/modelo/formapagamento.dart';

class ControleFormaPagamento {
  FormaPagamentoDAO dao = FormaPagamentoDAO();
  FormaPagamento formaEmEdicao = FormaPagamento();
  List<FormaPagamento> formas = [];
  Future<List<FormaPagamento>>? formasPesquisadas;

  Future<void> pesquisarFormas({String filtroPesquisa = ""}) async {
    formasPesquisadas = dao.pesquisar(filtro: filtroPesquisa);
  }

  Future<void> pesquisarFormasDesativadas({String filtroPesquisa = ""}) async {
    formasPesquisadas = dao.pesquisarDesativados(filtro: filtroPesquisa);
  }

  Future<FormaPagamento> carregarForma(FormaPagamento forma) async {
    return dao.carregarObetoPorId(forma.id);
  }

  Future<void> salvarFormaEmEdicao() async {
    await dao.gravar(formaEmEdicao);
  }

  Future<void> excluirFormaEmEdicao() async {
    dao.excluir(formaEmEdicao);
  }

  Future<void> ativarFormaEmEdicao() async {
    dao.ativar(formaEmEdicao);
  }
}
