import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/modelo/cliente.dart';
import 'package:sistema_ordem_servico/visao/cliente_dados.dart';
import 'package:sistema_ordem_servico/controle/controle_cliente.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/search_field_appBar.dart';

class ListCliente extends StatefulWidget {
  ListCliente({Key? key}) : super(key: key);

  @override
  State<ListCliente> createState() => _ListClienteState();
}

class _ListClienteState extends State<ListCliente> {
  final ControlePessoa _controle = ControlePessoa();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Lista de clientes');

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.pesquisarClientes();
    });
  }

  Widget _listaCliente(Cliente cliente, int indice) {
    return CustomListTile(
      object: cliente,
      textoExcluir: "Desjea realmente excluir este cliente ?",
      index: indice + 1,
      title: Row(children: [
        if (cliente.nome == '') ...[
          Text(cliente.nomeFantasia!,
              style: const TextStyle(fontWeight: FontWeight.bold))
        ] else ...[
          Text(cliente.nome!,
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]
      ]),
      subtitle: Row(children: [
        if (cliente.nome == '') ...[
          Text(
            cliente.cnpj!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ] else ...[
          Text(cliente.cpf!,
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]
      ]),
      button1: () {
        _controle.carregarCliente(cliente).then((value) {
          _controle.clienteEmEdicao = value;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClienteDados(
                        controle: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.pesquisarClientes();
                          });
                        },
                      )));
        });
      },
      button2: () {
        _controle.carregarCliente(cliente).then((value) {
          _controle.clienteEmEdicao = value;
          _controle.excluirCliente().then((_) {
            Navigator.of(context).pop();
            setState(() {
              _controle.clientes.remove(cliente);
            });
          });
        });
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: customSearchBar,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = SearchField(
                      controller: _controladorCampoPesquisa,
                      onChanged: ((text) {
                        setState(() {
                          _controle.pesquisarClientes(
                              filtroPesquisa:
                                  _controladorCampoPesquisa.text.toLowerCase());
                        });
                      }),
                      hint: 'Digite o cliente que deseja pesquisar...',
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Lista de Clientes');
                  }
                });
              },
              icon: customIcon),
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
                                  _controle.pesquisarClientes();
                                });
                              },
                            )));
              },
              icon: const Icon(Icons.add))
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
                            _controle.pesquisarClientes();
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
