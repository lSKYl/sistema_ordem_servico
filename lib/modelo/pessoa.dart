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
  get uf => _uf;

  set uf(value) => _uf = value;

  get cep => _cep;

  set cep(value) => _cep = value;
  String? get cidade => _cidade;

  set cidade(String? value) => _cidade = value;
  DateTime _dataCadastro = DateTime.now();
  String? _obs = "";

  bool _registroAtivo = true;
  List<Contato> _contatos = [];
  get id => _id;

  set id(value) => _id = value;

  get nome => _nome;

  set nome(value) => _nome = value;

  get cpf => _cpf;

  set cpf(value) => _cpf = value;

  get nomeFantasia => _nomeFantasia;

  set nomeFantasia(value) => _nomeFantasia = value;

  get endereco => _endereco;

  set endereco(value) => _endereco = value;

  get bairro => _bairro;

  set bairro(value) => _bairro = value;

  get dataCadastro => _dataCadastro;

  set dataCadastro(value) => _dataCadastro = value;

  get obs => _obs;

  set obs(value) => _obs = value;

  get registroAtivo => _registroAtivo;

  set registroAtivo(value) => _registroAtivo = value;

  List<Contato> get contatos => _contatos;

  set contatos(List<Contato> value) => _contatos = value;
}
