import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_produto.dart';
import 'package:sistema_ordem_servico/modelo/produto_servico.dart';
import 'package:sistema_ordem_servico/visao/form_produto.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:sistema_ordem_servico/widgets/search_field_appBar.dart';

class ListProduto extends StatefulWidget {
  ListProduto({Key? key}) : super(key: key);

  @override
  State<ListProduto> createState() => _ListProdutoState();
}

class _ListProdutoState extends State<ListProduto> {
  final ControleProdutoServico _controle = ControleProdutoServico();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Lista de Produtos e Serviços');
  bool produtosAtivados = true;
  bool produtosDesativados = false;
  bool produtos = false;
  bool servicos = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.pesquisar();
    });
  }

  Widget _listaProduto(ProdutoServico produto, int indice) {
    return CustomListTile(
      registro: produto.registroAtivo,
      textoAtivar: 'Deseja ativar este produto ?',
      color: produto.registroAtivo == true ? Colors.white : Colors.red[900],
      object: produto,
      textoExcluir: "Deseja excluir este produto ?",
      index: indice + 1,
      title: Row(
        children: [
          Text(
            produto.nome!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
      subtitle: produto.tipoProduto == true
          ? const Text("Produto")
          : const Text("Serviço"),
      button1: () {
        _controle.carregarProduto(produto).then((value) {
          _controle.produtoServicoEmEdicao = value;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormProduto(
                controle: _controle,
                onSaved: (() {
                  setState(() {
                    _controle.pesquisar();
                  });
                }),
              ),
            ),
          );
        });
      },
      button2: () {
        _controle.carregarProduto(produto).then(
          (value) {
            _controle.produtoServicoEmEdicao = value;
            _controle.excluirProduto().then((_) {
              Navigator.of(context).pop();
              setState(() {
                _controle.produtos.remove(produto);
              });
            });
          },
        );
      },
      button3: () {
        _controle.carregarProduto(produto).then(
          (value) {
            _controle.produtoServicoEmEdicao = value;
            _controle.ativarProduto().then((_) {
              Navigator.of(context).pop();
              setState(() {
                _controle.produtos.remove(produto);
              });
            });
          },
        );
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
                      onChanged: (text) {
                        setState(() {
                          if (produtosAtivados) {
                            _controle.pesquisar(
                                filtroPesquisa: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          } else if (produtos) {
                            _controle.pesquisarProdutos(
                                filtroPesquisa: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          } else if (servicos) {
                            _controle.pesquisarServicos(
                                filtroPesquisa: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          } else if (produtosDesativados) {
                            _controle.pesquisarProdutoDesativados(
                                filtroPesquisa: _controladorCampoPesquisa.text
                                    .toLowerCase());
                          }
                        });
                      },
                      hint:
                          'Digite o produto ou serviço que deseja pesquuisar...',
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar =
                        const Text('Lista de Produtos e Serviços');
                  }
                });
              },
              icon: customIcon),
          IconButton(
              onPressed: () {
                _controle.produtoServicoEmEdicao = ProdutoServico();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormProduto(
                              controle: _controle,
                              onSaved: () {
                                setState(() {
                                  _controle.pesquisar();
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
          _controle.produtoServicoEmEdicao = ProdutoServico();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormProduto(
                        controle: _controle,
                        onSaved: () {
                          setState(() {
                            _controle.pesquisar();
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
            child: Row(children: [
              Radio(
                  value: true,
                  groupValue: produtosAtivados,
                  onChanged: (_) {
                    setState(() {
                      produtosAtivados = true;
                      produtos = false;
                      servicos = false;
                      produtosDesativados = false;
                      _controle.pesquisar();
                    });
                  }),
              const Text("Produtos e Serviços ativos"),
              Radio(
                  value: true,
                  groupValue: produtos,
                  onChanged: (_) {
                    setState(() {
                      produtosAtivados = false;
                      produtos = true;
                      servicos = false;
                      produtosDesativados = false;
                      _controle.pesquisarProdutos();
                    });
                  }),
              const Text("Produtos"),
              Radio(
                  value: true,
                  groupValue: servicos,
                  onChanged: (_) {
                    setState(() {
                      produtosAtivados = false;
                      produtos = false;
                      servicos = true;
                      produtosDesativados = false;
                      _controle.pesquisarServicos();
                    });
                  }),
              const Text("Serviços"),
              Radio(
                  value: true,
                  groupValue: produtosDesativados,
                  onChanged: (_) {
                    setState(() {
                      produtosAtivados = false;
                      produtos = false;
                      servicos = false;
                      produtosDesativados = true;
                      _controle.pesquisarProdutoDesativados();
                    });
                  }),
              const Text("Produtos e Serviços desativados")
            ]),
          ),
          Expanded(
            child: FutureBuilder(
              future: _controle.produtosLista,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                if (snapshot.hasData) {
                  _controle.produtos = snapshot.data as List<ProdutoServico>;

                  return ListView.builder(
                    itemCount: _controle.produtos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _listaProduto(_controle.produtos[index], index);
                    },
                  );
                }
                return const Center(
                  child: Text('Carregando dados'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
