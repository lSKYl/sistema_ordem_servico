import 'package:sistema_ordem_servico/modelo/pessoa.dart';

class Funcionario extends Pessoa {
  String? _funcao = "";
  String? get funcao => _funcao;

  set funcao(String? value) => _funcao = value;
}
