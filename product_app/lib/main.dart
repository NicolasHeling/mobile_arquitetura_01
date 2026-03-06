import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repositoryimpl.dart';
import 'presentation/pages/product_page.dart';
import 'presentation/viewmodels/productviewmodel.dart';
import 'data/datasources/productcachedatasource.dart';

void main() {
  final dio = Dio();
  final datasource = ProductRemoteDatasource(dio);
  final cache = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(datasource, cache);
  final viewModel = ProductViewModel(repository);

  runApp(MyApp(viewModel: viewModel));
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;
  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      home: ProductPage(viewModel: viewModel),
    );
  }
}
