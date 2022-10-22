import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/controle/controle_ordemservico.dart';
import 'package:sistema_ordem_servico/modelo/ordemservico.dart';
import 'package:sistema_ordem_servico/visao/form_ordemServico.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'package:intl/intl.dart';
import 'package:sistema_ordem_servico/widgets/search_field_appBar.dart';

class ListOrdemServico extends StatefulWidget {
  const ListOrdemServico({super.key});

  @override
  State<ListOrdemServico> createState() => _ListOrdemServicoState();
}

class _ListOrdemServicoState extends State<ListOrdemServico> {
  final ControleOrdemServico _controle = ControleOrdemServico();
  final TextEditingController _controladorCampoPesquisa =
      TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Lista de Ordem de Serviços');
  var formatterData = DateFormat('dd/MM/yy');

  @override
  void initState() {
    super.initState();
    setState(() {
      _controle.pesquisarOrdem();
    });
  }

  Color corLista(OrdemServico ordem) {
    if (ordem.situacaoAtual == "Finalizado") {
      return const Color.fromARGB(255, 24, 122, 28);
    } else if (ordem.previsaoEntrega.compareTo(DateTime.now()) < 0 &&
        ordem.situacaoAtual != "Finalizado") {
      return const Color.fromARGB(255, 163, 35, 35);
    }
    return Colors.white;
  }

  Widget _listaOrdemServico(OrdemServico ordemServico, int indice) {
    return CustomListTile(
      object: ordemServico,
      index: indice + 1,
      color: corLista(ordemServico),
      title: Row(
        children: [
          if (ordemServico.cliente.nome == '') ...[
            Text(ordemServico.cliente.nomeFantasia!),
            const Text("CNPJ:"),
            Text(ordemServico.cliente.cnpj!)
          ] else ...[
            Text(ordemServico.cliente.nome!),
            const Text("CPF:"),
            Text(ordemServico.cliente.cpf!)
          ],
          const SizedBox(width: 20),
          const Text("Data Cadastro:"),
          Text(formatterData.format(ordemServico.dataCadastro)),
          const SizedBox(width: 5),
          const Text("Previsão de entrega:"),
          Text(formatterData.format(ordemServico.previsaoEntrega)),
          const SizedBox(width: 15),
          const Text('Valor Total:'),
          Text(ordemServico.valorTotal.toStringAsFixed(2).replaceAll('.', ','))
        ],
      ),
      subtitle: Row(children: [
        const Text('Modelo do Veiculo:'),
        Text(ordemServico.veiculo.modelo),
        const SizedBox(width: 5),
        const Text("Placa:"),
        Text(ordemServico.veiculo.marca.nome)
      ]),
      button1: () {
        _controle.carregarOrdem(ordemServico).then((value) {
          _controle.ordemServicoEmEdicao = value;
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => FormOrdemServico())));
        });
      },
      button2: () {
        _controle.carregarOrdem(ordemServico).then((value) {
          _controle.ordemServicoEmEdicao = value;
          _controle.excluirOrdem().then((value) {
            Navigator.of(context).pop();
            setState(() {
              _controle.ordens.remove(ordemServico);
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
                          _controle.pesquisarOrdem(
                              filtropesquisa:
                                  _controladorCampoPesquisa.text.toLowerCase());
                        });
                      }),
                      hint: "Digite a ordem de serviço que deseja buscar...",
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text("Lista de Ordem de Serviço");
                  }
                });
              },
              icon: customIcon),
          IconButton(
              onPressed: () {
                _controle.ordemServicoEmEdicao = OrdemServico();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => FormOrdemServico())));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _controle.ordensLista,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          if (snapshot.hasData) {
            _controle.ordens = snapshot.data as List<OrdemServico>;

            return ListView.builder(
              itemCount: _controle.ordens.length,
              itemBuilder: (context, index) {
                return _listaOrdemServico(_controle.ordens[index], index);
              },
            );
          }
          return const Center(
            child: Text('Carregando Dados'),
          );
        }),
      ),
    );
  }
}
