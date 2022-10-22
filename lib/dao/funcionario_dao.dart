import 'conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/funcionario.dart';
import 'package:sistema_ordem_servico/modelo/contato.dart';

class FuncionarioDAO {
  Future<void> gravar(Funcionario funcionario) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        if (funcionario.id > 0) {
          await ctx.query(
              "update funcionario set nome = @nome, datacadastro = @datacadastro, funcao = @funcao, obs = @obs, endereco = @endereco, bairro = @bairro where id = @id",
              substitutionValues: {
                "id": funcionario.id,
                "nome": funcionario.nome,
                "datacadastro": funcionario.dataCadastro,
                "funcao": funcionario.funcao,
                "endereco": funcionario.endereco,
                "bairro": funcionario.bairro,
                "obs": funcionario.obs
              });
        } else {
          List<Map<String, Map<String, dynamic>>> insertResult = await ctx
              .mappedResultsQuery("""insert into funcionario (nome, datacadastro, funcao, endereco, bairro, obs) VALUES (@nome, @datacadastro, @funcao, @endereco, @bairro, @obs) returning id""",
                  substitutionValues: {
                "nome": funcionario.nome,
                "datacadastro": funcionario.dataCadastro,
                "funcao": funcionario.funcao,
                "endereco": funcionario.endereco,
                "bairro": funcionario.bairro,
                "obs": funcionario.obs
              });

          for (final row in insertResult) {
            funcionario.id = row["funcionario"]?["id"];
          }
        }
        await ctx.query("""DELETE FROM contato where funcionario_id = @id""",
            substitutionValues: {"id": funcionario.id});
        for (Contato cont in funcionario.contatos) {
          await ctx
              .query("""INSERT INTO contato (tipo, numero, funcionario_id) VALUES (@tipo, @numero, @funcionario_id)""",
                  substitutionValues: {
                "tipo": cont.tipo,
                "numero": cont.numero,
                "funcionario_id": funcionario.id
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
            """SELECT * from funcionario where id = @id order by lower(nome)""",
            substitutionValues: {"id": id});

    Funcionario funcionario = Funcionario();
    for (final row in results) {
      funcionario.id = row["funcionario"]?["id"];
      funcionario.nome = row["funcionario"]?["nome"];
      funcionario.dataCadastro = row["funcionario"]?["datacadastro"];
      funcionario.funcao = row["funcionario"]?["funcao"];
      funcionario.endereco = row["funcionario"]?["endereco"];
      funcionario.bairro = row["funcionario"]?["bairro"];
      funcionario.obs = row["funcionario"]?["obs"];
    }
    List<Map<String, Map<String, dynamic>>> cont =
        await (await getConexaoPostgre()).mappedResultsQuery(
            """SELECT * from contato where funcionario_id = @id""",
            substitutionValues: {"id": id});

    for (final row in cont) {
      Contato contato = Contato();
      contato.id = row["contato"]?["id"];
      contato.numero = row["contato"]?["numero"];
      contato.tipo = row["contato"]?["tipo"];
      funcionario.contatos.add(contato);
    }
    return funcionario;
  }

  Future<List<Funcionario>> pesquisarFuncionario({String filtro = ""}) async {
    List<Funcionario> funcionarios = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome, funcao from funcionario where registroativo = true and lower(nome) like @filtro order by lower(nome)""",
              substitutionValues: {"filtro": "%$filtro%"});

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

  // String hashPassWord(String senha) {
  //   final c1 = Crypt.sha256(senha);
  //   senha = c1.toString();
  //   return senha;
  // }
}
