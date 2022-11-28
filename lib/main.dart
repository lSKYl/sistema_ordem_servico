import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:sistema_ordem_servico/routes/app_routes.dart';
import 'package:sistema_ordem_servico/visao/ordemservico/form_ordemServico.dart';
import 'visao/export_visao.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  runApp(const MyApp());
  await DesktopWindow.setFullScreen(true);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      title: 'Sistema de gerenciamento de Ordens de Serviço',
      routes: {
        AppRoutes.HOME: (context) => const DashBoard(),
      },
    );
  }
}
