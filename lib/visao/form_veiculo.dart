import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/modelo/veiculo.dart';
import 'package:sistema_ordem_servico/controle/controle_veiculo.dart';
import 'package:sistema_ordem_servico/modelo/marcaveiculo.dart';
import 'package:sistema_ordem_servico/modelo/cliente.dart';
import 'package:sistema_ordem_servico/controle/controle_marca_veiculo.dart';
import 'package:sistema_ordem_servico/controle/controle_cliente.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/search_field.dart';

class FormVeiculo extends StatefulWidget {
  ControleVeiculo? controle;
  Function()? onSaved;
  FormVeiculo({super.key, this.controle, this.onSaved});

  @override
  State<FormVeiculo> createState() => _FormVeiculoState();
}

class _FormVeiculoState extends State<FormVeiculo> {
  final _chaveForm = GlobalKey<FormState>();
  final ControleMarcaVeiculo _controleMarca = ControleMarcaVeiculo();
  final ControlePessoa _controlePessoa = ControlePessoa();
  late TextEditingController marcaController =
      TextEditingController(text: widget.controle!.veiculoEmEdicao.marca.nome);
  late TextEditingController clienteController = TextEditingController(
      text: widget.controle!.veiculoEmEdicao.cliente.nome == ""
          ? widget.controle!.veiculoEmEdicao.cliente.nomeFantasia
          : widget.controle!.veiculoEmEdicao.cliente.nome);
  TextEditingController _controladorPesquisaCliente = TextEditingController();
  TextEditingController _controladorPesquisaMarca = TextEditingController();

  Future<void> salvar(BuildContext context) async {
    if (_chaveForm.currentState != null &&
        _chaveForm.currentState!.validate()) {
      _chaveForm.currentState!.save();

      widget.controle?.salvarVeiculoEmEdiao().then((value) {
        if (widget.onSaved != null) widget.onSaved!();
        Navigator.of(context).pop();
      });
    }
  }

