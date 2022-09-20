import 'contato.dart';

class Funcionario {
  int id = 0;
  String? nome;
  String? funcao;
  DateTime dataCadastro = DateTime.now();
  String? obs;
  String? endereco;
  String? bairro;
  bool registroAtivo = true;

  List<Contato> contatos = [];
}
