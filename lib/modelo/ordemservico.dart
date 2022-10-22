import 'package:sistema_ordem_servico/modelo/cliente.dart';
import 'package:sistema_ordem_servico/modelo/formapagamentoOS.dart';
import 'package:sistema_ordem_servico/modelo/funcionario.dart';
import 'package:sistema_ordem_servico/modelo/ordemservicoprodutos.dart';
import 'package:sistema_ordem_servico/modelo/veiculo.dart';

import 'formapagamento.dart';

class OrdemServico {
  int _id = 0;
  DateTime _dataCadastro = DateTime.now();
  DateTime _previsaoEntrega = DateTime.now();
  String _situacaoAtual = "em andamento";
  Cliente _cliente = Cliente();
  int _qtdPrazo = 0;
  Funcionario _funcionario = Funcionario();
  bool _registroAtivo = true;
  Veiculo _veiculo = Veiculo();
  Veiculo get veiculo => _veiculo;

  set veiculo(Veiculo value) => this._veiculo = value;
  List<OrdemServicoProdutos> _ordemservicoprodutos = [];
  String? _problemaConstado;
  String? _servicoExecutado;
  String? _obsComplementares;
  double _valorEntrada = 0;
  double _valorVista = 0;
  double _valorPrazo = 0;
  double _valorTotal = 0;
  List<FormaPagamentoOrdemServico> _formas = [];
  List<FormaPagamentoOrdemServico> get formas => this._formas;

  set formas(List<FormaPagamentoOrdemServico> value) => this._formas = value;

  int get id => _id;

  set id(int value) => _id = value;

  get dataCadastro => _dataCadastro;

  set dataCadastro(value) => _dataCadastro = value;

  get previsaoEntrega => _previsaoEntrega;

  set previsaoEntrega(value) => _previsaoEntrega = value;

  get situacaoAtual => _situacaoAtual;

  set situacaoAtual(value) => _situacaoAtual = value;

  get cliente => _cliente;

  set cliente(value) => _cliente = value;

  get qtdPrazo => _qtdPrazo;

  set qtdPrazo(value) => _qtdPrazo = value;

  get funcionario => _funcionario;

  set funcionario(value) => _funcionario = value;

  get registroAtivo => _registroAtivo;

  set registroAtivo(value) => _registroAtivo = value;

  get ordemservicoprodutos => _ordemservicoprodutos;

  set ordemservicoprodutos(value) => _ordemservicoprodutos = value;

  get problemaConstado => _problemaConstado;

  set problemaConstado(value) => _problemaConstado = value;

  get servicoExecutado => _servicoExecutado;

  set servicoExecutado(value) => _servicoExecutado = value;

  get obsComplementares => _obsComplementares;

  set obsComplementares(value) => _obsComplementares = value;

  get valorEntrada => _valorEntrada;

  set valorEntrada(value) => _valorEntrada = value;

  get valorVista => _valorVista;

  set valorVista(value) => _valorVista = value;

  get valorPrazo => _valorPrazo;

  set valorPrazo(value) => _valorPrazo = value;

  get valorTotal => _valorTotal;

  set valorTotal(value) => _valorTotal = value;

  void adicionarServico(OrdemServicoProdutos servicoProdutos) {
    ordemservicoprodutos.add(servicoProdutos);
  }

  void recalcularTotal(OrdemServicoProdutos servicos) {
    for (var servico in ordemservicoprodutos) {
      double totalVista = servico.qtd * servico.produtoServico.valorVista;
      double totalPrazo = servico.qtd * servico.produtoServico.valorPrazo;
      valorVista = totalVista;
      valorPrazo = totalPrazo;
    }
  }
}
