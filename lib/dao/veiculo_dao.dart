import 'package:sistema_ordem_servico/modelo/veiculo.dart';

import 'conexao_postgres.dart';

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
              """select veiculo.*, cliente.nome, cliente.nomefantasia, cliente.cpf, cliente.cnpj, cliente.id, marca.id, marca.nome from carro as veiculo
inner join pessoa as cliente on cliente.id = veiculo.pessoa_id 
inner join marcaveiculo as marca ON marca.id = veiculo.marcaveiculo_id
where veiculo.id = @id""",
              substitutionValues: {"id": id});

      for (final row in results) {
        veiculo.id = row["carro"]?["id"];
        veiculo.modelo = row["carro"]?["modelo"];
        veiculo.placa = row["carro"]?["placa"];
        veiculo.tipodeVeiculo = row["carro"]?["tipo"];
        veiculo.obs = row["carro"]?["obs"];
        veiculo.cor = row["carro"]?["cor"];

        veiculo.cliente.id = row["pessoa"]?["id"];
        veiculo.cliente.nome = row["pessoa"]?["nome"];
        veiculo.cliente.nomeFantasia = row["pessoa"]?["nomefantasia"];

        veiculo.marca.id = row["marcaveiculo"]?["id"];
        veiculo.marca.nome = row["marcaveiculo"]?["nome"];
      }
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
    return veiculo;
  }

  Future<List<Veiculo>> pesquisarVeiculo({String filtro = ""}) async {
    List<Veiculo> veiculos = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """select veiculo.id, veiculo.modelo, veiculo.placa, marca.nome, cliente.nome, cliente.nomefantasia, cliente.cpf, cliente.cnpj, pessoa_id, marcaveiculo_id from carro as veiculo
inner join pessoa as cliente on cliente.id = veiculo.pessoa_id 
inner join marcaveiculo as marca ON marca.id = veiculo.marcaveiculo_id
where cliente.registroativo = true and lower(veiculo.modelo) like @filtro""",
              substitutionValues: {"filtro": "%$filtro%"});

      for (final row in results) {
        Veiculo veiculo = Veiculo();
        veiculo.id = row["carro"]?["id"];
        veiculo.modelo = row["carro"]?["modelo"];
        veiculo.placa = row["carro"]?["placa"];
        veiculo.cliente.id = row["carro"]?["pessoa_id"];
        veiculo.marca.id = row["carro"]?["marcaveiculo_id"];
        veiculo.cliente.nome = row["pessoa"]?["nome"];
        veiculo.cliente.nomeFantasia = row["pessoa"]?["nomefantasia"];
        veiculo.cliente.cpf = row["pessoa"]?["cpf"];
        veiculo.cliente.cnpj = row["pessoa"]?["cnpj"];
        veiculo.marca.nome = row["marcaveiculo"]?["nome"];

        veiculos.add(veiculo);
      }
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
    return veiculos;
  }
}
