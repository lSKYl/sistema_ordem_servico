import 'package:sistema_ordem_servico/modelo/marca.dart';

class ProdutoServico {
  int id = 0;
  String? nome;
  String? referenciaProduto;
  String? un;
  String? descricaoProduto;
  String? descricaoServico;
  String? descricaoAdicionalProduto;
  String? descricaoAdicionalServico;
  bool tipoServico = false;
  bool tipoProduto = true;
  double custo = 0;
  Marca marca = Marca();
  String? obs;
  double valorVista = 0;
  double valorPrazo = 0;
  bool registroAtivo = true;
  DateTime dataCadastro = DateTime.now();
}
