import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:proyecto1_tienda/models/article.dart';
import 'package:proyecto1_tienda/providers/user_provider.dart';


class NewItem extends StatefulWidget {
  final Function(Article) addArticle;

  const NewItem({Key? key, required this.addArticle}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  final Article _article = Article(name: '', price: 0.0, descripcion: '', imagenText: '');

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.addArticle(_article);

      try {
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        
        final response = await http.post(
          Uri.parse('http://192.168.0.18:6060/admin/saveproduct'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${userProvider.user?.token ?? ''}',
          },
          body: jsonEncode(_article.toJson()),
        );

        if (response.statusCode == 200) {
          print('Producto guardado exitosamente en el backend');
        } else {
          print('Error al guardar el producto en el backend: ${response.statusCode}');
          print('Cuerpo de la respuesta: ${response.body}');
        }
      } catch (e) {
        print('Error en la solicitud HTTP: $e');
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agrega un nuevo articulo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF17203A),
        bottomOpacity: 0.0,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Debe tener entre 1 y 50 caracteres.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _article.name = value!;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una descripción.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _article.descripcion = value!;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Precio',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un precio válido.';
                  }
                  try {
                    double.parse(value);
                  } catch (e) {
                    return 'Por favor, ingrese un número válido.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _article.price = double.parse(value!);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Imagen',
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  _article.imagenText = value!;
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Agregar Artículo'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}