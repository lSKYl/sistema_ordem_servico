import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sistema_ordem_servico/modelo/cliente.dart';
import 'package:sistema_ordem_servico/modelo/formapagamentoOS.dart';
import 'package:sistema_ordem_servico/modelo/funcionario.dart';
import 'package:sistema_ordem_servico/modelo/ordemservicoprodutos.dart';
import 'package:sistema_ordem_servico/modelo/veiculo.dart';
import 'package:sistema_ordem_servico/modelo/vetorhatch.dart';
import 'package:sistema_ordem_servico/modelo/vetorpickup.dart';
import 'package:sistema_ordem_servico/modelo/vetorsedan.dart';
import 'package:sistema_ordem_servico/modelo/vetorsuv.dart';

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
  VetorSedan sedan = VetorSedan();
  VetorPickup pickup = VetorPickup();
  VetorHatch hatch = VetorHatch();
  VetorSuv suv = VetorSuv();
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
  bool vetorSedan = true;
  bool vetorCamionete = false;
  bool vetorHatch = false;
  bool vetorSuv = false;
  double _valorMaodeObra = 0;
  double _valorTotalVista = 0;

  List<FormaPagamentoOrdemServico> _formas = [];
  int get id => _id;

  set id(int value) => _id = value;

  DateTime get dataCadastro => _dataCadastro;

  set dataCadastro(DateTime value) => _dataCadastro = value;

  DateTime get previsaoEntrega => _previsaoEntrega;

  set previsaoEntrega(DateTime value) => _previsaoEntrega = value;

  String get situacaoAtual => _situacaoAtual;

  set situacaoAtual(String value) => _situacaoAtual = value;

  Cliente get cliente => _cliente;

  set cliente(Cliente value) => _cliente = value;

  int get qtdPrazo => _qtdPrazo;

  set qtdPrazo(int value) => _qtdPrazo = value;

  Funcionario get funcionario => _funcionario;

  set funcionario(Funcionario value) => _funcionario = value;

  bool get registroAtivo => _registroAtivo;

  set registroAtivo(bool value) => _registroAtivo = value;

  Veiculo get veiculo => _veiculo;

  set veiculo(Veiculo value) => _veiculo = value;

  List<OrdemServicoProdutos> get ordemservicoprodutos => _ordemservicoprodutos;

  set ordemservicoprodutos(List<OrdemServicoProdutos> value) =>
      _ordemservicoprodutos = value;

  String? get problemaConstado => _problemaConstado;

  set problemaConstado(String? value) => _problemaConstado = value;

  String? get servicoExecutado => _servicoExecutado;

  set servicoExecutado(String? value) => _servicoExecutado = value;

  String? get obsComplementares => _obsComplementares;

  set obsComplementares(String? value) => _obsComplementares = value;

  double get valorEntrada => _valorEntrada;

  set valorEntrada(double value) => _valorEntrada = value;

  double get valorVista => _valorVista;

  set valorVista(double value) => _valorVista = value;

  double get valorPrazo => _valorPrazo;

  set valorPrazo(double value) => _valorPrazo = value;

  double get valorCusto => _valorCusto;

  set valorCusto(double value) => _valorCusto = value;

  double get valorPecas => _valorPecas;

  set valorPecas(double value) => _valorPecas = value;

  double get valorMaodeObra => _valorMaodeObra;

  set valorMaodeObra(double value) => _valorMaodeObra = value;

  double get valorTotalVista => _valorTotalVista;

  set valorTotalVista(double value) => _valorTotalVista = value;

  List<FormaPagamentoOrdemServico> get formas => _formas;

  set formas(List<FormaPagamentoOrdemServico> value) => _formas = value;

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
