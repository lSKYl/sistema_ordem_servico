import 'package:sistema_ordem_servico/dao/conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/formapagamento.dart';

class FormaPagamentoDAO {
  Future<void> gravar(FormaPagamento formaPagamento) async {
    (await getConexaoPostgre()).transaction((ctx) async {
      if (formaPagamento.id > 0) {
        await ctx.query("update formapagamento set nome = @nome where id = @id",
            substitutionValues: {
              "id": formaPagamento.id,
              "nome": formaPagamento.nome
            });
      } else {
        List<
            Map<
                String,
                Map<String,
                    dynamic>>> insertResult = await ctx.mappedResultsQuery(
            """insert into formapagamento (nome) VALUES (@nome) returning id""",
            substitutionValues: {"nome": formaPagamento.nome});
        var row = insertResult[0];
        formaPagamento.id = row["formapagamento"]?["id"];
      }
    });
  }

  Future<void> excluir(FormaPagamento formaPagamento) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query(
            "update formapagamento set registroativo = false where id = @id",
            substitutionValues: {"id": formaPagamento.id});
      });
    } catch (e) {
      print('ERROR');
      print(e.toString());
    }
  }

  Future<void> ativar(FormaPagamento formaPagamento) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query(
            "update formapagamento set registroativo = true where id = @id",
            substitutionValues: {"id": formaPagamento.id});
      });
    } catch (e) {
      print('ERROR');
      print(e.toString());
    }
  }

  Future<FormaPagamento> carregarObetoPorId(int id) async {
    List<Map<String, Map<String, dynamic>>> results =
        await (await getConexaoPostgre()).mappedResultsQuery(
            """SELECT * from formapagamento where id = @id order by lower(nome)""",
            substitutionValues: {"id": id});

    FormaPagamento forma = FormaPagamento();
    for (final row in results) {
      forma.id = row["formapagamento"]?["id"];
      forma.nome = row["formapagamento"]?["nome"];
    }
    return forma;
  }

  Future<List<FormaPagamento>> pesquisar({String filtro = ""}) async {
    List<FormaPagamento> formas = [];
    List<Map<String, Map<String, dynamic>>> results =
        await (await getConexaoPostgre()).mappedResultsQuery(
            """SELECT id, nome, registroativo from formapagamento where registroativo = true and lower(nome) like @filtro order by lower(nome)""",
            substitutionValues: {"filtro": "%$filtro%"});

    for (final row in results) {
      FormaPagamento forma = FormaPagamento();
      forma.id = row["formapagamento"]?["id"];
      forma.nome = row["formapagamento"]?["nome"];
      forma.registroAtivo = row["formapagamento"]?["registroativo"];
      formas.add(forma);
    }
    return formas;
  }

  Future<List<FormaPagamento>> pesquisarDesativados(
      {String filtro = ""}) async {
    List<FormaPagamento> formas = [];
    List<Map<String, Map<String, dynamic>>> results =
        await (await getConexaoPostgre()).mappedResultsQuery(
            """SELECT id, nome, registroativo from formapagamento where registroativo = false and lower(nome) like @filtro order by lower(nome)""",
            substitutionValues: {"filtro": "%$filtro%"});

    for (final row in results) {
      FormaPagamento forma = FormaPagamento();
      forma.id = row["formapagamento"]?["id"];
      forma.nome = row["formapagamento"]?["nome"];
      forma.registroAtivo = row["formapagamento"]?["registroativo"];
      formas.add(forma);
    }
    return formas;
  }
}
