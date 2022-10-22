import 'package:sistema_ordem_servico/modelo/formapagamento.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';

class FormaPagamentoOrdemServico {
  int _id = 0;
  OrdemServico _ordemServico = OrdemServico();
  FormaPagamento _forma = FormaPagamento();
  double _valorPago = 0;
  int get id => this._id;

  set id(int value) => this._id = value;

  get ordemServico => this._ordemServico;

  set ordemServico(value) => this._ordemServico = value;

  get forma => this._forma;

  set forma(value) => this._forma = value;

  get valorPago => this._valorPago;

  set valorPago(value) => this._valorPago = value;
}
