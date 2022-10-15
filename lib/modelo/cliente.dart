import 'package:sistema_ordem_servico/modelo/pessoa.dart';

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
