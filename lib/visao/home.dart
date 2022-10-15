// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/visao/list_cliente.dart';
import 'package:sistema_ordem_servico/visao/list_funcionario.dart';
import 'package:sistema_ordem_servico/visao/list_marca.dart';
import 'package:sistema_ordem_servico/visao/list_marca_veiculo.dart';
import 'package:sistema_ordem_servico/visao/list_produtos.dart';
import 'package:sistema_ordem_servico/visao/list_veiculos.dart';
import 'package:sistema_ordem_servico/widgets/export_widgets.dart';
import 'export_visao.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Sandro Martelinho de Ouro'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(100),
          child: SizedBox(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Button(
                            formulario: UserList(),
                            icon: Icon(Icons.assignment),
                            text: 'Ordens de Serviço'),
                        SizedBox(width: 15),
                        Button(
                          formulario: ListCliente(),
                          icon: Icon(Icons.group),
                          text: 'Clientes',
                        ),
                        SizedBox(width: 15),
                        Button(
                            formulario: ListProduto(),
                            icon: Icon(Icons.shopping_basket),
                            text: 'Produtos e Serviços'),
                        SizedBox(width: 15),
                        Button(
                            formulario: ListaVeiculo(),
                            icon: Icon(Icons.directions_car),
                            text: 'Veiculos'),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          formulario: ListFuncionario(),
                          icon: Icon(Icons.person),
                          text: 'Funcionarios',
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Button(
                            formulario: UserList(),
                            icon: Icon(Icons.assignment_ind),
                            text: 'Usuarios'),
                        SizedBox(
                          width: 15,
                        ),
                        Button(
                            formulario: ListMarca(),
                            icon: Icon(Icons.folder),
                            text: 'Marcas de Produto'),
                        SizedBox(width: 15),
                        Button(
                            formulario: ListMarcaVeiculo(),
                            icon: Icon(Icons.folder),
                            text: 'Marcas de Veiculos')
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
