import 'package:sistema_ordem_servico/modelo/formapagamentoOS.dart';
import 'package:sistema_ordem_servico/modelo/ordemservicoprodutos.dart';

import '../modelo/contato.dart';
import 'conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';

class OrdemServicoDAO {
  Future<void> gravar(OrdemServico ordemServico) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        if (ordemServico.id > 0) {
          await ctx
              .query("""update ordemservico set  preventrega = @preventrega, situacaoatual = @situacaoatual, pessoa_id = @pessoa_id, funcionario_id = @funcionario_id, problemaconstado = @problemaconstado, 
              servicoexecutado = @servicoexecutado, obscomplementares = @obscomplementares, valorentrada = @valorentrada, valorvista = @valorvista, valorprazo = @valorprazo, valortotalvista = @valortotalvista, valormaoobra = @valormaoobra, valorpecas = @valorpecas, valorcusto = @valorcusto, carro_id = @carro_id, qtdprazo = @qtdprazo where id = @id""",
                  substitutionValues: {
                "id": ordemServico.id,
                "preventrega": ordemServico.previsaoEntrega,
                "situacaoatual": ordemServico.situacaoAtual,
                "pessoa_id": ordemServico.cliente.id,
                "funcionario_id": ordemServico.funcionario.id,
                "carro_id": ordemServico.veiculo.id,
                "problemaconstado": ordemServico.problemaConstado,
                "servicoexecutado": ordemServico.servicoExecutado,
                "obscomplementares": ordemServico.obsComplementares,
                "valorvista": ordemServico.valorVista == null
                    ? 0
                    : ordemServico.valorVista,
                "valorprazo": ordemServico.valorPrazo == null
                    ? 0
                    : ordemServico.valorPrazo,
                "valorentrada": ordemServico.valorEntrada == null
                    ? 0
                    : ordemServico.valorEntrada,
                "valortotalvista": ordemServico.valorTotalVista == null
                    ? 0
                    : ordemServico.valorTotalVista,
                "valormaoobra": ordemServico.valorMaodeObra == null
                    ? 0
                    : ordemServico.valorMaodeObra,
                "qtdprazo": ordemServico.qtdPrazo,
                "valorpecas": ordemServico.valorPecas == null
                    ? 0
                    : ordemServico.valorPecas,
                "valorcusto": ordemServico.valorCusto == null
                    ? 0
                    : ordemServico.valorCusto
              });
        } else {
          List<Map<String, Map<String, dynamic>>> insertResult = await ctx
              .mappedResultsQuery("""insert into ordemservico (data, preventrega, situacaoatual, pessoa_id, funcionario_id, carro_id, problemaconstado, servicoexecutado, obscomplementares, 
              valorentrada, valorvista, valorprazo, valortotalvista, valormaoobra, qtdprazo, valorpecas, valorcusto) VALUES (@data, @preventrega, @situacaoatual, @pessoa_id, @funcionario_id, @carro_id, @problemaconstado, @servicoexecutado, @obscomplementares, 
              @valorentrada, @valorvista, @valorprazo, @valortotalvista, @valormaoobra, @qtdprazo, @valorpecas, @valorcusto) returning id""",
                  substitutionValues: {
                "data": ordemServico.dataCadastro,
                "preventrega": ordemServico.previsaoEntrega,
                "situacaoatual": ordemServico.situacaoAtual,
                "pessoa_id": ordemServico.cliente.id,
                "funcionario_id": ordemServico.funcionario.id,
                "carro_id": ordemServico.veiculo.id,
                "problemaconstado": ordemServico.problemaConstado,
                "servicoexecutado": ordemServico.servicoExecutado,
                "obscomplementares": ordemServico.obsComplementares,
                "valorentrada": ordemServico.valorEntrada == 0
                    ? 0
                    : ordemServico.valorEntrada,
                "valorvista": ordemServico.valorVista == null
                    ? 0
                    : ordemServico.valorVista,
                "valorprazo": ordemServico.valorPrazo == null
                    ? 0
                    : ordemServico.valorPrazo,
                "valortotalvista": ordemServico.valorTotalVista == null
                    ? 0
                    : ordemServico.valorTotalVista,
                "valormaoobra": ordemServico.valorMaodeObra == null
                    ? 0
                    : ordemServico.valorMaodeObra,
                "qtdprazo":
                    ordemServico.qtdPrazo == null ? 1 : ordemServico.qtdPrazo,
                "valorpecas": ordemServico.valorPecas == null
                    ? 0
                    : ordemServico.valorPecas,
                "valorcusto": ordemServico.valorCusto == null
                    ? 0
                    : ordemServico.valorCusto
              });
          for (final row in insertResult) {
            ordemServico.id = row["ordemservico"]?["id"];
          }
        }
        await ctx.query(
            """DELETE FROM ordemservicoprodutos where ordemservico_id = @id""",
            substitutionValues: {"id": ordemServico.id});

