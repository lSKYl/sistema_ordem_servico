import 'package:sistema_ordem_servico/modelo/marca.dart';

class ProdutoServico {
  int _id = 0;
  String? _nome = "";
  String? _referenciaProduto = "";
  String? _un = "";
  String? _descricaoProduto = "";
  String? _descricaoServico = "";
  String? _descricaoAdicionalProduto = "";
  String? _descricaoAdicionalServico = "";
  bool _tipoServico = false;
  bool _tipoProduto = true;
  double _custo = 0;
  Marca _marca = Marca();
  String? _obs = "";
  double _valorVista = 0;
  double _valorPrazo = 0;
  bool _registroAtivo = true;
  DateTime _dataCadastro = DateTime.now();
  int get id => this._id;

  set id(int value) => this._id = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get referenciaProduto => this._referenciaProduto;

  set referenciaProduto(value) => this._referenciaProduto = value;

  get un => this._un;

  set un(value) => this._un = value;

  get descricaoProduto => this._descricaoProduto;

  set descricaoProduto(value) => this._descricaoProduto = value;

  get descricaoServico => this._descricaoServico;

  set descricaoServico(value) => this._descricaoServico = value;

  get descricaoAdicionalProduto => this._descricaoAdicionalProduto;

  set descricaoAdicionalProduto(value) =>
      this._descricaoAdicionalProduto = value;

  get descricaoAdicionalServico => this._descricaoAdicionalServico;

  set descricaoAdicionalServico(value) =>
      this._descricaoAdicionalServico = value;

  get tipoServico => this._tipoServico;

  set tipoServico(value) => this._tipoServico = value;

  get tipoProduto => this._tipoProduto;

  set tipoProduto(value) => this._tipoProduto = value;

  get custo => this._custo;

  set custo(value) => this._custo = value;

  get marca => this._marca;

  set marca(value) => this._marca = value;

  get obs => this._obs;

  set obs(value) => this._obs = value;

  get valorVista => this._valorVista;

  set valorVista(value) => this._valorVista = value;

  get valorPrazo => this._valorPrazo;

  set valorPrazo(value) => this._valorPrazo = value;

  get registroAtivo => this._registroAtivo;

  set registroAtivo(value) => this._registroAtivo = value;

  get dataCadastro => this._dataCadastro;

  set dataCadastro(value) => this._dataCadastro = value;
}
