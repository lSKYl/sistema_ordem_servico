import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  String _situacaoAtual = "Em andamento";
  Cliente _cliente = Cliente();
  int _qtdPrazo = 1;
  Funcionario _funcionario = Funcionario();
  bool _registroAtivo = true;

  Veiculo _veiculo = Veiculo();

  List<OrdemServicoProdutos> _ordemservicoprodutos = [];
  String? _problemaConstado = "";
  String? _servicoExecutado = "";
  String? _obsComplementares = "";
  double _valorEntrada = 0;
  double _valorVista = 0;
  double _valorPrazo = 0;
  double _valorCusto = 0;
  double _valorPecas = 0;
  Uint8List? vetorVeiculo;
  double _valorMaodeObra = 0;
  double _valorTotalVista = 0;

  List<FormaPagamentoOrdemServico> _formas = [];
  int get id => this._id;

  set id(int value) => this._id = value;

  DateTime get dataCadastro => this._dataCadastro;

  set dataCadastro(DateTime value) => this._dataCadastro = value;

  DateTime get previsaoEntrega => this._previsaoEntrega;

  set previsaoEntrega(DateTime value) => this._previsaoEntrega = value;

  String get situacaoAtual => this._situacaoAtual;

  set situacaoAtual(String value) => this._situacaoAtual = value;

  Cliente get cliente => this._cliente;

  set cliente(Cliente value) => this._cliente = value;

  int get qtdPrazo => this._qtdPrazo;

  set qtdPrazo(int value) => this._qtdPrazo = value;

  Funcionario get funcionario => this._funcionario;

  set funcionario(Funcionario value) => this._funcionario = value;

  bool get registroAtivo => this._registroAtivo;

  set registroAtivo(bool value) => this._registroAtivo = value;

  Veiculo get veiculo => this._veiculo;

  set veiculo(Veiculo value) => this._veiculo = value;

  List<OrdemServicoProdutos> get ordemservicoprodutos =>
      this._ordemservicoprodutos;

  set ordemservicoprodutos(List<OrdemServicoProdutos> value) =>
      this._ordemservicoprodutos = value;

  String? get problemaConstado => this._problemaConstado;

  set problemaConstado(String? value) => this._problemaConstado = value;

  String? get servicoExecutado => this._servicoExecutado;

  set servicoExecutado(String? value) => this._servicoExecutado = value;

  String? get obsComplementares => this._obsComplementares;

  set obsComplementares(String? value) => this._obsComplementares = value;

  double get valorEntrada => this._valorEntrada;

  set valorEntrada(double value) => this._valorEntrada = value;

  double get valorVista => this._valorVista;

  set valorVista(double value) => this._valorVista = value;

  double get valorPrazo => this._valorPrazo;

  set valorPrazo(double value) => this._valorPrazo = value;

  double get valorCusto => this._valorCusto;

  set valorCusto(double value) => this._valorCusto = value;

  double get valorPecas => this._valorPecas;

  set valorPecas(double value) => this._valorPecas = value;

  double get valorMaodeObra => this._valorMaodeObra;

  set valorMaodeObra(double value) => this._valorMaodeObra = value;

  double get valorTotalVista => this._valorTotalVista;

  set valorTotalVista(double value) => this._valorTotalVista = value;

  List<FormaPagamentoOrdemServico> get formas => this._formas;

  set formas(List<FormaPagamentoOrdemServico> value) => this._formas = value;

  void adicionarServico(OrdemServicoProdutos servicoProdutos) {
    ordemservicoprodutos.add(servicoProdutos);
    recalcularTotal(servicoProdutos);
  }

  void recalcularTotal(OrdemServicoProdutos produtos) {
    double totalVista = produtos.precoTotalVista;
    valorTotalVista += totalVista;
    valorPrazo = totalVista;
    calcularPrazo();
    calcularCusto(produtos);
    calcularMaoDeObra(produtos);
    calcularProduto(produtos);

    print(valorTotalVista);
  }

  void calcularPrazo() {
    if (valorTotalVista != 0) {
      valorPrazo = valorTotalVista;
      valorPrazo = valorPrazo / qtdPrazo;
    } else {
      valorPrazo = 0.0;
    }
  }

  void calcularCusto(OrdemServicoProdutos produtos) {
    double custo = produtos.custoProdutos + produtos.custoMaoObra;
    valorCusto += custo;
  }

  void removerServico(OrdemServicoProdutos produtos) {
    produtos.precoTotalVista = -produtos.precoTotalVista;
    produtos.custoProdutos = -produtos.custoProdutos;
    produtos.custoMaoObra = -produtos.custoMaoObra;
    produtos.produtoServico.valorVista = -produtos.produtoServico.valorVista;

    recalcularTotal(produtos);

    ordemservicoprodutos.remove(produtos);
    calcularPrazo();
    print(valorTotalVista);
  }

  void calcularMaoDeObra(OrdemServicoProdutos produtos) {
    if (produtos.produtoServico.tipoServico == true) {
      double maodeObra = produtos.precoTotalVista;
      valorMaodeObra = valorMaodeObra + maodeObra;
    } else {
      return;
    }
  }

  void calcularProduto(OrdemServicoProdutos produtos) {
    if (produtos.produtoServico.tipoProduto == true) {
      double produto = produtos.precoTotalVista;
      valorPecas = valorPecas + produto;
    } else {
      return;
    }
  }

  void adicionarForma(FormaPagamentoOrdemServico forma) {
    formas.add(forma);
  }

  void removerForma(FormaPagamentoOrdemServico ordens) {
    formas.remove(ordens);
  }
}
