import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_formapagamento.dart';
import 'package:sistema_ordem_servico/modelo/formapagamento.dart';
import 'package:sistema_ordem_servico/visao/form_forma_pag.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/search_field_appBar.dart';

class ListFormPag extends StatefulWidget {
  const ListFormPag({super.key});

  @override
  State<ListFormPag> createState() => _ListFormPagState();
}

class _ListFormPagState extends State<ListFormPag> {
  final ControleFormaPagamento _controleFormaPagamento =
      ControleFormaPagamento();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Lista de Formas de Pagamentos');
  bool formasAtivas = true;
  bool formasDesativadas = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controleFormaPagamento.pesquisarFormas();
    });
  }

  Widget _listaFormaPag(FormaPagamento forma, int indice) {
    return CustomListTile(
      registro: forma.registroAtivo,
      object: forma,
      color:
          forma.registroAtivo ? Colors.white : Color.fromARGB(255, 136, 1, 1),
      textoAtivar: "Deseja realmente ativar está forma de pagamento ?",
      textoExcluir: "Deseja realmente excluir está forma de pagamento ?",
      index: indice + 1,
      title: Text(
        forma.nome,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      button1: () {
        _controleFormaPagamento.carregarForma(forma).then((value) {
          _controleFormaPagamento.formaEmEdicao = value;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => FormFormaPag(
                        controle: _controleFormaPagamento,
                        onSaved: (() {
                          setState(() {
                            _controleFormaPagamento.pesquisarFormas();
                          });
                        }),
                      ))));
        });
      },
      button2: () {
        _controleFormaPagamento.carregarForma(forma).then((value) {
          _controleFormaPagamento.formaEmEdicao = value;
          _controleFormaPagamento.excluirFormaEmEdicao().then((_) {
            Navigator.of(context).pop();
            setState(() {
              _controleFormaPagamento.formas.remove(forma);
            });
          });
        });
      },
      button3: () {
        _controleFormaPagamento.carregarForma(forma).then((value) {
          _controleFormaPagamento.formaEmEdicao = value;
          _controleFormaPagamento.ativarFormaEmEdicao().then((_) {
            Navigator.of(context).pop();
            setState(() {
              _controleFormaPagamento.formas.remove(forma);
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
                          if (formasAtivas) {
                            _controleFormaPagamento.pesquisarFormas(
                                filtroPesquisa: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          } else if (formasDesativadas) {
                            _controleFormaPagamento.pesquisarFormasDesativadas(
                                filtroPesquisa: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          }
                        });
                      }),
                      hint: 'Digite a forma que deseja pesquisar...',
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar =
                        const Text('Lista de Forma de Pagamentos');
                  }
                });
              },
              icon: customIcon),
          IconButton(
              onPressed: () {
                _controleFormaPagamento.formaEmEdicao = FormaPagamento();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => FormFormaPag(
                              controle: _controleFormaPagamento,
                              onSaved: () {
                                setState(() {
                                  _controleFormaPagamento.pesquisarFormas();
                                });
                              },
                            ))));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _controleFormaPagamento.formaEmEdicao = FormaPagamento();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => FormFormaPag(
                        controle: _controleFormaPagamento,
                        onSaved: () {
                          setState(() {
                            _controleFormaPagamento.pesquisarFormas();
                          });
                        },
                      ))));
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
                    groupValue: formasAtivas,
                    onChanged: (_) {
                      setState(() {
                        formasAtivas = true;
                        formasDesativadas = false;
                        _controleFormaPagamento.pesquisarFormas();
                      });
                    }),
                const Text("Formas de pagamentos ativas"),
                Radio(
                    value: true,
                    groupValue: formasDesativadas,
                    onChanged: (_) {
                      setState(() {
                        formasAtivas = false;
                        formasDesativadas = true;
                        _controleFormaPagamento.pesquisarFormasDesativadas();
                      });
                    }),
                const Text("Formas de pagamentos desativadas")
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _controleFormaPagamento.formasPesquisadas,
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                if (snapshot.hasData) {
                  _controleFormaPagamento.formas =
                      snapshot.data as List<FormaPagamento>;

                  return ListView.builder(
                    itemCount: _controleFormaPagamento.formas.length,
                    itemBuilder: ((context, index) {
                      return _listaFormaPag(
                          _controleFormaPagamento.formas[index], index);
                    }),
                  );
                }
                return const Center(
                  child: Text('Carregando dados'),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
