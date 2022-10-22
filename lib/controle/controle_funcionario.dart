import 'package:sistema_ordem_servico/modelo/funcionario.dart';
import 'package:sistema_ordem_servico/dao/funcionario_dao.dart';

class ControleFuncionario {
  FuncionarioDAO dao = FuncionarioDAO();
  Funcionario funcionarioEmEdicao = Funcionario();
  List<Funcionario> funcionarios = [];
  Future<List<Funcionario>>? funcionariosPesquisados;
  Future<List<Funcionario>>? futureFuncionariosPesquisados;

  Future<Funcionario> carregarFuncionario(Funcionario funcionario) async {
    return dao.carregarObjetoPorId(funcionario.id);
  }

  Future<void> salvarFuncionarioEmEdicao() async {
    await dao.gravar(funcionarioEmEdicao);
  }

  Future<void> excluirFuncionario() async {
    dao.excluir(funcionarioEmEdicao);
  }

  Future<void> pesquisarFuncionario({String filtro = ""}) async {
    funcionariosPesquisados = dao.pesquisarFuncionario(filtro: filtro);
  }
}
