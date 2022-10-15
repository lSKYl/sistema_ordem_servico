import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/routes/app_routes.dart';
import 'visao/export_visao.dart';

void main() async {
  runApp(const MyApp());
  await DesktopWindow.setFullScreen(true);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de gerenciamento de Ordens de Serviço',
      routes: {
        AppRoutes.HOME: (context) => DashBoard(),
      },
    );
  }
}
