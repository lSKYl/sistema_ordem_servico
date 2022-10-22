import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/modelo/produto_servico.dart';

class OrdemServicoProdutos {
  int _id = 0;
  ProdutoServico _produtoServico = ProdutoServico();
  OrdemServico _ordemServico = OrdemServico();
  double _qtd = 0;
  double _custoProdutos = 0;
  double _custoMaoObra = 0;
  double _desconto = 0;
  double _precoTotal = 0;
  int get id => this._id;

  set id(int value) => this._id = value;

  get produtoServico => this._produtoServico;

  set produtoServico(value) => this._produtoServico = value;

  get ordemServico => this._ordemServico;

  set ordemServico(value) => this._ordemServico = value;

  get qtd => this._qtd;

  set qtd(value) => this._qtd = value;

  get custoProdutos => this._custoProdutos;

  set custoProdutos(value) => this._custoProdutos = value;

  get custoMaoObra => this._custoMaoObra;

  set custoMaoObra(value) => this._custoMaoObra = value;

  get desconto => this._desconto;

  set desconto(value) => this._desconto = value;

  get precoTotal => this._precoTotal;

  set precoTotal(value) => this._precoTotal = value;
}
