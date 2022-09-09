import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/visao/cliente_dados.dart';
import 'package:sistema_ordem_servico/visao/export_visao.dart';
import 'package:sistema_ordem_servico/controle/controle_cliente.dart';
import 'form_cliente.dart';
import '../modelo/cliente.dart';

class ListCliente extends StatefulWidget {
  ListCliente({Key? key}) : super(key: key);

  @override
  State<ListCliente> createState() => _ListClienteState();
}

class _ListClienteState extends State<ListCliente> {
  final ControlePessoa _controle = ControlePessoa();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.carregarLista();
    });
  }

  Widget _listaCliente(Cliente cliente, int indice) {
    return Card(
      elevation: 15,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              '${indice + 1}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: Row(children: [
            if (cliente.nome == null) ...[
              Text(cliente.nomeFantasia!,
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ] else ...[
              Text(cliente.nome!,
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ]
          ]),
          subtitle: Row(children: [
            if (cliente.nome == null) ...[
              Text(cliente.cnpj!)
            ] else ...[
              Text(cliente.cpf!)
            ]
          ]),
          trailing: Container(
            width: 100,
            child: Row(children: [
              IconButton(
                onPressed: () {
                  _controle.carregarCliente(cliente).then((value) {
                    _controle.clienteEmEdicao = value;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClienteDados(
                                  controle: _controle,
                                  onSaved: () {
                                    setState(() {
                                      _controle.carregarLista();
                                    });
                                  },
                                )));
                  });
                },
                icon: Icon(Icons.edit),
                color: Colors.orange,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext builder) {
                        // ignore: prefer_const_constructors
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          title: const Text('ATENÇÃO'),
                          content: const Text(
                            'Deseja realmente excluir este cliente ?',
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _controle
                                      .carregarCliente(cliente)
                                      .then((value) {
                                    _controle.clienteEmEdicao = value;
                                    _controle.excluirCliente().then((_) {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        _controle.clientes.remove(cliente);
                                      });
                                    });
                                  });
                                },
                                child: Text('SIM')),
                            const SizedBox(
                              width: 20,
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('NÃO'))
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lista de Clientes'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _controle.clienteEmEdicao = Cliente();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClienteDados(
                              controle: _controle,
                              onSaved: () {
                                setState(() {
                                  _controle.carregarLista();
                                });
                              },
                            )));
              },
              icon: Icon(Icons.add))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _controle.clienteEmEdicao = Cliente();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClienteDados(
                        controle: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.carregarLista();
                          });
                        },
                      )));
        },
        label: const Text('Adicionar'),
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _controle.clientesPesquisados,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          if (snapshot.hasData) {
            _controle.clientes = snapshot.data as List<Cliente>;

            return ListView.builder(
              itemCount: _controle.clientes.length,
              itemBuilder: (BuildContext context, int index) {
                return _listaCliente(_controle.clientes[index], index);
              },
            );
          }
          return Center(
            child: Text('Carregando dados'),
          );
        },
      ),
    );
  }
}
