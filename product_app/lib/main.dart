import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- Adicione o import do Provider

import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repositoryimpl.dart';
import 'presentation/pages/product_page.dart';
import 'presentation/viewmodels/productviewmodel.dart';
import 'data/datasources/productcachedatasource.dart';

void main() {
  // Configuração das dependências
  final dio = Dio();
  final datasource = ProductRemoteDatasource(dio);
  final cache = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(datasource, cache);

  runApp(
    // Envolvemos a raiz do app com o Provider
    // Assumindo que o ProductViewModel estenda ChangeNotifier
    ChangeNotifierProvider(
      create: (context) => ProductViewModel(repository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // O construtor fica limpo, sem necessidade de exigir o viewModel
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      home:
          const ProductPage(), // Retiramos a passagem por parâmetro aqui também
    );
  }
}