  Widget listaMarcas() {
    return SizedBox(
      width: 500,
      height: 500,
      child: FutureBuilder(
        future: _controleMarca.marcasPesquisadas,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          if (snapshot.hasData) {
            _controleMarca.marcas = snapshot.data as List<MarcaVeiculo>;

            return ListView.builder(
              itemCount: _controleMarca.marcas.length,
              itemBuilder: (BuildContext context, int index) {
                MarcaVeiculo marca = _controleMarca.marcas[index];
                return SizedBox(
                  child: ListTileDialog(
                    object: _controleMarca.marcas[index],
                    nome: Text(marca.nome),
                    indice: index + 1,
                    subtitulo: const Text(""),
                    onTap: () {
                      _controleMarca.carregarMarca(marca).then((value) {
                        setState(() {
                          marcaController.text = value.nome!;
                          widget.controle!.veiculoEmEdicao.marca = value;
                          Navigator.pop(context);
                        });
                      });
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text('Carregando Dados'),
          );
        },
      ),
    );
  }

  Widget listaClientes() {
    return SizedBox(
      width: 500,
      height: 500,
      child: FutureBuilder(
          future: _controlePessoa.clientesPesquisados,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            if (snapshot.hasData) {
              _controlePessoa.clientes = snapshot.data as List<Cliente>;

              return ListView.builder(
                itemCount: _controlePessoa.clientes.length,
                itemBuilder: (context, index) {
                  Cliente cliente = _controlePessoa.clientes[index];
                  return SizedBox(
                    child: ListTileDialog(
                      object: _controlePessoa.clientes[index],
                      nome: cliente.nome == ""
                          ? Text(cliente.nomeFantasia)
                          : Text(cliente.nome),
                      subtitulo: cliente.cpf == ""
                          ? Text(cliente.cnpj!)
                          : Text(cliente.cpf),
                      indice: index + 1,
                      onTap: (() {
                        _controlePessoa.carregarCliente(cliente).then((value) {
                          setState(() {
                            clienteController.text = value.nome == ""
                                ? value.nomeFantasia!
                                : value.nome!;
                            widget.controle!.veiculoEmEdicao.cliente = value;
                            Navigator.pop(context);
                          });
                        });
                      }),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: Text('Carregando Dados'),
            );
          }),
    );
  }

  String? validar(text) {
    if (text == null || text.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Veiculo'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          salvar(context);
        },
        label: const Text('Salvar'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(children: [
        Padding(
            padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: MediaQuery.of(context).size.width > 1000
                    ? (MediaQuery.of(context).size.width - 1000) / 2
                    : 10,
                right: MediaQuery.of(context).size.width > 1000
                    ? (MediaQuery.of(context).size.width - 1000) / 2
                    : 10),
            child: Form(
              key: _chaveForm,
              child: Column(children: [
                CustomTextField(
                  label: "Modelo",
                  obscureText: false,
                  readonly: false,
                  maxlength: 45,
                  controller: TextEditingController(
                      text: widget.controle!.veiculoEmEdicao.modelo),
                  validator: validar,
                  onSaved: (String? value) {
                    widget.controle!.veiculoEmEdicao.modelo = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "Placa",
                  obscureText: false,
                  readonly: false,
                  maxlength: 7,
                  controller: TextEditingController(
                      text: widget.controle!.veiculoEmEdicao.placa),
                  validator: validar,
                  onSaved: (String? value) {
                    widget.controle!.veiculoEmEdicao.placa = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "Tipo",
                  obscureText: false,
                  readonly: false,
                  maxlength: 30,
                  controller: TextEditingController(
                      text: widget.controle!.veiculoEmEdicao.tipodeVeiculo),
                  onSaved: (String? value) {
                    widget.controle!.veiculoEmEdicao.tipodeVeiculo = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "Marca",
                  obscureText: false,
                  readonly: true,
                  controller: marcaController,
                  onTap: () {
                    setState(() {
                      _controleMarca.pesquisarMarcas();
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext builder) {
                          return StatefulBuilder(builder: ((context, setState) {
                            return AlertDialog(
                              title: SearchFieldDialog(
                                controller: _controladorPesquisaMarca,
                                onChanged: (text) {
                                  setState(
                                    () {
                                      _controleMarca.pesquisarMarcas(
                                          filtropesquisa:
                                              _controladorPesquisaMarca.text
                                                  .toLowerCase());
                                    },
                                  );
                                },
                                hint:
                                    'Digite a marca do veiculo que deseja pesquisar...',
                              ),
                              content: listaMarcas(),
                            );
                          }));
                        });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: 'Cliente',
                  obscureText: false,
                  readonly: true,
                  controller: clienteController,
                  validator: validar,
                  onTap: () {
                    setState(() {
                      _controlePessoa.pesquisarClientes();
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext builder) {
                          return StatefulBuilder(builder: ((context, setState) {
                            return AlertDialog(
                              title: SearchFieldDialog(
                                controller: _controladorPesquisaCliente,
                                onChanged: (text) {
                                  setState((() {
                                    _controlePessoa.pesquisarClientes(
                                        filtroPesquisa:
                                            _controladorPesquisaCliente.text
                                                .toLowerCase());
                                  }));
                                },
                                hint:
                                    "Digite o cliente que deseja pesquisar...",
                              ),
                              content: listaClientes(),
                            );
                          }));
                        });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "Cor",
                  obscureText: false,
                  readonly: false,
                  maxlength: 25,
                  controller: TextEditingController(
                      text: widget.controle!.veiculoEmEdicao.cor),
                  onSaved: (String? value) {
                    widget.controle!.veiculoEmEdicao.cor = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "Obs",
                  obscureText: false,
                  readonly: false,
                  maxlength: 200,
                  maxlines: 5,
                  controller: TextEditingController(
                      text: widget.controle!.veiculoEmEdicao.obs),
                  onSaved: (String? value) {
                    widget.controle!.veiculoEmEdicao.obs = value;
                  },
                )
              ]),
            ))
      ]),
    );
  }
}
