import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/modelo/veiculo.dart';
import 'package:sistema_ordem_servico/controle/controle_veiculo.dart';
import 'package:sistema_ordem_servico/visao/form_veiculo.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/search_field_appBar.dart';

class ListaVeiculo extends StatefulWidget {
  ListaVeiculo({super.key});

  @override
  State<ListaVeiculo> createState() => _ListaVeiculoState();
}

class _ListaVeiculoState extends State<ListaVeiculo> {
  final ControleVeiculo _controle = ControleVeiculo();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Lista de Veiculos');
  bool veiculosAtivos = true;
  bool veiculosDestivados = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.pesquisarVeiculo();
    });
  }

  Widget _listaVeiculo(Veiculo veiculo, int indice) {
    return CustomListTile(
      registro: veiculo.registroAtivo,
      color:
          veiculo.registroAtivo ? Colors.white : Color.fromARGB(255, 136, 1, 1),
      object: veiculo,
      textoExcluir: "Deseja realmente excluir esse veículo ?",
      textoAtivar: "Deseja realmente ativar esse veículo",
      index: indice + 1,
      title: Text('${veiculo.modelo} ${veiculo.marca.nome} ${veiculo.placa}'),
      subtitle: Row(children: [
        if (veiculo.cliente.nome == '') ...[
          Text(veiculo.cliente.nomeFantasia!),
          Text(' CNPJ: ${veiculo.cliente.cnpj!}')
        ] else ...[
          Text(veiculo.cliente.nome!),
          Text(' CPF: ${veiculo.cliente.cpf!}')
        ]
      ]),
      button1: () {
        _controle.carregarVeiculo(veiculo).then((value) {
          _controle.veiculoEmEdicao = value;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => FormVeiculo(
                        controle: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.pesquisarVeiculo();
                          });
                        },
                      ))));
        });
      },
      button2: () {
        _controle.carregarVeiculo(veiculo).then((value) {
          _controle.veiculoEmEdicao = value;
          _controle.excluirVeiculo().then((_) {
            Navigator.of(context).pop();
            setState(() {
              _controle.veiculos.remove(veiculo);
            });
          });
        });
      },
      button3: () {
        _controle.carregarVeiculo(veiculo).then((value) {
          _controle.veiculoEmEdicao = value;
          _controle.ativarVeiculo().then((_) {
            Navigator.of(context).pop();
            setState(() {
              _controle.veiculos.remove(veiculo);
            });
          });
        });
      },
    );
  }

  @override
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
                          if (veiculosAtivos) {
                            _controle.pesquisarVeiculo(
                                filtro: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          } else if (veiculosDestivados) {
                            _controle.pesquisarVeiculoDesativado(
                                filtro: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          }
                        });
                      }),
                      hint:
                          'Digite o modelo do veiculo que deseja pesquisar...',
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Lista de Veiculos');
                  }
                });
              },
              icon: customIcon),
          IconButton(
              onPressed: () {
                _controle.veiculoEmEdicao = Veiculo();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormVeiculo(
                              controle: _controle,
                              onSaved: () {
                                setState(() {
                                  _controle.pesquisarVeiculo();
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
          _controle.veiculoEmEdicao = Veiculo();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormVeiculo(
                        controle: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.pesquisarVeiculo();
                          });
                        },
                      )));
        },
        label: const Text('Adicionar'),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              children: [
                Radio(
                    value: true,
                    groupValue: veiculosAtivos,
                    onChanged: (_) {
                      setState(() {
                        veiculosAtivos = true;
                        veiculosDestivados = false;
                        _controle.pesquisarVeiculo();
                      });
                    }),
                const Text("Veículos ativos"),
                Radio(
                    value: true,
                    groupValue: veiculosDestivados,
                    onChanged: (_) {
                      setState(() {
                        veiculosAtivos = false;
                        veiculosDestivados = true;
                        _controle.pesquisarVeiculoDesativado();
                      });
                    }),
                const Text("Veículos desativados")
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _controle.veiculosLista,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return new Text("${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    _controle.veiculos = snapshot.data as List<Veiculo>;

                    return ListView.builder(
                        itemCount: _controle.veiculos.length,
                        itemBuilder: ((context, index) {
                          return _listaVeiculo(
                              _controle.veiculos[index], index);
                        }));
                  }
                  return const Center(
                    child: Text('Carregando Dados'),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
