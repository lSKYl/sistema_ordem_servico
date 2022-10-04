import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_produto.dart';
import 'package:sistema_ordem_servico/modelo/produto_servico.dart';
import 'package:sistema_ordem_servico/visao/form_produto.dart';

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
    return Card(
        elevation: 15,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                '${indice + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
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
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
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
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext builder) {
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              title: const Text('ATENÇÃO'),
                              content: const Text(
                                'Deseja realmente excluir esta marca ?',
                                textAlign: TextAlign.center,
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _controle.carregarProduto(produto).then(
                                      (value) {
                                        _controle.produtoServicoEmEdicao =
                                            value;
                                        _controle.excluirProduto().then((_) {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _controle.produtos.remove(produto);
                                          });
                                        });
                                      },
                                    );
                                  },
                                  child: const Text('SIM'),
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
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  )
                ],
              ),
            ),
          ),
        ));
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
