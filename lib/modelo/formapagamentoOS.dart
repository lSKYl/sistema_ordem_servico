import 'package:sistema_ordem_servico/modelo/formapagamento.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';

class FormaPagamentoOrdemServico {
  int _id = 0;
  OrdemServico _ordemServico = OrdemServico();
  FormaPagamento _forma = FormaPagamento();
  double _valorPago = 0;
  int get id => _id;

  set id(int value) => _id = value;

  get ordemServico => _ordemServico;

  set ordemServico(value) => _ordemServico = value;

  get forma => _forma;

  set forma(value) => _forma = value;

  get valorPago => _valorPago;

  set valorPago(value) => _valorPago = value;
}
