import 'package:flutter/material.dart';
import 'package:list_purchase_app/widgets/list_purchase.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.red,
      ),
      title: 'Material App',
      home: const ListPurchase(),
    );
  }
}
