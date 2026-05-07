import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importações da camada de dados
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/productcachedatasource.dart';
import 'data/repositories/product_repositoryimpl.dart';

// Importações da camada de apresentação
import 'presentation/viewmodels/productviewmodel.dart';
import 'presentation/pages/login_page.dart'; // Importação da nova Tela de Login

void main() {
  final dio = Dio();
  final datasource = ProductRemoteDatasource(dio);
  final cache = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(datasource, cache);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductViewModel(repository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // O fluxo agora começa pela LoginPage, impedindo acesso sem autenticação
      home: const LoginPage(),
    );
  }
}
