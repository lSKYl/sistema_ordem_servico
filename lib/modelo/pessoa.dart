import 'package:sistema_ordem_servico/modelo/contato.dart';

class Pessoa {
  int id = 0;
  String? nome;
  String? cpf;
  String? nomeFantasia;
  String? endereco;
  String? bairro;
  DateTime dataCadastro = DateTime.now();
  String? obs;
  bool tipoF = false;
  bool registroAtivo = true;

  List<Contato> contatos = [];
}

class Cliente extends Pessoa {
  String? cnpj;
  String? ie;
  String? cidade;
  String? uf;
  String? cep;
  String? complemento;
  String? numeroRG;
  String? email;
  String? skype;
  bool tipocC = true;
}

class Fornecedor extends Pessoa {
  bool tipofor = true;
}
