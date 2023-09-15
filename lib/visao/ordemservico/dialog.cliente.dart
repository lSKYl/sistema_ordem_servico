import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_cliente.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';

import '../../modelo/cliente.dart';
import '../../modelo/contato.dart';
import '../../widgets/export_widgets.dart';

class OrdemDialogCliente extends StatefulWidget {
  OrdemDialogCliente({super.key, required this.ordem, required this.callback});
  final OrdemServico ordem;
  Function() callback;

  @override
  State<OrdemDialogCliente> createState() => _OrdemDialogClienteState();
}

class _OrdemDialogClienteState extends State<OrdemDialogCliente> {
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  bool clientes = true;
  bool clientesFisicos = false;
  bool clientesJuridicos = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controlePessoa.pesquisarClientes();
    });
  }

  Widget textRadio(String texto) {
    return Text(
      texto,
      style: TextStyle(fontSize: 14),
    );
  }

  final ControlePessoa _controlePessoa = ControlePessoa();
  Widget _listaCliente() {
    return SizedBox(
      width: 500,
      height: 300,
      child: FutureBuilder(
        future: _controlePessoa.clientesPesquisados,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          if (snapshot.hasData) {
            _controlePessoa.clientes = snapshot.data as List<Cliente>;

            return ListView.builder(
              itemCount: _controlePessoa.clientes.length,
              itemBuilder: ((context, index) {
                Cliente cliente = _controlePessoa.clientes[index];
                return SizedBox(
                  child: ListTileDialog(
                    object: cliente,
                    nome: cliente.nome == ""
                        ? Text(cliente.nomeFantasia)
                        : Text(cliente.nome),
                    subtitulo: cliente.cnpj == ""
                        ? Text(cliente.cpf!)
                        : Text(cliente.cnpj!),
                    indice: index + 1,
                    onTap: () {
                      _controlePessoa.carregarCliente(cliente).then((value) {
                        setState(() {
                          widget.ordem.cliente.contatos.clear();
                          widget.ordem.cliente.id = value.id;
                          widget.ordem.cliente.nome = value.nome;
                          widget.ordem.cliente.nomeFantasia =
                              value.nomeFantasia;
                          widget.ordem.cliente.cpf = value.cpf;
                          widget.ordem.cliente.cnpj = value.cnpj;
                          widget.ordem.cliente.endereco = value.endereco;
                          widget.ordem.cliente.bairro = value.bairro;
                          widget.ordem.cliente.cidade = value.cidade;
                          widget.ordem.cliente.cep = value.cep;
                          for (Contato cont in value.contatos) {
                            widget.ordem.cliente.contatos.add(cont);
                          }
                          widget.callback();
                          Navigator.pop(context);
                        });
                      });
                    },
                  ),
                );
              }),
            );
          }
          return const Center(
            child: Text('Carregando dados'),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Column(
          children: [
            SearchFieldDialog(
              hint: "Escreva o cliente que deseja pesquisar...",
              controller: _controladorCampoPesquisa,
              onChanged: ((_) {
                setState(() {
                  if (clientes) {
                    _controlePessoa.pesquisarClientes(
                        filtroPesquisa:
                            _controladorCampoPesquisa.text.toLowerCase());
                  } else if (clientesFisicos) {
                    _controlePessoa.pesquisarClientesFisicos(
                        filtroPesquisa:
                            _controladorCampoPesquisa.text.toLowerCase());
                  } else if (clientesJuridicos) {
                    _controlePessoa.pesquisarClientesJuridicos(
                        filtroPesquisa:
                            _controladorCampoPesquisa.text.toLowerCase());
                  }
                  setState;
                });
              }),
            ),
            Row(
              children: [
                Radio(
                    value: true,
                    groupValue: clientes,
                    onChanged: (_) {
                      setState(
                        () {
                          clientes = true;
                          clientesFisicos = false;
                          clientesJuridicos = false;
                          _controlePessoa.pesquisarClientes();
                        },
                      );
                    }),
                textRadio("Clientes físicos/jurídicos"),
                Radio(
                    value: true,
                    groupValue: clientesFisicos,
                    onChanged: (_) {
                      setState(
                        () {
                          clientes = false;
                          clientesFisicos = true;
                          clientesJuridicos = false;
                          _controlePessoa.pesquisarClientesFisicos();
                        },
                      );
                    }),
                textRadio("Clientes físicos"),
                Radio(
                    value: true,
                    groupValue: clientesJuridicos,
                    onChanged: (_) {
                      setState(
                        () {
                          clientes = false;
                          clientesFisicos = false;
                          clientesJuridicos = true;
                          _controlePessoa.pesquisarClientesJuridicos();
                        },
                      );
                    }),
                textRadio("Clientes jurídicos")
              ],
            )
          ],
        ),
        content: _listaCliente(),
      );
    });
  }
}
