import 'conexao_postgres.dart';
import 'package:sistema_ordem_servico/modelo/cliente.dart';
import 'package:sistema_ordem_servico/modelo/contato.dart';

class ClienteDAO {
  //Grava ou altera o cliente no banco de dados;
  Future<void> gravar(Cliente cliente) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        if (cliente.id > 0) {
          await ctx
              .query("""update pessoa set nome = @nome, nomefantasia = @nomefantasia, endereco = @endereco, bairro = @bairro, cidade = @cidade, uf = @uf,
               cep = @cep, complemento = @complemento, cpf = @cpf, ie = @ie, numerorg = @numerorg, datacadastro = @datacadastro, obs = @obs, tipocli = @tipocli,
                tipofor = @tipofor where id = @id""", substitutionValues: {
            "id": cliente.id,
            "nome": cliente.nome,
            "nomefantasia": cliente.nomeFantasia,
            "endereco": cliente.endereco,
            "bairro": cliente.bairro,
            "cidade": cliente.cidade,
            "uf": cliente.uf,
            "cep": cliente.cep,
            "complemento": cliente.complemento,
            "cpf": cliente.cpf,
            "cnpj": cliente.cnpj,
            "ie": cliente.ie,
            "numerorg": cliente.numeroRG,
            "datacadastro": cliente.dataCadastro,
            "obs": cliente.obs,
            "tipocli": cliente.tipocC,
            "tipofor": cliente.tipoF,
          });
        } else {
          List<Map<String, Map<String, dynamic>>> insertResult = await ctx
              .mappedResultsQuery("""insert into pessoa (nome, nomefantasia, endereco, bairro, cidade, uf, 
              cep, complemento, cpf, cnpj, ie, numerorg, datacadastro, obs, tipocli, tipofor) VALUES (@nome, @nomefantasia, @endereco, @bairro, @cidade, 
              @uf, @cep, @complemento, @cpf, @cnpj, @ie, @numerorg, @datacadastro, @obs, @tipocli, @tipofor) returning id""",
                  substitutionValues: {
                "nome": cliente.nome,
                "nomefantasia": cliente.nomeFantasia,
                "endereco": cliente.endereco,
                "bairro": cliente.bairro,
                "cidade": cliente.cidade,
                "uf": cliente.uf,
                "cep": cliente.cep,
                "complemento": cliente.complemento,
                "cpf": cliente.cpf,
                "cnpj": cliente.cnpj,
                "ie": cliente.ie,
                "numerorg": cliente.numeroRG,
                "datacadastro": cliente.dataCadastro,
                "obs": cliente.obs,
                "tipocli": cliente.tipocC,
                "tipofor": cliente.tipoF,
              });

          for (final row in insertResult) {
            cliente.id = row["pessoa"]?["id"];
          }
        }
        // await ctx.query("""DELETE FROM contato where pessoa_id = @id""",
        //     substitutionValues: {"id": cliente.id});
        for (Contato cont in cliente.contatos) {
          await ctx
              .query("""INSERT INTO contato (tipo, numero, pessoa_id) VALUES (@tipo, @numero, @pessoa_id)""",
                  substitutionValues: {
                "tipo": cont.tipo,
                "numero": cont.numero,
                "pessoa_id": cliente.id
              });
        }
      });
    } catch (e) {
      print('error');
      print(e.toString());
    }
  }

  Future<void> excluir(Cliente cliente) async {
    try {
      (await getConexaoPostgre()).transaction((ctx) async {
        await ctx.query(
            "update pessoa set registroativo = false where id = @id",
            substitutionValues: {"id": cliente.id, "registroativo": false});
      });
    } catch (e) {
      print('error');
      print(e.toString());
    }
  }

  Future<Cliente> carregarObjetoPorId(int id) async {
    List<Map<String, Map<String, dynamic>>> results =
        await (await getConexaoPostgre()).mappedResultsQuery(
            """SELECT * from pessoa where id = @id order by lower(nome)""",
            substitutionValues: {"id": id});

    Cliente cliente = Cliente();
    for (final row in results) {
      cliente.id = row["pessoa"]?["id"];
      cliente.nome = row["pessoa"]?["nome"];
      cliente.nomeFantasia = row["pessoa"]?["nomefantasia"];
      cliente.cpf = row["pessoa"]?["cpf"];
      cliente.cnpj = row["pessoa"]?["cnpj"];
      cliente.numeroRG = row["pessoa"]?["numerorg"];
      cliente.endereco = row["pessoa"]?["endereco"];
      cliente.bairro = row["pessoa"]?["bairro"];
      cliente.cidade = row["pessoa"]?["cidade"];
      cliente.cep = row["pessoa"]?["cep"];
      cliente.uf = row["pessoa"]?["uf"];
      cliente.dataCadastro = row["pessoa"]?["datacadastro"];
      cliente.ie = row["pessoa"]?["ie"];
      cliente.complemento = row["pessoa"]?["complemento"];
      cliente.obs = row["pessoa"]?["obs"];
    }
    return cliente;
  }

  Future<List<Cliente>> pesquisar({String filtro = ""}) async {
    List<Cliente> clientes = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome, nomefantasia, cpf, cnpj from pessoa where registroativo = true and lower(nome) and lower(nomefantasia) like @filtro order by id""",
              substitutionValues: {"filtro": '$filtro'});

      for (final row in results) {
        Cliente cliente = Cliente();
        cliente.id = row["pessoa"]?["id"];
        cliente.nome = row["pessoa"]?["nome"];
        cliente.nomeFantasia = row["pessoa"]?["nomefantasia"];
        cliente.cpf = row["pessoa"]?["cpf"];
        cliente.cnpj = row["pessoa"]?["cnpj"];
        clientes.add(cliente);
      }
    } catch (e) {
      print('error');
      print(e.toString());
    }
    return clientes;
  }

  Future<List<Cliente>> carregar() async {
    List<Cliente> clientes = [];
    try {
      List<Map<String, Map<String, dynamic>>> results =
          await (await getConexaoPostgre()).mappedResultsQuery(
              """SELECT id, nome, nomefantasia, cpf, cnpj from pessoa where registroativo = true order by id""");

      for (final row in results) {
        Cliente cliente = Cliente();
        cliente.id = row["pessoa"]?["id"];
        cliente.nome = row["pessoa"]?["nome"];
        cliente.nomeFantasia = row["pessoa"]?["nomefantasia"];
        cliente.cpf = row["pessoa"]?["cpf"];
        cliente.cnpj = row["pessoa"]?["cnpj"];
        clientes.add(cliente);
      }
    } catch (e) {
      print('error');
      print(e.toString());
    }
    return clientes;
  }

  Future<List<Contato>> carregarCont(int id) async {
    List<Contato> contatos = [];

    List<Map<String, Map<String, dynamic>>> cont =
        await (await getConexaoPostgre()).mappedResultsQuery(
            """SELECT id, numero, tipo from contato where pessoa_id = @id""",
            substitutionValues: {"id": id});
    for (final row in cont) {
      Contato contato = Contato();
      contato.id = row["contato"]?["id"];
      contato.numero = row["contato"]?["numero"];
      contato.tipo = row["contato"]?["tipo"];
      contatos.add(contato);
    }
    return contatos;
  }
}
