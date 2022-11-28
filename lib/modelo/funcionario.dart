import 'package:sistema_ordem_servico/modelo/pessoa.dart';

class Funcionario extends Pessoa {
  String? _funcao = "";
  String? get funcao => this._funcao;

  set funcao(String? value) => this._funcao = value;
}
