import 'package:sistema_ordem_servico/modelo/contato.dart';

abstract class Pessoa {
  int _id = 0;
  String? _nome = "";
  String? _cpf = "";
  String? _nomeFantasia = "";
  String? _endereco = "";
  String? _bairro = "";
  String? _cidade = "";
  String? _uf = "";
  String? _cep = "";
  get uf => this._uf;

  set uf(value) => this._uf = value;

  get cep => this._cep;

  set cep(value) => this._cep = value;
  String? get cidade => this._cidade;

  set cidade(String? value) => this._cidade = value;
  DateTime _dataCadastro = DateTime.now();
  String? _obs = "";

  bool _registroAtivo = true;
  List<Contato> _contatos = [];
  get id => this._id;

  set id(value) => this._id = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get cpf => this._cpf;

  set cpf(value) => this._cpf = value;

  get nomeFantasia => this._nomeFantasia;

  set nomeFantasia(value) => this._nomeFantasia = value;

  get endereco => this._endereco;

  set endereco(value) => this._endereco = value;

  get bairro => this._bairro;

  set bairro(value) => this._bairro = value;

  get dataCadastro => this._dataCadastro;

  set dataCadastro(value) => this._dataCadastro = value;

  get obs => this._obs;

  set obs(value) => this._obs = value;

  get registroAtivo => this._registroAtivo;

  set registroAtivo(value) => this._registroAtivo = value;

  List<Contato> get contatos => this._contatos;

  set contatos(List<Contato> value) => this._contatos = value;
}
