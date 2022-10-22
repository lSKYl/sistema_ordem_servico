import 'package:sistema_ordem_servico/modelo/contato.dart';

class Pessoa {
  int _id = 0;
  String? _nome;
  String? _cpf;
  String? _nomeFantasia;
  String? _endereco;
  String? _bairro;
  DateTime _dataCadastro = DateTime.now();
  String? _obs;
  bool _tipoF = false;
  bool _registroAtivo = true;
  List<Contato> _contatos = [];
  int get id => this._id;

  set id(int value) => this._id = value;

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

  get tipoF => this._tipoF;

  set tipoF(value) => this._tipoF = value;

  get registroAtivo => this._registroAtivo;

  set registroAtivo(value) => this._registroAtivo = value;

  get contatos => this._contatos;

  set contatos(value) => this._contatos = value;
}
