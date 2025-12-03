import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:list_purchase_app/models/category.dart';

class Items {
  final String id;
  final String name;
  final int quantity;
  final Category category;

 const Items({required this.id, required this.name, required this.quantity, required this.category});
}

