import 'package:sistema_ordem_servico/dao/conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/marcaveiculo.dart';

class MarcaVeiculoDAO {
  Future<void> gravar(MarcaVeiculo marca) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        if (marca.id > 0) {
          await ctx.query("update marcaveiculo set nome = @nome where id = @id",
              substitutionValues: {
                "id": marca.id,
                "nome": marca.nome,
                "registroativo": marca.registroAtivo
              });
        } else {
          List<
              Map<
                  String,
                  Map<String,
                      dynamic>>> insertResult = await ctx.mappedResultsQuery(
              """insert into marcaveiculo (nome) VALUES (@nome) returning id""",
              substitutionValues: {"nome": marca.nome});
        }
      });
    } catch (e) {
      print('error');
      print(e.toString());
    }
  }

  Future<void> excluir(MarcaVeiculo marca) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query("""update marcaveiculo set registroativo = false 
        where id = @id""", substitutionValues: {"id": marca.id});
      });
    } catch (e) {
      print("error");
      print(e.toString());
    }
  }

  Future<MarcaVeiculo> carregarObjetoPorId(int id) async {
    MarcaVeiculo marca = MarcaVeiculo();
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT * from marcaveiculo where id = @id order by lower(nome)""",
              substitutionValues: {"id": id});

      for (final row in results) {
        marca.id = row["marcaveiculo"]?["id"];
        marca.nome = row["marcaveiculo"]?["nome"];
      }
    } catch (e) {
      print("error");
      print(e.toString());
    }
    return marca;
  }

  Future<List<MarcaVeiculo>> pesquisar({String filtro = ""}) async {
    List<MarcaVeiculo> marcas = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome from marcaveiculo where registroativo = true and like @filtro
    order by lower(nome)""",
              substitutionValues: {"filtro": '$filtro'});

      for (final row in results) {
        MarcaVeiculo marca = MarcaVeiculo();
        marca.id = row["marca"]?["id"];
        marca.nome = row["marca"]?["nome"];
        marcas.add(marca);
      }
    } catch (e) {
      print("Error");
      print(e.toString());
    }
    return marcas;
  }

  Future<List<MarcaVeiculo>> carregar() async {
    List<MarcaVeiculo> marcas = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome from marcaveiculo where registroativo = true order by id""");

      for (final row in results) {
        MarcaVeiculo marca = MarcaVeiculo();
        marca.id = row["marcaveiculo"]?["id"];
        marca.nome = row["marcaveiculo"]?["nome"];
        marcas.add(marca);
      }
    } catch (e) {
      print("Error");
      print(e.toString());
    }
    return marcas;
  }
}
