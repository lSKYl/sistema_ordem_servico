import 'package:sistema_ordem_servico/modelo/pessoa.dart';

class Cliente extends Pessoa {
  String? _cnpj;
  String? _ie;
  String? _cidade;
  String? _uf;
  String? _cep;
  String? _complemento;
  String? _numeroRG;
  String? _email;
  String? _skype;
  bool _tipocC = true;
  String? get cnpj => this._cnpj;

  set cnpj(String? value) => this._cnpj = value;

  get ie => this._ie;

  set ie(value) => this._ie = value;

  get cidade => this._cidade;

  set cidade(value) => this._cidade = value;

  get uf => this._uf;

  set uf(value) => this._uf = value;

  get cep => this._cep;

  set cep(value) => this._cep = value;

  get complemento => this._complemento;

  set complemento(value) => this._complemento = value;

  get numeroRG => this._numeroRG;

  set numeroRG(value) => this._numeroRG = value;

  get email => this._email;

  set email(value) => this._email = value;

  get skype => this._skype;

  set skype(value) => this._skype = value;

  get tipocC => this._tipocC;

  set tipocC(value) => this._tipocC = value;
}