        for (OrdemServicoProdutos produtos
            in ordemServico.ordemservicoprodutos) {
          await ctx
              .query("""INSERT INTO ordemservicoprodutos (id_produtoservico, qtd, valorprodutos, valormaoobra, desconto, ordemservico_id, precototalvista, precototalprazo) 
              VALUES (@id_produtoservico, @qtd, @valorprodutos, @valormaoobra, @desconto, @ordemservico_id, @precototalvista, @precototalprazo) returning id""",
                  substitutionValues: {
                "id_produtoservico": produtos.produtoServico.id,
                "qtd": produtos.qtd,
                "valorprodutos":
                    produtos.custoProdutos == null ? 0 : produtos.custoProdutos,
                "valormaoobra":
                    produtos.custoMaoObra == null ? 0 : produtos.custoMaoObra,
                "desconto": produtos.desconto == null ? 0 : produtos.desconto,
                "ordemservico_id": ordemServico.id,
                "precototalvista": produtos.precoTotalVista == null
                    ? 0
                    : produtos.precoTotalVista,
                "precototalprazo": produtos.precoTotalPrazo == null
                    ? 0
                    : produtos.precoTotalPrazo
              });
        }

        await ctx.query(
            """DELETE FROM formapagos where ordemservico_id = @id""",
            substitutionValues: {"id": ordemServico.id});

