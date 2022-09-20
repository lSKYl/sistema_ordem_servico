import 'package:sistema_ordem_servico/modelo/cliente.dart';
import 'package:sistema_ordem_servico/dao/cliente_dao.dart';

class ControlePessoa {
  ClienteDAO dao = ClienteDAO();
  Cliente clienteEmEdicao = Cliente();
  List<Cliente> clientes = [];
  Future<List<Cliente>>? clientesPesquisados;
  Future<List<Cliente>>? futureClientesPesquisados;

  Future<void> pesquisarClientes({String filtroPesquisa = ""}) async {
    futureClientesPesquisados = dao.pesquisar(filtro: filtroPesquisa);
  }

  Future<Cliente> carregarCliente(Cliente cliente) async {
    return dao.carregarObjetoPorId(cliente.id);
  }

  Future<void> salvarClienteEmEdicao() async {
    await dao.gravar(clienteEmEdicao);
  }

  Future<void> excluirCliente() async {
    dao.excluir(clienteEmEdicao);
  }

  Future<void> carregarLista() async {
    clientesPesquisados = dao.carregar();
  }
}
