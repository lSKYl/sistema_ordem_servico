import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_produto.dart';
import 'package:sistema_ordem_servico/modelo/produto_servico.dart';
import 'package:sistema_ordem_servico/visao/form_produto.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';

class ListProduto extends StatefulWidget {
  ListProduto({Key? key}) : super(key: key);

  @override
  State<ListProduto> createState() => _ListProdutoState();
}

class _ListProdutoState extends State<ListProduto> {
  final ControleProdutoServico _controle = ControleProdutoServico();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.carregarLista();
    });
  }

  Widget _listaProduto(ProdutoServico produto, int indice) {
    return CustomListTile(
      object: produto,
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
                    _controle.carregarLista();
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
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Lista de Produtos e Serviços'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
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
          _controle.produtoServicoEmEdicao = ProdutoServico();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormProduto(
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
        future: _controle.produtosLista,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasError) {
            return new Text("${snapshot.error}");
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
          return Center(
            child: Text('Carregando dados'),
          );
        },
      ),
    );
  }
}