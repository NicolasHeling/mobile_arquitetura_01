import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product_model.dart';
import '../viewmodels/productviewmodel.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product; // Se for nulo, é cadastro. Se não, é edição.

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _imageController = TextEditingController(text: widget.product?.image ?? '');
    _categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: widget.product?.id,
        title: _titleController.text,
        price: double.parse(_priceController.text.replaceAll(',', '.')),
        description: _descriptionController.text,
        image: _imageController.text,
        category: _categoryController.text,
      );

      final viewModel = context.read<ProductViewModel>();

      if (widget.product == null) {
        await viewModel.addProduct(newProduct);
      } else {
        await viewModel.updateProduct(newProduct);
        if (mounted) {
          Navigator.pop(context); // Fecha a tela de detalhes se for edição
        }
      }

      if (mounted) Navigator.pop(context); // Fecha o formulário
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Preço'),
                // Força o teclado a mostrar a opção de decimais (vírgula/ponto)
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o preço';
                  // Substitui a vírgula por ponto na hora de validar
                  final valorFormatado = value.replaceAll(',', '.');
                  if (double.tryParse(valorFormatado) == null) {
                    return 'Valor numérico inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a descrição'
                    : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a categoria'
                    : null,
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a URL' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
