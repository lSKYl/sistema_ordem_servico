import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/modelo/produto_servico.dart';

class OrdemServicoProdutos {
  int _id = 0;
  ProdutoServico _produtoServico = ProdutoServico();
  OrdemServico _ordemServico = OrdemServico();
  double _qtd = 1;
  double _custoProdutos = 0.0;
  double _custoMaoObra = 0.0;
  double _desconto = 0.0;
  double valorProduto = 0.0;
  double _precoTotalPrazo = 0.0;
  double _precoTotalVista = 0.0;

  int get id => _id;

  set id(int value) => _id = value;

  get produtoServico => _produtoServico;

  set produtoServico(value) => _produtoServico = value;

  get ordemServico => _ordemServico;

  set ordemServico(value) => _ordemServico = value;

  get qtd => _qtd;

  set qtd(value) => _qtd = value;

  get custoProdutos => _custoProdutos;

  set custoProdutos(value) => _custoProdutos = value;

  get custoMaoObra => _custoMaoObra;

  set custoMaoObra(value) => _custoMaoObra = value;

  get desconto => _desconto;

  set desconto(value) => _desconto = value;

  double get precoTotalPrazo => _precoTotalPrazo;

  set precoTotalPrazo(double value) => _precoTotalPrazo = value;

  get precoTotalVista => _precoTotalVista;

  set precoTotalVista(value) => _precoTotalVista = value;

  void calculoCusto() {
    if (produtoServico.tipoProduto == true) {
      custoProdutos = produtoServico.custo * qtd;
    } else if (produtoServico.tipoServico == true) {
      custoMaoObra = produtoServico.custo * qtd;
    }
  }

  void calcularDesconto() {
    precoTotalVista = precoTotalVista - desconto;
  }

  void calcularTotal() {
    precoTotalVista = produtoServico.valorVista * qtd;
    calcularDesconto();
  }
}
