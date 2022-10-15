import 'package:sistema_ordem_servico/modelo/cliente.dart';
import 'package:sistema_ordem_servico/modelo/marcaveiculo.dart';

class Veiculo {
  int id = 0;
  String? modelo;
  String? placa;
  String? tipodeVeiculo;
  String? cor;
  String? obs;
  Cliente cliente = Cliente();
  bool registroAtivo = true;

  MarcaVeiculo marca = MarcaVeiculo();
}