        for (FormaPagamentoOrdemServico formas in ordemServico.formas) {
          await ctx
              .query("""INSERT INTO formapagos (ordemservico_id, formapagamento_id, valorpago) VALUES (@ordemservico_id, @formapagamento_id, @valorpago)""",
                  substitutionValues: {
                "ordemservico_id": ordemServico.id,
                "formapagamento_id": formas.forma.id,
                "valorpago": formas.valorPago == null ? 0 : formas.valorPago
              });
        }
      });
    } catch (e) {
      print('ERROR');
      print(e.toString());
    }
  }

  Future<void> excluir(OrdemServico ordemServico) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query(
            """update ordemservico set registroativo = false where id = @id""",
            substitutionValues: {"id": ordemServico.id});
      });
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
  }

  // Future<void> finalizarOrdem(int id) async {
  //   try {
  //     (await getConexaoPostgre()).transaction((ctx) async {
  //       await ctx.query("""update ordemservico set situacaoatual""")
  //     });
  //   } catch (e) {
  //     print("ERROR");
  //     print(e.toString());
  //   }
  // }

  Future<OrdemServico> carregarObjetoPorId(int id) async {
    OrdemServico ordemServico = OrdemServico();
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery("""
select ordem.*, cliente.nome, cliente.nomefantasia, cliente.cpf, cliente.cnpj, cliente.endereco, cliente.bairro, cliente.cidade, func.nome, carro.modelo, carro.placa, carro.tipo, carro.cor, marca.nome  from ordemservico as ordem
inner join pessoa as cliente ON cliente.id = ordem.pessoa_id
inner join funcionario as func on func.id = ordem.funcionario_id
inner join carro as carro on carro.id = ordem.carro_id
inner join marcaveiculo as marca on marca.id = carro.marcaveiculo_id where ordem.id = @id""",
              substitutionValues: {"id": id});

      for (final row in results) {
        ordemServico.id = row["ordemservico"]?["id"];
        ordemServico.previsaoEntrega = row["ordemservico"]?["preventrega"];
        ordemServico.dataCadastro = row["ordemservico"]?["data"];
        ordemServico.situacaoAtual = row["ordemservico"]?["situacaoatual"];
        ordemServico.problemaConstado =
            row["ordemservico"]?["problemaconstado"];
        ordemServico.servicoExecutado =
            row["ordemservico"]?["servicoexecutado"];
        ordemServico.obsComplementares =
            row["ordemservico"]?["obscomplementares"];
        ordemServico.valorEntrada = row["ordemservico"]?["valorentrada"] == null
            ? 0
            : double.parse(row["ordemservico"]?["valorentrada"]);
        ordemServico.valorVista = row["ordemservico"]?["valorvista"] == null
            ? 0
            : double.parse(row["ordemservico"]?["valorvista"]);
        ordemServico.valorPrazo = row["ordemservico"]?["valorprazo"] == null
            ? 0
            : double.parse(row["ordemservico"]?["valorprazo"]);
        ordemServico.valorTotalVista =
            row["ordemservico"]?["valortotalvista"] == null
                ? 0
                : double.parse(row["ordemservico"]?["valortotalvista"]);
        ordemServico.valorMaodeObra =
            row["ordemservico"]?["valormaoobra"] == null
                ? 0
                : double.parse(row["ordemservico"]?["valormaoobra"]);
        ordemServico.qtdPrazo = row["ordemservico"]?["qtdprazo"] == null
            ? 0
            : row["ordemservico"]?["qtdprazo"];
        ordemServico.valorCusto = row["ordemservico"]?["valorcusto"] == null
            ? 0
            : double.parse(row["ordemservico"]?["valorcusto"]);
        ordemServico.valorPecas = row["ordemservico"]?["valorpecas"] == null
            ? 0
            : double.parse(row["ordemservico"]?["valorpecas"]);
        ordemServico.cliente.id = row["ordemservico"]?["pessoa_id"];
        ordemServico.funcionario.id = row["ordemservico"]?["funcionario_id"];
        ordemServico.veiculo.id = row["ordemservico"]?["carro_id"];
        ordemServico.cliente.nome = row["pessoa"]?["nome"];
        ordemServico.cliente.nomeFantasia = row["pessoa"]?["nomefantasia"];
        ordemServico.cliente.cpf = row["pessoa"]?["cpf"];
        ordemServico.cliente.cnpj = row["pessoa"]?["cnpj"];
        ordemServico.cliente.endereco = row["pessoa"]?["endereco"];
        ordemServico.cliente.bairro = row["pessoa"]?["bairro"];
        ordemServico.cliente.cidade = row["pessoa"]?["cidade"];
        ordemServico.veiculo.modelo = row["carro"]?["modelo"];
        ordemServico.veiculo.placa = row["carro"]?["placa"];
        ordemServico.veiculo.cor = row["carro"]?["cor"];
        ordemServico.veiculo.marca.nome = row["marcaveiculo"]?["nome"];
        ordemServico.funcionario.nome = row["funcionario"]?["nome"];
      }

      List<Map<String, Map<String, dynamic>>> cont =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, numero, tipo from contato where pessoa_id = @id""",
              substitutionValues: {"id": ordemServico.cliente.id});
      for (final row in cont) {
        Contato contato = Contato();
        contato.id = row["contato"]?["id"];
        contato.numero = row["contato"]?["numero"];
        contato.tipo = row["contato"]?["tipo"];
        ordemServico.cliente.contatos.add(contato);
      }

      List<Map<String, Map<String, dynamic>>> produtos =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """select ordem.*, produto.nome, marca.nome, produto.custo, produto.precoprazo, produto.precoavista, produto.un  from ordemservicoprodutos as ordem
inner join produtoservico as produto ON produto.id = ordem.id_produtoservico
left join marca as marca on marca.id = produto.marca_id where ordemservico_id = @id""",
              substitutionValues: {"id": ordemServico.id});

      for (final row in produtos) {
        OrdemServicoProdutos produtos = OrdemServicoProdutos();
        produtos.id = row["ordemservicoprodutos"]?["id"];
        produtos.produtoServico.id =
            row["ordemservicoprodutos"]?["id_produtoservico"];
        produtos.produtoServico.nome = row["produtoservico"]?["nome"];
        produtos.produtoServico.marca.nome = row["marca"]?["nome"];
        produtos.produtoServico.valorVista =
            double.parse(row["produtoservico"]?["precoavista"]);
        produtos.produtoServico.valorPrazo =
            double.parse(row["produtoservico"]?["precoprazo"]);
        produtos.produtoServico.un = row["produtoservico"]?["un"];
        produtos.qtd = double.parse(row["ordemservicoprodutos"]?["qtd"]);
        produtos.custoProdutos =
            double.parse(row["ordemservicoprodutos"]?["valorprodutos"]);
        produtos.custoMaoObra =
            double.parse(row["ordemservicoprodutos"]?["valormaoobra"]);
        produtos.desconto =
            double.parse(row["ordemservicoprodutos"]?["desconto"]);
        produtos.precoTotalVista =
            double.parse(row["ordemservicoprodutos"]?["precototalvista"]);
        produtos.precoTotalPrazo =
            double.parse(row["ordemservicoprodutos"]?["precototalprazo"]);

        ordemServico.ordemservicoprodutos.add(produtos);
      }

      List<Map<String, Map<String, dynamic>>> formaPag =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """select  formapagos.id, formapagos.formapagamento_id, formapagos.valorpago, formas.nome  from formapagos as formapagos
inner join formapagamento as formas on formas.id = formapagos.formapagamento_id where ordemservico_id = @id""",
              substitutionValues: {"id": ordemServico.id});

      for (final row in formaPag) {
        FormaPagamentoOrdemServico formaPagOs = FormaPagamentoOrdemServico();
        formaPagOs.id = row["formapagos"]?["id"];
        formaPagOs.valorPago = double.parse(row["formapagos"]?["valorpago"]);
        formaPagOs.forma.id = row["formapagos"]?["formapagamento_id"];
        formaPagOs.forma.nome = row["formapagamento"]?["nome"];
        ordemServico.formas.add(formaPagOs);
      }
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
    return ordemServico;
  }

  Future<List<OrdemServico>> pesquisarOrdem({String filtro = ""}) async {
    List<OrdemServico> ordens = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """select ordem.id, ordem.data, ordem.preventrega, ordem.pessoa_id, ordem.valortotalvista, ordem.funcionario_id, ordem.situacaoatual, ordem.carro_id, cliente.nome, cliente.nomefantasia, cliente.cpf, cliente.cnpj, func.nome, carro.modelo, carro.placa, carro.tipo, marca.id, marca.nome  from ordemservico as ordem
inner join pessoa as cliente ON cliente.id = ordem.pessoa_id
inner join funcionario as func on func.id = ordem.funcionario_id
inner join carro as carro on carro.id = ordem.carro_id
inner join marcaveiculo as marca on marca.id = carro.marcaveiculo_id
where ordem.registroativo = true and lower(cliente.nome) like @filtro order by lower(cliente.nome)""",
              substitutionValues: {"filtro": "%$filtro%"});

      for (final row in results) {
        OrdemServico ordemServico = OrdemServico();
        ordemServico.id = row["ordemservico"]?["id"];
        ordemServico.previsaoEntrega = row["ordemservico"]?["preventrega"];
        ordemServico.dataCadastro = row["ordemservico"]?["data"];
        ordemServico.cliente.id = row["ordemservico"]?["pessoa_id"];
        ordemServico.funcionario.id = row["ordemservico"]?["funcionario_id"];
        ordemServico.situacaoAtual = row["ordemservico"]?["situacaoatual"];
        ordemServico.valorTotalVista =
            row["ordemservico"]?["valortotalvista"] == null
                ? 0
                : double.parse(row["ordemservico"]?["valortotalvista"]);
        ordemServico.veiculo.id = row["ordemservico"]?["carro_id"];
        ordemServico.cliente.nome = row["pessoa"]?["nome"];
        ordemServico.cliente.nomeFantasia = row["pessoa"]?["nomefantasia"];
        ordemServico.cliente.cpf = row["pessoa"]?["cpf"];
        ordemServico.cliente.cnpj = row["pessoa"]?["cnpj"];
        ordemServico.funcionario.nome = row["funcionario"]?["nome"];
        ordemServico.veiculo.modelo = row["carro"]?["modelo"];
        ordemServico.veiculo.placa = row["carro"]?["placa"];
        ordemServico.veiculo.tipodeVeiculo = row["carro"]?["tipo"];
        ordemServico.veiculo.marca.id = row["marcaveiculo"]?["id"];
        ordemServico.veiculo.marca.nome = row["marcaveiculo"]?["nome"];

        ordens.add(ordemServico);
      }
    } catch (e) {
      print('error');
      print(e.toString());
    }
    return ordens;
  }
}

// // select cliente.nome, cliente.nomefantasia, marca.nome as marca_veiculo, veiculo.modelo from pessoa as cliente
// // inner join carro as veiculo on cliente.id = veiculo.pessoa_id and cliente.nome like 'fisico'
// // inner join marcaveiculo as marca ON marca.id = veiculo.marcaveiculo_id