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
  int get id => _id;

  set id(int value) => _id = value;

  get nome => _nome;

  set nome(value) => _nome = value;

  get referenciaProduto => _referenciaProduto;

  set referenciaProduto(value) => _referenciaProduto = value;

  get un => _un;

  set un(value) => _un = value;

  get descricaoProduto => _descricaoProduto;

  set descricaoProduto(value) => _descricaoProduto = value;

  get descricaoServico => _descricaoServico;

  set descricaoServico(value) => _descricaoServico = value;

  get descricaoAdicionalProduto => _descricaoAdicionalProduto;

  set descricaoAdicionalProduto(value) => _descricaoAdicionalProduto = value;

  get descricaoAdicionalServico => _descricaoAdicionalServico;

  set descricaoAdicionalServico(value) => _descricaoAdicionalServico = value;

  get tipoServico => _tipoServico;

  set tipoServico(value) => _tipoServico = value;

  get tipoProduto => _tipoProduto;

  set tipoProduto(value) => _tipoProduto = value;

  get custo => _custo;

  set custo(value) => _custo = value;

  get marca => _marca;

  set marca(value) => _marca = value;

  get obs => _obs;

  set obs(value) => _obs = value;

  get valorVista => _valorVista;

  set valorVista(value) => _valorVista = value;

  get valorPrazo => _valorPrazo;

  set valorPrazo(value) => _valorPrazo = value;

  get registroAtivo => _registroAtivo;

  set registroAtivo(value) => _registroAtivo = value;

  get dataCadastro => _dataCadastro;

  set dataCadastro(value) => _dataCadastro = value;
}
