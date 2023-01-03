import 'package:sistema_ordem_servico/modelo/formapagamentoOS.dart';
import 'package:sistema_ordem_servico/modelo/ordemservicoprodutos.dart';
import 'package:sistema_ordem_servico/visao/ordemservico/dialog.cliente.dart';

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
              servicoexecutado = @servicoexecutado, obscomplementares = @obscomplementares, valorentrada = @valorentrada, valorvista = @valorvista, valorprazo = @valorprazo, valortotalvista = @valortotalvista, valormaoobra = @valormaoobra, valorpecas = @valorpecas, valorcusto = @valorcusto, carro_id = @carro_id, qtdprazo = @qtdprazo, vetorsedan = @vetorsedan, vetorpickup = @vetorpickup, vetorhatch = @vetorhatch, vetorsuv = @vetorsuv where id = @id""",
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
                    : ordemServico.valorCusto,
                "vetorsedan": ordemServico.vetorSedan,
                "vetorpickup": ordemServico.vetorCamionete,
                "vetorhatch": ordemServico.vetorHatch,
                "vetorsuv": ordemServico.vetorSuv
              });
        } else {
          List<Map<String, Map<String, dynamic>>> insertResult = await ctx
              .mappedResultsQuery("""insert into ordemservico (data, preventrega, situacaoatual, pessoa_id, funcionario_id, carro_id, problemaconstado, servicoexecutado, obscomplementares, 
              valorentrada, valorvista, valorprazo, valortotalvista, valormaoobra, qtdprazo, valorpecas, valorcusto, vetorsedan, vetorpickup, vetorhatch, vetorsuv) VALUES (@data, @preventrega, @situacaoatual, @pessoa_id, @funcionario_id, @carro_id, @problemaconstado, @servicoexecutado, @obscomplementares, 
              @valorentrada, @valorvista, @valorprazo, @valortotalvista, @valormaoobra, @qtdprazo, @valorpecas, @valorcusto, @vetorsedan, @vetorpickup, @vetorhatch, @vetorsuv) returning id""",
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
                    : ordemServico.valorCusto,
                "vetorsedan": ordemServico.vetorSedan,
                "vetorpickup": ordemServico.vetorCamionete,
                "vetorhatch": ordemServico.vetorHatch,
                "vetorsuv": ordemServico.vetorSuv
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
              .query("""INSERT INTO formapagos (ordemservico_id, formapagamento_id, valorpago) VALUES (@ordemservico_id, @formapagamento_id, @valorpago) returning id""",
                  substitutionValues: {
                "ordemservico_id": ordemServico.id,
                "formapagamento_id": formas.forma.id,
                "valorpago": formas.valorPago == null ? 0 : formas.valorPago
              });
        }

        await ctx.query(
            """DELETE FROM vetorsedan where id_ordemservico = @id""",
            substitutionValues: {"id": ordemServico.id});

        await ctx.query(
            """DELETE FROM vetorcamionete where id_ordemservico = @id""",
            substitutionValues: {"id": ordemServico.id});

        await ctx.query(
            """DELETE FROM vetorhatch where id_ordemservico = @id""",
            substitutionValues: {"id": ordemServico.id});

        await ctx.query("""DELETE FROM vetorsuv where id_ordemservico = @id""",
            substitutionValues: {"id": ordemServico.id});

        if (ordemServico.vetorSedan) {
          await ctx
              .query("""INSERT INTO vetorsedan (id_ordemservico, parte1, parte2, parte3, parte4, parte5, parte6, parte7, parte8, parte9, parte10, parte11, parte12, parte13, parte14,
          parte15, parte16, parte17, parte18, parte19, parte20, parte21, parte22, parte23, parte24, parte25, parte26, parte27) VALUES (@id_ordemservico, @parte1, @parte2, @parte3, @parte4, @parte5, @parte6, @parte7, @parte8, @parte9, @parte10, @parte11, @parte12, @parte13, @parte14,
          @parte15, @parte16, @parte17, @parte18, @parte19, @parte20, @parte21, @parte22, @parte23, @parte24, @parte25, @parte26, @parte27) returning id""",
                  substitutionValues: {
                "id_ordemservico": ordemServico.id,
                "parte1": ordemServico.sedan.parte1,
                "parte2": ordemServico.sedan.parte2,
                "parte3": ordemServico.sedan.parte3,
                "parte4": ordemServico.sedan.parte4,
                "parte5": ordemServico.sedan.parte5,
                "parte6": ordemServico.sedan.parte6,
                "parte7": ordemServico.sedan.parte7,
                "parte8": ordemServico.sedan.parte8,
                "parte9": ordemServico.sedan.parte9,
                "parte10": ordemServico.sedan.parte10,
                "parte11": ordemServico.sedan.parte11,
                "parte12": ordemServico.sedan.parte12,
                "parte13": ordemServico.sedan.parte13,
                "parte14": ordemServico.sedan.parte14,
                "parte15": ordemServico.sedan.parte15,
                "parte16": ordemServico.sedan.parte16,
                "parte17": ordemServico.sedan.parte17,
                "parte18": ordemServico.sedan.parte18,
                "parte19": ordemServico.sedan.parte19,
                "parte20": ordemServico.sedan.parte20,
                "parte21": ordemServico.sedan.parte21,
                "parte22": ordemServico.sedan.parte22,
                "parte23": ordemServico.sedan.parte23,
                "parte24": ordemServico.sedan.parte24,
                "parte25": ordemServico.sedan.parte25,
                "parte26": ordemServico.sedan.parte26,
                "parte27": ordemServico.sedan.parte27
              });
        } else if (ordemServico.vetorCamionete) {
          await ctx
              .query("""INSERT INTO vetorcamionete (id_ordemservico, parte1, parte2, parte3, parte4, parte5, parte6, parte7, parte8, parte9, parte10, parte11, parte12, parte13, parte14,
          parte15, parte16, parte17, parte18, parte19, parte20, parte21, parte22, parte23, parte24, parte25, parte26, parte27, parte28) VALUES (@id_ordemservico, @parte1, @parte2, @parte3, @parte4, @parte5, @parte6, @parte7, @parte8, @parte9, @parte10, @parte11, @parte12, @parte13, @parte14,
          @parte15, @parte16, @parte17, @parte18, @parte19, @parte20, @parte21, @parte22, @parte23, @parte24, @parte25, @parte26, @parte27, @parte28) returning id""",
                  substitutionValues: {
                "id_ordemservico": ordemServico.id,
                "parte1": ordemServico.pickup.parte1,
                "parte2": ordemServico.pickup.parte2,
                "parte3": ordemServico.pickup.parte3,
                "parte4": ordemServico.pickup.parte4,
                "parte5": ordemServico.pickup.parte5,
                "parte6": ordemServico.pickup.parte6,
                "parte7": ordemServico.pickup.parte7,
                "parte8": ordemServico.pickup.parte8,
                "parte9": ordemServico.pickup.parte9,
                "parte10": ordemServico.pickup.parte10,
                "parte11": ordemServico.pickup.parte11,
                "parte12": ordemServico.pickup.parte12,
                "parte13": ordemServico.pickup.parte13,
                "parte14": ordemServico.pickup.parte14,
                "parte15": ordemServico.pickup.parte15,
                "parte16": ordemServico.pickup.parte16,
                "parte17": ordemServico.pickup.parte17,
                "parte18": ordemServico.pickup.parte18,
                "parte19": ordemServico.pickup.parte19,
                "parte20": ordemServico.pickup.parte20,
                "parte21": ordemServico.pickup.parte21,
                "parte22": ordemServico.pickup.parte22,
                "parte23": ordemServico.pickup.parte23,
                "parte24": ordemServico.pickup.parte24,
                "parte25": ordemServico.pickup.parte25,
                "parte26": ordemServico.pickup.parte26,
                "parte27": ordemServico.pickup.parte27,
                "parte28": ordemServico.pickup.parte28
              });
        } else if (ordemServico.vetorHatch) {
          await ctx
              .query("""INSERT INTO vetorhatch (id_ordemservico, parte1, parte2, parte3, parte4, parte5, parte6, parte7, parte8, parte9, parte10, parte11, parte12, parte13, parte14,
          parte15, parte16, parte17, parte18, parte19, parte20, parte21, parte22, parte23, parte24, parte25) VALUES (@id_ordemservico, @parte1, @parte2, @parte3, @parte4, @parte5, @parte6, @parte7, @parte8, @parte9, @parte10, @parte11, @parte12, @parte13, @parte14,
          @parte15, @parte16, @parte17, @parte18, @parte19, @parte20, @parte21, @parte22, @parte23, @parte24, @parte25) returning id""",
                  substitutionValues: {
                "id_ordemservico": ordemServico.id,
                "parte1": ordemServico.hatch.parte1,
                "parte2": ordemServico.hatch.parte2,
                "parte3": ordemServico.hatch.parte3,
                "parte4": ordemServico.hatch.parte4,
                "parte5": ordemServico.hatch.parte5,
                "parte6": ordemServico.hatch.parte6,
                "parte7": ordemServico.hatch.parte7,
                "parte8": ordemServico.hatch.parte8,
                "parte9": ordemServico.hatch.parte9,
                "parte10": ordemServico.hatch.parte10,
                "parte11": ordemServico.hatch.parte11,
                "parte12": ordemServico.hatch.parte12,
                "parte13": ordemServico.hatch.parte13,
                "parte14": ordemServico.hatch.parte14,
                "parte15": ordemServico.hatch.parte15,
                "parte16": ordemServico.hatch.parte16,
                "parte17": ordemServico.hatch.parte17,
                "parte18": ordemServico.hatch.parte18,
                "parte19": ordemServico.hatch.parte19,
                "parte20": ordemServico.hatch.parte20,
                "parte21": ordemServico.hatch.parte21,
                "parte22": ordemServico.hatch.parte22,
                "parte23": ordemServico.hatch.parte23,
                "parte24": ordemServico.hatch.parte24,
                "parte25": ordemServico.hatch.parte25
              });
        } else if (ordemServico.vetorSuv) {
          await ctx
              .query("""INSERT INTO vetorsuv (id_ordemservico, parte1, parte2, parte3, parte4, parte5, parte6, parte7, parte8, parte9, parte10, parte11, parte12, parte13, parte14,
          parte15, parte16, parte17, parte18, parte19, parte20, parte21, parte22) VALUES (@id_ordemservico, @parte1, @parte2, @parte3, @parte4, @parte5, @parte6, @parte7, @parte8, @parte9, @parte10, @parte11, @parte12, @parte13, @parte14,
          @parte15, @parte16, @parte17, @parte18, @parte19, @parte20, @parte21, @parte22) returning id""",
                  substitutionValues: {
                "id_ordemservico": ordemServico.id,
                "parte1": ordemServico.suv.parte1,
                "parte2": ordemServico.suv.parte2,
                "parte3": ordemServico.suv.parte3,
                "parte4": ordemServico.suv.parte4,
                "parte5": ordemServico.suv.parte5,
                "parte6": ordemServico.suv.parte6,
                "parte7": ordemServico.suv.parte7,
                "parte8": ordemServico.suv.parte8,
                "parte9": ordemServico.suv.parte9,
                "parte10": ordemServico.suv.parte10,
                "parte11": ordemServico.suv.parte11,
                "parte12": ordemServico.suv.parte12,
                "parte13": ordemServico.suv.parte13,
                "parte14": ordemServico.suv.parte14,
                "parte15": ordemServico.suv.parte15,
                "parte16": ordemServico.suv.parte16,
                "parte17": ordemServico.suv.parte17,
                "parte18": ordemServico.suv.parte18,
                "parte19": ordemServico.suv.parte19,
                "parte20": ordemServico.suv.parte20,
                "parte21": ordemServico.suv.parte21,
                "parte22": ordemServico.suv.parte22
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
select ordem.*, cliente.nome, cliente.nomefantasia, cliente.cpf, cliente.cnpj, cliente.endereco, cliente.bairro, cliente.cidade, cliente.cep, func.nome, carro.modelo, carro.placa, carro.tipo, carro.cor, marca.nome  from ordemservico as ordem
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
        ordemServico.cliente.cep = row["pessoa"]?["cep"];
        ordemServico.veiculo.modelo = row["carro"]?["modelo"];
        ordemServico.veiculo.placa = row["carro"]?["placa"];
        ordemServico.veiculo.cor = row["carro"]?["cor"];
        ordemServico.veiculo.marca.nome = row["marcaveiculo"]?["nome"];
        ordemServico.veiculo.tipodeVeiculo = row["carro"]?["tipo"];
        ordemServico.funcionario.nome = row["funcionario"]?["nome"];
        ordemServico.vetorSedan = row["ordemservico"]?["vetorsedan"];
        ordemServico.vetorCamionete = row["ordemservico"]?["vetorpickup"];
        ordemServico.vetorHatch = row["ordemservico"]?["vetorhatch"];
        ordemServico.vetorSuv = row["ordemservico"]?["vetorsuv"];
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

      if (ordemServico.vetorSedan) {
        List<Map<String, Map<String, dynamic>>> vetor =
            await (await getConexaoPostgre()).mappedResultsQuery(
                """SELECT * from vetorsedan where id_ordemservico = @id""",
                substitutionValues: {"id": ordemServico.id});

        for (final row in vetor) {
          ordemServico.sedan.parte1 = row["vetorsedan"]?["parte1"];
          ordemServico.sedan.parte2 = row["vetorsedan"]?["parte2"];
          ordemServico.sedan.parte3 = row["vetorsedan"]?["parte3"];
          ordemServico.sedan.parte4 = row["vetorsedan"]?["parte4"];
          ordemServico.sedan.parte5 = row["vetorsedan"]?["parte5"];
          ordemServico.sedan.parte6 = row["vetorsedan"]?["parte6"];
          ordemServico.sedan.parte7 = row["vetorsedan"]?["parte7"];
          ordemServico.sedan.parte8 = row["vetorsedan"]?["parte8"];
          ordemServico.sedan.parte9 = row["vetorsedan"]?["parte9"];
          ordemServico.sedan.parte10 = row["vetorsedan"]?["parte10"];
          ordemServico.sedan.parte11 = row["vetorsedan"]?["parte11"];
          ordemServico.sedan.parte12 = row["vetorsedan"]?["parte12"];
          ordemServico.sedan.parte13 = row["vetorsedan"]?["parte13"];
          ordemServico.sedan.parte14 = row["vetorsedan"]?["parte14"];
          ordemServico.sedan.parte15 = row["vetorsedan"]?["parte15"];
          ordemServico.sedan.parte16 = row["vetorsedan"]?["parte16"];
          ordemServico.sedan.parte17 = row["vetorsedan"]?["parte17"];
          ordemServico.sedan.parte18 = row["vetorsedan"]?["parte18"];
          ordemServico.sedan.parte19 = row["vetorsedan"]?["parte19"];
          ordemServico.sedan.parte20 = row["vetorsedan"]?["parte20"];
          ordemServico.sedan.parte21 = row["vetorsedan"]?["parte21"];
          ordemServico.sedan.parte22 = row["vetorsedan"]?["parte22"];
          ordemServico.sedan.parte23 = row["vetorsedan"]?["parte23"];
          ordemServico.sedan.parte24 = row["vetorsedan"]?["parte24"];
          ordemServico.sedan.parte25 = row["vetorsedan"]?["parte25"];
          ordemServico.sedan.parte26 = row["vetorsedan"]?["parte26"];
          ordemServico.sedan.parte27 = row["vetorsedan"]?["parte27"];
        }
      } else if (ordemServico.vetorCamionete) {
        List<Map<String, Map<String, dynamic>>> vetor =
            await (await getConexaoPostgre()).mappedResultsQuery(
                """SELECT * from vetorcamionete where id_ordemservico = @id""",
                substitutionValues: {"id": ordemServico.id});

        for (final row in vetor) {
          ordemServico.pickup.parte1 = row["vetorcamionete"]?["parte1"];
          ordemServico.pickup.parte2 = row["vetorcamionete"]?["parte2"];
          ordemServico.pickup.parte3 = row["vetorcamionete"]?["parte3"];
          ordemServico.pickup.parte4 = row["vetorcamionete"]?["parte4"];
          ordemServico.pickup.parte5 = row["vetorcamionete"]?["parte5"];
          ordemServico.pickup.parte6 = row["vetorcamionete"]?["parte6"];
          ordemServico.pickup.parte7 = row["vetorcamionete"]?["parte7"];
          ordemServico.pickup.parte8 = row["vetorcamionete"]?["parte8"];
          ordemServico.pickup.parte9 = row["vetorcamionete"]?["parte9"];
          ordemServico.pickup.parte10 = row["vetorcamionete"]?["parte10"];
          ordemServico.pickup.parte11 = row["vetorcamionete"]?["parte11"];
          ordemServico.pickup.parte12 = row["vetorcamionete"]?["parte12"];
          ordemServico.pickup.parte13 = row["vetorcamionete"]?["parte13"];
          ordemServico.pickup.parte14 = row["vetorcamionete"]?["parte14"];
          ordemServico.pickup.parte15 = row["vetorcamionete"]?["parte15"];
          ordemServico.pickup.parte16 = row["vetorcamionete"]?["parte16"];
          ordemServico.pickup.parte17 = row["vetorcamionete"]?["parte17"];
          ordemServico.pickup.parte18 = row["vetorcamionete"]?["parte18"];
          ordemServico.pickup.parte19 = row["vetorcamionete"]?["parte19"];
          ordemServico.pickup.parte20 = row["vetorcamionete"]?["parte20"];
          ordemServico.pickup.parte21 = row["vetorcamionete"]?["parte21"];
          ordemServico.pickup.parte22 = row["vetorcamionete"]?["parte22"];
          ordemServico.pickup.parte23 = row["vetorcamionete"]?["parte23"];
          ordemServico.pickup.parte24 = row["vetorcamionete"]?["parte24"];
          ordemServico.pickup.parte25 = row["vetorcamionete"]?["parte25"];
          ordemServico.pickup.parte26 = row["vetorcamionete"]?["parte26"];
          ordemServico.pickup.parte27 = row["vetorcamionete"]?["parte27"];
          ordemServico.pickup.parte28 = row["vetorcamionete"]?["parte28"];
        }
      } else if (ordemServico.vetorHatch) {
        List<Map<String, Map<String, dynamic>>> vetor =
            await (await getConexaoPostgre()).mappedResultsQuery(
                """SELECT * from vetorhatch where id_ordemservico = @id""",
                substitutionValues: {"id": ordemServico.id});

        for (final row in vetor) {
          ordemServico.hatch.parte1 = row["vetorhatch"]?["parte1"];
          ordemServico.hatch.parte2 = row["vetorhatch"]?["parte2"];
          ordemServico.hatch.parte3 = row["vetorhatch"]?["parte3"];
          ordemServico.hatch.parte4 = row["vetorhatch"]?["parte4"];
          ordemServico.hatch.parte5 = row["vetorhatch"]?["parte5"];
          ordemServico.hatch.parte6 = row["vetorhatch"]?["parte6"];
          ordemServico.hatch.parte7 = row["vetorhatch"]?["parte7"];
          ordemServico.hatch.parte8 = row["vetorhatch"]?["parte8"];
          ordemServico.hatch.parte9 = row["vetorhatch"]?["parte9"];
          ordemServico.hatch.parte10 = row["vetorhatch"]?["parte10"];
          ordemServico.hatch.parte11 = row["vetorhatch"]?["parte11"];
          ordemServico.hatch.parte12 = row["vetorhatch"]?["parte12"];
          ordemServico.hatch.parte13 = row["vetorhatch"]?["parte13"];
          ordemServico.hatch.parte14 = row["vetorhatch"]?["parte14"];
          ordemServico.hatch.parte15 = row["vetorhatch"]?["parte15"];
          ordemServico.hatch.parte16 = row["vetorhatch"]?["parte16"];
          ordemServico.hatch.parte17 = row["vetorhatch"]?["parte17"];
          ordemServico.hatch.parte18 = row["vetorhatch"]?["parte18"];
          ordemServico.hatch.parte19 = row["vetorhatch"]?["parte19"];
          ordemServico.hatch.parte20 = row["vetorhatch"]?["parte20"];
          ordemServico.hatch.parte21 = row["vetorhatch"]?["parte21"];
          ordemServico.hatch.parte22 = row["vetorhatch"]?["parte22"];
          ordemServico.hatch.parte23 = row["vetorhatch"]?["parte23"];
          ordemServico.hatch.parte24 = row["vetorhatch"]?["parte24"];
          ordemServico.hatch.parte25 = row["vetorhatch"]?["parte25"];
        }
      } else if (ordemServico.vetorSuv) {
        List<Map<String, Map<String, dynamic>>> vetor =
            await (await getConexaoPostgre()).mappedResultsQuery(
                """SELECT * from vetorsuv where id_ordemservico = @id""",
                substitutionValues: {"id": ordemServico.id});

        for (final row in vetor) {
          ordemServico.suv.parte1 = row["vetorsuv"]?["parte1"];
          ordemServico.suv.parte2 = row["vetorsuv"]?["parte2"];
          ordemServico.suv.parte3 = row["vetorsuv"]?["parte3"];
          ordemServico.suv.parte4 = row["vetorsuv"]?["parte4"];
          ordemServico.suv.parte5 = row["vetorsuv"]?["parte5"];
          ordemServico.suv.parte6 = row["vetorsuv"]?["parte6"];
          ordemServico.suv.parte7 = row["vetorsuv"]?["parte7"];
          ordemServico.suv.parte8 = row["vetorsuv"]?["parte8"];
          ordemServico.suv.parte9 = row["vetorsuv"]?["parte9"];
          ordemServico.suv.parte10 = row["vetorsuv"]?["parte10"];
          ordemServico.suv.parte11 = row["vetorsuv"]?["parte11"];
          ordemServico.suv.parte12 = row["vetorsuv"]?["parte12"];
          ordemServico.suv.parte13 = row["vetorsuv"]?["parte13"];
          ordemServico.suv.parte14 = row["vetorsuv"]?["parte14"];
          ordemServico.suv.parte15 = row["vetorsuv"]?["parte15"];
          ordemServico.suv.parte16 = row["vetorsuv"]?["parte16"];
          ordemServico.suv.parte17 = row["vetorsuv"]?["parte17"];
          ordemServico.suv.parte18 = row["vetorsuv"]?["parte18"];
          ordemServico.suv.parte19 = row["vetorsuv"]?["parte19"];
          ordemServico.suv.parte20 = row["vetorsuv"]?["parte20"];
          ordemServico.suv.parte21 = row["vetorsuv"]?["parte21"];
          ordemServico.suv.parte22 = row["vetorsuv"]?["parte22"];
        }
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
where ordem.registroativo = true and lower(cliente.nome) like @filtro or ordem.registroativo = true and lower(carro.modelo) like @filtro or ordem.registroativo = true and lower(carro.placa) like @filtro or ordem.registroativo = true and lower(cliente.cpf) like @filtro or ordem.registroativo = true and lower(cliente.nomefantasia) like @filtro or ordem.registroativo = true and lower(cliente.cnpj) like @filtro""",
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