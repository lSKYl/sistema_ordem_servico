import "package:sistema_ordem_servico/modelo/produto_servico.dart";
import 'package:sistema_ordem_servico/dao/produto_servico_dao.dart';

class ControleProdutoServico {
  ProdutoServicoDAO dao = ProdutoServicoDAO();
  ProdutoServico produtoServicoEmEdicao = ProdutoServico();
  List<ProdutoServico> produtos = [];
  Future<List<ProdutoServico>>? produtosLista;
  Future<List<ProdutoServico>>? produtosPesquisados;

  Future<ProdutoServico> carregarProduto(ProdutoServico produto) async {
    return dao.carregaObjetoPorId(produto.id, produto.marca.id);
  }

  Future<void> salvarProdutoEmEdicao() async {
    await dao.gravar(produtoServicoEmEdicao);
  }

  Future<void> excluirProduto() async {
    dao.excluir(produtoServicoEmEdicao);
  }

  Future<void> carregarLista() async {
    produtosLista = dao.carregar();
  }
}
