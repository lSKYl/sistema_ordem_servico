import 'package:sistema_ordem_servico/modelo/cliente.dart';
import 'package:sistema_ordem_servico/modelo/marcaveiculo.dart';

class Veiculo {
  int _id = 0;
  String? _modelo;
  String? _placa;
  String? _tipodeVeiculo;
  String? _cor;
  String? _obs;
  Cliente _cliente = Cliente();
  bool _registroAtivo = true;

  MarcaVeiculo _marca = MarcaVeiculo();
  int get id => _id;

  set id(int value) => _id = value;

  get modelo => _modelo;

  set modelo(value) => _modelo = value;

  get placa => _placa;

  set placa(value) => _placa = value;

  get tipodeVeiculo => _tipodeVeiculo;

  set tipodeVeiculo(value) => _tipodeVeiculo = value;

  get cor => _cor;

  set cor(value) => _cor = value;

  get obs => _obs;

  set obs(value) => _obs = value;

  get cliente => _cliente;

  set cliente(value) => _cliente = value;

  get registroAtivo => _registroAtivo;

  set registroAtivo(value) => _registroAtivo = value;

  get marca => _marca;

  set marca(value) => _marca = value;
}
