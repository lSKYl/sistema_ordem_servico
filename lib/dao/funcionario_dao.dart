import 'conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/funcionario.dart';

class FuncionarioDAO {
  Future<void> gravar(Funcionario funcionario) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        if (funcionario.id > 0) {
          await ctx.query(
              "update funcionario set nome = @nome, datacadastro = @datacadastro, funcao = @funcao, login = @login, senha = @senha, obs = @obs, endereco = @endereco, bairro = @bairro where id = @id",
              substitutionValues: {
                "id": funcionario.id,
                "nome": funcionario.nome,
                "datacadastro": funcionario.dataCadastro,
                "funcao": funcionario.funcao,
                "login": funcionario.login,
                "senha": funcionario.senha,
                "endereco": funcionario.endereco,
                "bairro": funcionario.bairro,
                "obs": funcionario.obs
              });
        } else {
          List<Map<String, Map<String, dynamic>>> insertResult = await ctx
              .mappedResultsQuery("""insert into funcionario (nome, datacadastro, funcao, login, senha, endereco, bairro, obs) VALUES (@nome, @datacadastro, @funcao, @login, @senha, @endereco, @bairro, @obs) returning id""",
                  substitutionValues: {
                "nome": funcionario.nome,
                "datacadastro": funcionario.dataCadastro,
                "funcao": funcionario.funcao,
                "login": funcionario.login,
                "senha": funcionario.senha,
                "endereco": funcionario.endereco,
                "bairro": funcionario.bairro,
                "obs": funcionario.obs
              });
        }
      });
    } catch (e) {
      print('error');
      print(e.toString());
    }
  }

  Future<void> excluir(Funcionario funcionario) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query(
            "update funcionario set registroativo = false where id = @id",
            substitutionValues: {"id": funcionario.id, "registroativo": false});
      });
    } catch (e) {
      print("Error");
      print(e.toString());
    }
  }

  Future<Funcionario> carregarObjetoPorId(int id) async {
    List<Map<String, Map<String, dynamic>>> results =
        await (await getConexaoPostgre()).mappedResultsQuery(
            """SELECT * from funcionario where id = @id by lower(nome)""",
            substitutionValues: {"id": id});

    Funcionario funcionario = Funcionario();
    for (final row in results) {
      funcionario.id = row["funcionario"]?["id"];
      funcionario.nome = row["funcionario"]?["nome"];
      funcionario.dataCadastro = row["funcionario"]?["datacadastro"];
      funcionario.login = row["funcionario"]?["login"];
      funcionario.senha = row["funcionario"]?["senha"];
      funcionario.funcao = row["funcionario"]?["funcao"];
      funcionario.endereco = row["funcionario"]?["endereco"];
      funcionario.bairro = row["funcionario"]?["bairro"];
      funcionario.obs = row["funcionario"]?["obs"];
    }
    return funcionario;
  }

  Future<List<Funcionario>> carregar() async {
    List<Funcionario> funcionarios = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome, funcao from funcionario where registroativo = true order by id""");

      for (final row in results) {
        Funcionario funcionario = Funcionario();
        funcionario.id = row["funcionario"]?["id"];
        funcionario.nome = row["funcionario"]?["nome"];
        funcionario.funcao = row["funcionario"]?["funcao"];
        funcionarios.add(funcionario);
      }
    } catch (e) {
      print('error');
      print(e.toString());
    }
    return funcionarios;
  }
}
