import 'package:sistema_ordem_servico/modelo/cliente.dart';
import 'package:sistema_ordem_servico/modelo/marcaveiculo.dart';

class Veiculo {
  int _id = 0;
  String? _modelo = "";
  String? _placa = "";
  String? _tipodeVeiculo = "";
  String? _cor = "";
  String? _obs = "";
  Cliente _cliente = Cliente();
  bool _registroAtivo = true;

  MarcaVeiculo _marca = MarcaVeiculo();
  get id => this._id;

  set id(value) => this._id = value;

  get modelo => this._modelo;

  set modelo(value) => this._modelo = value;

  get placa => this._placa;

  set placa(value) => this._placa = value;

  get tipodeVeiculo => this._tipodeVeiculo;

  set tipodeVeiculo(value) => this._tipodeVeiculo = value;

  get cor => this._cor;

  set cor(value) => this._cor = value;

  get obs => this._obs;

  set obs(value) => this._obs = value;

  get cliente => this._cliente;

  set cliente(value) => this._cliente = value;

  get registroAtivo => this._registroAtivo;

  set registroAtivo(value) => this._registroAtivo = value;

  get marca => this._marca;

  set marca(value) => this._marca = value;
}
