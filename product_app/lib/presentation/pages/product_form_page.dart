import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product_model.dart';
import '../viewmodels/productviewmodel.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _thumbnailController; // Corrigido
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
    // Corrigido
    _thumbnailController = TextEditingController(
      text: widget.product?.thumbnail ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose(); // Corrigido
    _categoryController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id:
            widget.product?.id ??
            0, // Adicionado fallback para 0 caso seja nulo (novo)
        title: _titleController.text,
        price: double.parse(_priceController.text.replaceAll(',', '.')),
        description: _descriptionController.text,
        thumbnail: _thumbnailController.text, // Corrigido
        category: _categoryController.text,
        rating: widget.product?.rating ?? 0.0, // Adicionado campo obrigatório
        stock: widget.product?.stock ?? 0, // Adicionado campo obrigatório
      );

      final viewModel = context.read<ProductViewModel>();

      if (widget.product == null) {
        await viewModel.addProduct(newProduct);
      } else {
        await viewModel.updateProduct(newProduct);
        if (mounted) {
          Navigator.pop(context);
        }
      }

      if (mounted) Navigator.pop(context);
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o preço';
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
                controller: _thumbnailController, // Corrigido
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
