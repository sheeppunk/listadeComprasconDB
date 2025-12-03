import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:list_purchase_app/data/categories.dart';
import 'package:list_purchase_app/models/category.dart';
import 'package:list_purchase_app/models/items.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _nameCapture = '';
  int _quantifyCaptured = 1;
  var _categorySelect = categories[Categories.electronica];
  bool _beSending = false;

  void _savedItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _beSending = true;
      });

      final url = Uri.https(
        'flutter-apps-cc949-default-rtdb.firebaseio.com',
        'lista-hola.json',
      );
      final request = await http.post(
        url,
        headers: {'ContentType': 'aplication/json'},
        body: json.encode({
          'nombre': _nameCapture,
          'cantidad': _quantifyCaptured,
          'categoria': _categorySelect!.title,
        }),
      ); //post agrega
      //print(request.body);
      //print(request.statusCode);

      final Map<String, dynamic> resData = json.decode(request.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(
        Items(
          // id: DateTime.now().toString(),
          id: resData['name'],
          name: _nameCapture,
          quantity: _quantifyCaptured,
          category: _categorySelect!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                validator: (valor) {
                  if (valor == null ||
                      valor.isEmpty ||
                      valor.trim().length <= 2 ||
                      valor.trim().length >= 50) {
                    return 'Mas letras porfa';
                  }
                  return null;
                },
                onSaved: (valor) {
                  //if (valor ==null){
                  //return;
                  //}
                  //}
                  _nameCapture = valor!;
                },
                decoration: InputDecoration(label: Text('Name')),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(label: Text('Quantify')),
                initialValue: _quantifyCaptured.toString(),
                validator: (valor) {
                  if (valor == null ||
                      valor.isEmpty ||
                      int.tryParse(valor) == null ||
                      int.tryParse(valor)! <= 0) {
                    return 'valor mayor a 0 porfa';
                  }
                  return null;
                },
                onSaved: (valor) {
                  _quantifyCaptured = int.parse(valor!);
                },
              ),
              DropdownButtonFormField(
                value: _categorySelect,
                items: [
                  for (final mycategory in categories.entries)
                    DropdownMenuItem(
                      value: mycategory.value,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: mycategory.value.color,
                          ),
                          SizedBox(width: 6),
                          Text(mycategory.value.title),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _categorySelect = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, //manda botones a la derecha
                children: [
                  TextButton(
                    onPressed: _beSending
                        ? null
                        : () {
                            _formKey.currentState!
                                .reset(); // se resean los datos
                          },
                    child: const Text('Limpiar datos'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _beSending ? null : _savedItem,
                    child: _beSending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Agregar Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(title: Text('Nuevo Item')),
    );
  }
}
