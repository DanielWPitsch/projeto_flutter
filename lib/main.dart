import 'package:flutter/material.dart';
import 'view/listar_filmes.dart';
import 'view/detalhes_filme.dart';
import 'model/filme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Filmes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
      ),
      home: const ListarFilmes(),
      routes: {
        '/detalhes': (context) {
          final filme = ModalRoute.of(context)?.settings.arguments as Filme?;
          if (filme != null) {
            return DetalhesFilme(filme: filme);
          }
          return Scaffold(
            appBar: AppBar(title: const Text("Erro")),
            body: const Center(child: Text("Filme não encontrado.")),
          );
        },
      },
    );
  }
}
