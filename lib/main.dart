import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/product_cache_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/viewmodels/product_viewmodel.dart';
import 'presentation/pages/product_page.dart';
import 'domain/product_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Dio>(create: (_) => Dio()),
        Provider<ProductRemoteDatasource>(
          create: (context) => ProductRemoteDatasource(context.read<Dio>()),
        ),
        Provider<ProductCacheDatasource>(
          create: (_) => ProductCacheDatasource(),
        ),
        ProxyProvider2<
          ProductRemoteDatasource,
          ProductCacheDatasource,
          ProductRepository
        >(
          update: (_, remote, cache, __) =>
              ProductRepositoryImpl(remote, cache),
        ),
        ChangeNotifierProvider<ProductViewModel>(
          create: (context) =>
              ProductViewModel(context.read<ProductRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Product App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<ProductViewModel>(
          builder: (context, viewModel, _) => ProductPage(viewModel: viewModel),
        ),
      ), // Agora o parêntese do MultiProvider fecha aqui corretamente
    );
  }
}
