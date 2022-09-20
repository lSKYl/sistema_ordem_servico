import 'package:sistema_ordem_servico/modelo/contato.dart';

class Cliente {
  int id = 0;
  String? nome;
  String? nomeFantasia;
  String? endereco;
  String? bairro;
  String? cidade;
  String? uf;
  String? cep;
  String? complemento;
  String? cpf;
  String? cnpj;
  String? ie;
  String? numeroRG;
  DateTime dataCadastro = DateTime.now();
  String? obs;
  String? email;
  String? skype;
  bool tipocC = true;
  bool tipoF = false;
  bool registroAtivo = true;

  List<Contato> contatos = [];
}
