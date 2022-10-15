import 'package:sistema_ordem_servico/modelo/veiculo.dart';

import 'conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/marcaveiculo.dart';
import 'package:sistema_ordem_servico/modelo/cliente.dart';

class VeiculoDAO {
  Future<void> gravar(Veiculo veiculo) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        if (veiculo.id > 0) {
          await ctx
              .query("""update carro set modelo = @modelo, placa = @placa, tipo = @tipo, cor = @cor, obs = @obs, 
          pessoa_id = @pessoa_id, marcaveiculo_id = @marcaveiculo_id where id = @id""",
                  substitutionValues: {
                "id": veiculo.id,
                "modelo": veiculo.modelo,
                "placa": veiculo.placa,
                "tipo": veiculo.tipodeVeiculo,
                "cor": veiculo.cor,
                "obs": veiculo.obs,
                "pessoa_id": veiculo.cliente.id,
                "marcaveiculo_id": veiculo.marca.id,
              });
        } else {
          List<Map<String, Map<String, dynamic>>> insertResult = await ctx
              .mappedResultsQuery("""INSERT INTO carro (modelo, placa, tipo, cor, obs, pessoa_id, marcaveiculo_id) VALUES (@modelo, @placa, @tipo, @cor, @obs, @pessoa_id, @marcaveiculo_id) returning id""",
                  substitutionValues: {
                "modelo": veiculo.modelo,
                "placa": veiculo.placa,
                "tipo": veiculo.tipodeVeiculo,
                "cor": veiculo.cor,
                "obs": veiculo.obs,
                "pessoa_id": veiculo.cliente.id,
                "marcaveiculo_id": veiculo.marca.id
              });
        }
      });
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
  }

  Future<void> excluir(Veiculo veiculo) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query(
            "update veiculo set registroativo = false where id = @id",
            substitutionValues: {"id": veiculo.id});
      });
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
  }

  Future<Veiculo> carregarObjetorPorId(
      int id, int marcaId, int clienteId) async {
    Veiculo veiculo = Veiculo();
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT * from carro where id = @id order by lower(modelo)""",
              substitutionValues: {"id": id});

      for (final row in results) {
        veiculo.id = row["carro"]?["id"];
        veiculo.modelo = row["carro"]?["modelo"];
        veiculo.placa = row["carro"]?["placa"];
        veiculo.tipodeVeiculo = row["carro"]?["tipo"];
        veiculo.obs = row["carro"]?["obs"];
      }

      List<Map<String, Map<String, dynamic>>> cliente =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome, nomefantasia from pessoa where id = @id order by lower(nome)""",
              substitutionValues: {"id": clienteId});

      for (final row in cliente) {
        veiculo.cliente.id = row["pessoa"]?["id"];
        veiculo.cliente.nome = row["pessoa"]?["nome"];
        veiculo.cliente.nomeFantasia = row["pessoa"]?["nomefantasia"];
      }

      List<Map<String, Map<String, dynamic>>> marca =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome from marcaveiculo where id = @id order by lower(nome)""",
              substitutionValues: {"id": marcaId});

      for (final row in marca) {
        veiculo.marca.id = row["marcaveiculo"]?["id"];
        veiculo.marca.nome = row["marcaveiculo"]?["nome"];
      }
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
    return veiculo;
  }

  Future<List<Veiculo>> carregar() async {
    List<Veiculo> veiculos = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, modelo, placa, tipo, marcaveiculo_id, pessoa_id from carro where registroativo = true order by id""");

      for (final row in results) {
        Veiculo veiculo = Veiculo();
        veiculo.id = row["carro"]?["id"];
        veiculo.modelo = row["carro"]?["modelo"];
        veiculo.placa = row["carro"]?["placa"];
        veiculo.cliente.id = row["carro"]?["pessoa_id"];
        veiculo.marca.id = row["carro"]?["marcaveiculo_id"];

        List<Map<String, Map<String, dynamic>>> marca =
            await (await getConexaoPostgre()).mappedResultsQuery(
                "SELECT * from marcaveiculo where id = @id",
                substitutionValues: {"id": veiculo.marca.id});
        for (final row2 in marca) {
          veiculo.marca.nome = row2["marcaveiculo"]?["nome"];
        }
        List<Map<String, Map<String, dynamic>>> cliente =
            await (await getConexaoPostgre()).mappedResultsQuery(
                "SELECT id, nome, nomefantasia, cpf, cnpj from pessoa where id = @id",
                substitutionValues: {"id": veiculo.cliente.id});
        for (final row3 in cliente) {
          veiculo.cliente.nome = row3["pessoa"]?["nome"];
          veiculo.cliente.cpf = row3["pessoa"]?["cpf"];
          veiculo.cliente.nomeFantasia = row3["pessoa"]?["nomefantasia"];
          veiculo.cliente.cnpj = row3["pessoa"]?["cnpj"];
        }
        veiculos.add(veiculo);
      }
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
    return veiculos;
  }
}
