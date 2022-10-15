import 'package:sistema_ordem_servico/dao/conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/marca.dart';

class MarcaDAO {
  //Grava ou altera a marca no banco de dados;
  Future<void> gravar(Marca marca) async {
    (await getConexaoPostgre()).transaction((ctx) async {
      if (marca.id > 0) {
        await ctx.query("update marca set nome = @nome where id = @id",
            substitutionValues: {
              "id": marca.id,
              "nome": marca.nome,
              "registroativo": marca.registroAtivo,
            });
      } else {
        List<Map<String, Map<String, dynamic>>> insertResult = await ctx
            .mappedResultsQuery(
                """insert into marca (nome) VALUES (@nome) returning id""",
                substitutionValues: {"nome": marca.nome});
        var row = insertResult[0];
        marca.id = row["marca"]?["id"];
      }
    });
  }

  Future<void> excluir(Marca marca) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query("update marca set registroativo = false where id = @id",
            substitutionValues: {"id": marca.id});
      });
    } catch (e) {
      print('error');
      print(e.toString());
    }
  }

  Future<Marca> carregarObjetoPorID(int id) async {
    List<Map<String, Map<String, dynamic>>> results =
        await (await getConexaoPostgre())
            .mappedResultsQuery("""SELECT * from marca where id = @id
    order by lower(nome)""", substitutionValues: {"id": id});

    Marca marca = Marca();
    for (final row in results) {
      marca.id = row["marca"]?["id"];
      marca.nome = row["marca"]?["nome"];
    }
    return marca;
  }

  Future<List<Marca>> pesquisar({String filtro = ""}) async {
    List<Marca> marcas = [];
    List<Map<String, Map<String, dynamic>>> results =
        await (await getConexaoPostgre()).mappedResultsQuery(
            """SELECT id, nome from marca where registroativo = true and lower(nome) like '%12%'
    order by lower(nome)""",
            substitutionValues: {"filtro": '$filtro'});

    for (final row in results) {
      Marca marca = Marca();
      marca.id = row["marca"]?["id"];
      marca.nome = row["marca"]?["nome"];
      marcas.add(marca);
    }
    return marcas;
  }

  Future<List<Marca>> carregar() async {
    List<Marca> marcas = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome from marca where registroativo = true order by id""");

      for (final row in results) {
        Marca marca = Marca();
        marca.id = row["marca"]?["id"];
        marca.nome = row["marca"]?["nome"];
        marcas.add(marca);
      }
    } catch (e) {
      print('error');
      print(e.toString());
    }
    return marcas;
  }
}
