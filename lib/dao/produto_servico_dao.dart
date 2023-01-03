import 'conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/produto_servico.dart';

class ProdutoServicoDAO {
  Future<void> gravar(ProdutoServico produto) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        if (produto.id > 0) {
          await ctx
              .query("""update produtoservico set nome = @nome, referenciaproduto = @referencia, un = @un, obs = @obs,
        tipopro = @tipopro, tiposer = @tiposer, custo = @custo, marca_id = @marca_id, precoavista = @precoavista, precoprazo = @precoprazo,
        descricaoproduto = @descricaoproduto, descricaoadicionalproduto = @descricaoadicionalproduto, descricaoservico = @descricaoservico,
        descricaoadicionalservico = @descricaoadicionalservico where id = @id
         """, substitutionValues: {
            "id": produto.id,
            "nome": produto.nome,
            "referencia": produto.referenciaProduto,
            "un": produto.un,
            "obs": produto.obs,
            "tipopro": produto.tipoProduto,
            "tiposer": produto.tipoServico,
            "custo": produto.custo,
            "marca_id": produto.marca.id == 0 ? null : produto.marca.id,
            "precoavista": produto.valorVista,
            "precoprazo": produto.valorPrazo,
            "descricaoproduto": produto.descricaoProduto,
            "descricaoadicionalproduto": produto.descricaoAdicionalProduto,
            "descricaoservico": produto.descricaoServico,
            "descricaoadicionalservico": produto.descricaoAdicionalServico
          });
        } else {
          List<Map<String, Map<String, dynamic>>> insertResult = await ctx
              .mappedResultsQuery("""insert into produtoservico (nome, referenciaproduto,
        un, obs, tipopro, tiposer, datacadastro, custo, marca_id, precoavista, precoprazo, descricaoproduto, descricaoadicionalproduto, descricaoservico, descricaoadicionalservico) VALUES (@nome, @referencia, @un, @obs, @tipopro, @tiposer,
        @datacadastro, @custo, @marca, @precoavista, @precoprazo, @descricaoproduto, @descricaoadicionalproduto, @descricaoservico, @descricaoadicionalservico) returning id""",
                  substitutionValues: {
                "nome": produto.nome,
                "referencia": produto.referenciaProduto,
                "un": produto.un,
                "obs": produto.obs,
                "tipopro": produto.tipoProduto,
                "tiposer": produto.tipoServico,
                "datacadastro": produto.dataCadastro,
                "custo": produto.custo,
                "marca": produto.marca.id == 0 ? null : produto.marca.id,
                "precoavista": produto.valorVista,
                "precoprazo": produto.valorPrazo,
                "descricaoproduto": produto.descricaoProduto,
                "descricaoadicionalproduto": produto.descricaoAdicionalProduto,
                "descricaoservico": produto.descricaoServico,
                "descricaoadicionalservico": produto.descricaoAdicionalServico
              });
        }
      });
    } catch (e) {
      print('error');
      print(e.toString());
    }
  }

  Future<void> excluir(ProdutoServico produto) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query(
            "update produtoservico set registroativo = false where id = @id",
            substitutionValues: {"id": produto.id});
      });
    } catch (e) {
      print("Error");
      print(e.toString());
    }
  }

  Future<void> ativar(ProdutoServico produto) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query(
            "update produtoservico set registroativo = true where id = @id",
            substitutionValues: {"id": produto.id});
      });
    } catch (e) {
      print("Error");
      print(e.toString());
    }
  }

  Future<ProdutoServico> carregaObjetoPorId(int id, int marcaId) async {
    ProdutoServico produto = ProdutoServico();
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """select produto.*, marca.nome, marca.id from produtoservico as produto
left join marca as marca ON marca.id = produto.marca_id
where produto.id = @id order by lower(produto.nome)""",
              substitutionValues: {"id": id});

      for (final row in results) {
        produto.id = row["produtoservico"]?["id"];
        produto.nome = row["produtoservico"]?["nome"];
        produto.referenciaProduto = row["produtoservico"]?["referenciaproduto"];
        produto.un = row["produtoservico"]?["un"];
        produto.obs = row["produtoservico"]?["obs"];
        produto.tipoProduto = row["produtoservico"]?["tipopro"];
        produto.tipoServico = row["produtoservico"]?["tiposer"];
        produto.dataCadastro = row["produtoservico"]?["datacadastro"];
        produto.custo = row["produtoservico"]?["custo"] == null
            ? 0
            : double.parse(row["produtoservico"]?["custo"]);
        produto.valorVista =
            double.parse(row["produtoservico"]?["precoavista"]);
        produto.valorPrazo = double.parse(row["produtoservico"]?["precoprazo"]);
        produto.descricaoProduto = row["produtoservico"]?["descricaoproduto"];
        produto.descricaoAdicionalProduto =
            row["produtoservico"]?["descricaoadicionalproduto"];
        produto.descricaoServico = row["produtoservico"]?["descricaoservico"];
        produto.descricaoAdicionalServico =
            row["produtoservico"]?["descricaoadicionalservico"];

        produto.marca.id =
            row["marca"]?["id"] == null ? 0 : row["marca"]?["id"];
        if (produto.marca.id != 0) {
          produto.marca.nome = row["marca"]?["nome"];
        } else {
          produto.marca.nome = "";
        }
      }
    } catch (e) {
      print("Error");
      print(e.toString());
    }
    return produto;
  }

  Future<List<ProdutoServico>> pesquisar({String filtro = ""}) async {
    List<ProdutoServico> produtos = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """select produto.id, produto.nome, produto.precoavista, produto.precoprazo, produto.custo, produto.tipopro, produto.tiposer, marca.nome, marca.id from produtoservico as produto
left join marca as marca ON marca.id = produto.marca_id or marca.id = null
where produto.registroativo = true and lower(produto.nome) like @filtro order by lower(produto.nome)""",
              substitutionValues: {"filtro": "%$filtro%"});

      for (final row in results) {
        ProdutoServico produto = ProdutoServico();
        produto.id = row["produtoservico"]?["id"];
        produto.nome = row["produtoservico"]?["nome"];
        produto.valorVista =
            double.parse(row["produtoservico"]?["precoavista"]);
        produto.valorPrazo = double.parse(row["produtoservico"]?["precoprazo"]);
        produto.custo = row["produtoservico"]?["custo"] == null
            ? 0
            : double.parse(row["produtoservico"]?["custo"]);
        produto.tipoProduto = row["produtoservico"]?["tipopro"];
        produto.tipoServico = row["produtoservico"]?["tiposer"];
        produto.marca.id =
            row["marca"]?["id"] == null ? 0 : row["marca"]?["id"];
        if (produto.marca.id != 0) {
          produto.marca.nome = row["marca"]?["nome"];
        } else {
          produto.marca.nome = "";
        }

        produtos.add(produto);
      }
    } catch (e) {
      print('Error');
      print(e.toString());
    }
    return produtos;
  }

  Future<List<ProdutoServico>> pesquisarProduto({String filtro = ""}) async {
    List<ProdutoServico> produtos = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """select produto.id, produto.nome, produto.precoavista, produto.precoprazo, produto.custo, produto.tipopro, produto.tiposer, marca.nome, marca.id from produtoservico as produto
left join marca as marca ON marca.id = produto.marca_id or marca.id = null
where produto.registroativo = true and produto.tipopro = true and lower(produto.nome) like @filtro order by lower(produto.nome)""",
              substitutionValues: {"filtro": "%$filtro%"});

      for (final row in results) {
        ProdutoServico produto = ProdutoServico();
        produto.id = row["produtoservico"]?["id"];
        produto.nome = row["produtoservico"]?["nome"];
        produto.valorVista =
            double.parse(row["produtoservico"]?["precoavista"]);
        produto.valorPrazo = double.parse(row["produtoservico"]?["precoprazo"]);
        produto.custo = row["produtoservico"]?["custo"] == null
            ? 0
            : double.parse(row["produtoservico"]?["custo"]);
        produto.tipoProduto = row["produtoservico"]?["tipopro"];
        produto.tipoServico = row["produtoservico"]?["tiposer"];
        produto.marca.id =
            row["marca"]?["id"] == null ? 0 : row["marca"]?["id"];
        if (produto.marca.id != 0) {
          produto.marca.nome = row["marca"]?["nome"];
        } else {
          produto.marca.nome = "";
        }

        produtos.add(produto);
      }
    } catch (e) {
      print('Error');
      print(e.toString());
    }
    return produtos;
  }

  Future<List<ProdutoServico>> pesquisarServico({String filtro = ""}) async {
    List<ProdutoServico> produtos = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """select produto.id, produto.nome, produto.precoavista, produto.precoprazo, produto.custo, produto.tipopro, produto.tiposer, marca.nome, marca.id from produtoservico as produto
left join marca as marca ON marca.id = produto.marca_id or marca.id = null
where produto.registroativo = true and tiposer = true and lower(produto.nome) like @filtro order by lower(produto.nome)""",
              substitutionValues: {"filtro": "%$filtro%"});

      for (final row in results) {
        ProdutoServico produto = ProdutoServico();
        produto.id = row["produtoservico"]?["id"];
        produto.nome = row["produtoservico"]?["nome"];
        produto.valorVista =
            double.parse(row["produtoservico"]?["precoavista"]);
        produto.valorPrazo = double.parse(row["produtoservico"]?["precoprazo"]);
        produto.custo = row["produtoservico"]?["custo"] == null
            ? 0
            : double.parse(row["produtoservico"]?["custo"]);
        produto.tipoProduto = row["produtoservico"]?["tipopro"];
        produto.tipoServico = row["produtoservico"]?["tiposer"];
        produto.marca.id =
            row["marca"]?["id"] == null ? 0 : row["marca"]?["id"];
        if (produto.marca.id != 0) {
          produto.marca.nome = row["marca"]?["nome"];
        } else {
          produto.marca.nome = "";
        }

        produtos.add(produto);
      }
    } catch (e) {
      print('Error');
      print(e.toString());
    }
    return produtos;
  }

  Future<List<ProdutoServico>> pesquisarDesativado({String filtro = ""}) async {
    List<ProdutoServico> produtos = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """select produto.id, produto.nome, produto.precoavista, produto.precoprazo, produto.custo, produto.tipopro, produto.tiposer, produto.registroativo, marca.nome, marca.id from produtoservico as produto
left join marca as marca ON marca.id = produto.marca_id or marca.id = null
where produto.registroativo = false and lower(produto.nome) like @filtro order by lower(produto.nome)""",
              substitutionValues: {"filtro": "%$filtro%"});

      for (final row in results) {
        ProdutoServico produto = ProdutoServico();
        produto.id = row["produtoservico"]?["id"];
        produto.nome = row["produtoservico"]?["nome"];
        produto.valorVista =
            double.parse(row["produtoservico"]?["precoavista"]);
        produto.valorPrazo = double.parse(row["produtoservico"]?["precoprazo"]);
        produto.custo = row["produtoservico"]?["custo"] == null
            ? 0
            : double.parse(row["produtoservico"]?["custo"]);
        produto.tipoProduto = row["produtoservico"]?["tipopro"];
        produto.tipoServico = row["produtoservico"]?["tiposer"];
        produto.marca.id =
            row["marca"]?["id"] == null ? 0 : row["marca"]?["id"];
        if (produto.marca.id != 0) {
          produto.marca.nome = row["marca"]?["nome"];
        } else {
          produto.marca.nome = "";
        }
        produto.registroAtivo = row["produtoservico"]?["registroativo"];
        produtos.add(produto);
      }
    } catch (e) {
      print('Error');
      print(e.toString());
    }
    return produtos;
  }
}
