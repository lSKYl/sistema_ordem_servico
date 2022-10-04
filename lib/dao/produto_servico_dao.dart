import 'conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/produto_servico.dart';

class ProdutoServicoDAO {
  Future<void> gravar(ProdutoServico produto) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        if (produto.id > 0) {
          await ctx
              .query("""update produtoservico set nome = @nome, referenciaproduto = @referencia, un = @un, obs = @obs,
        tipopro = @tipopro, tiposer = @tiposer, custo = @custo, marca_id = @marca_id, precoavista = @precoavista, precoprazo = @precoprazo
        where id = @id
         """, substitutionValues: {
            "id": produto.id,
            "nome": produto.nome,
            "referencia": produto.referenciaProduto,
            "un": produto.un,
            "obs": produto.obs,
            "tiporo": produto.tipoProduto,
            "tiposer": produto.tipoServico,
            "custo": produto.custo,
            "marca_id": produto.marca.id,
            "precoavista": produto.valorVista,
            "precoprazo": produto.valorPrazo
          });
        } else {
          List<Map<String, Map<String, dynamic>>> insertResult = await ctx
              .mappedResultsQuery("""insert into produtoservico (nome, referenciaproduto,
        un, obs, tipopro, tiposer, datacadastro, custo, marca_id, precoavista, precoprazo) VALUES (@nome, @referencia, @un, @obs, @tipopro, @tiposer,
        @datacadastro, @custo, @marca, @precoavista, @precoprazo) returning id""",
                  substitutionValues: {
                "nome": produto.nome,
                "referencia": produto.referenciaProduto,
                "un": produto.un,
                "obs": produto.obs,
                "tipopro": produto.tipoProduto,
                "tipopro": produto.tipoServico,
                "datacadastro": produto.dataCadastro,
                "custo": produto.custo,
                "marca": produto.marca.id,
                "precoavista": produto.valorVista,
                "precoprazo": produto.valorPrazo
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

  Future<ProdutoServico> carregaObjetoPorId(int id, int marcaId) async {
    ProdutoServico produto = ProdutoServico();
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre())
              .mappedResultsQuery("""SELECT * from produtoservico 
    where id = @id order by lower(nome)""", substitutionValues: {"id": id});

      for (final row in results) {
        produto.id = row["produtoservico"]?["id"];
        produto.nome = row["produtoservico"]?["nome"];
        produto.referenciaProduto = row["produtoservico"]?["referenciaproduto"];
        produto.un = row["produtoservico"]?["un"];
        produto.obs = row["produtoservico"]?["obs"];
        produto.tipoProduto = row["produtoservico"]?["tipopro"];
        produto.tipoServico = row["produtoservico"]?["tiposer"];
        produto.dataCadastro = row["produtoservico"]?["datacadastro"];
        produto.custo = row["produtoservico"]?["custo"];
        produto.valorVista = row["produtoservico"]?["precoavista"];
        produto.valorPrazo = row["produtoservico"]?["precoprazo"];
      }

      List<Map<String, Map<String, dynamic>>> marca =
          await (await getConexaoPostgre()).mappedResultsQuery("""
SELECT * from marca where id = @id order by lower(nome)""",
              substitutionValues: {"id": marcaId});
      for (final row in marca) {
        produto.marca.id = row["marca"]?["id"];
        produto.marca.nome = row["marca"]?["nome"];
      }
    } catch (e) {
      print("Error");
      print(e.toString());
    }
    return produto;
  }

  Future<List<ProdutoServico>> carregar() async {
    List<ProdutoServico> produtos = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome, tipopro, tiposer, marca_id from produtoservico where registroativo = true order by id""");

      for (final row in results) {
        ProdutoServico produto = ProdutoServico();
        produto.id = row["produtoservico"]?["id"];
        produto.nome = row["produtoservico"]?["nome"];
        produto.tipoProduto = row["produtoservico"]?["tipopro"];
        produto.tipoServico = row["produtoservico"]?["tiposer"];
        produto.marca.id = row["produtoservico"]?["marca_id"];
        produtos.add(produto);
      }
    } catch (e) {
      print('Error');
      print(e.toString());
    }
    return produtos;
  }
}
