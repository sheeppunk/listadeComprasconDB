import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:list_purchase_app/data/categories.dart';
//import 'package:list_purchase_app/data/list_items.dart';
import 'package:list_purchase_app/models/items.dart';
import 'package:list_purchase_app/widgets/new_item.dart';
import 'package:list_purchase_app/models/category.dart';
import 'package:http/http.dart' as http;

class ListPurchase extends StatefulWidget {
  const ListPurchase({super.key});

  @override
  State<ListPurchase> createState() => _ListPurchaseState();
}

class _ListPurchaseState extends State<ListPurchase> {
  List<Items> _listItems = [];
  bool _beLoadData = true;
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'flutter-apps-cc949-default-rtdb.firebaseio.com',
      'lista-hola.json',
    );

    try {
      final request = await http.get(url); //get obtiene
      if (request.body == 'null') {
        setState(() {
          _beLoadData = false;
        });
        return;
      }
      // print(request.body);
      final Map<String, dynamic> listData = json.decode(request.body);
      final List<Items> loadItems = [];

      for (final myItem in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.title == myItem.value['categoria'],
            )
            .value;

        loadItems.add(
          Items(
            id: myItem.key,
            name: myItem.value['nombre'],
            quantity: myItem.value['cantidad'],
            category: category,
          ),
        );
      }
      setState(() {
        _listItems = loadItems;
        _beLoadData = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<Items>(MaterialPageRoute(builder: (ctx) => const NewItem()));
    //_loadItems();

    if (newItem == null) {
      return;
    }
    setState(() {
      _listItems.add(newItem);
    });
  }

  void _deleteItem(Items item) async {
    final index = _listItems.indexOf(item);

    setState(() {
      _listItems.remove(item);
    });

    final url = Uri.https(
      'flutter-apps-cc949-default-rtdb.firebaseio.com',
      'lista-hola/${item.id}.json',
    );
    //http.delete(url); //borra desde la base de datos
    final request = await http.delete(url);
    if (request.statusCode >= 400) {
      setState(() {
        _listItems.insert(index, item);
      });
    }

    // ver 202 404 status error code

    //setState(() {
    //_listItems.remove(item);
    //});
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('Mmmhh hay que gastar dinero'));

    if (_beLoadData) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_listItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _listItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _deleteItem(_listItems[index]);
          },
          key: ValueKey(_listItems[index]),
          child: ListTile(
            title: Text(_listItems[index].name),
            trailing: Text(_listItems[index].quantity.toString()),
            leading: Container(
              width: 24,
              height: 24,
              color: _listItems[index].category.color,
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      content = const Center(child: Text('Chucha, no cargo nada'));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
        title: Text('Lista de Compras'),
      ),
      body: content,
    );
  }
}
