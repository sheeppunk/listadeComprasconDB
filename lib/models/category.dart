import 'package:flutter/material.dart';

enum Categories {
  videoJuegos,
  electronica,
  practicas,
  automovil,
  ropa,
  animales,
  hogar,
  others,
}

class Category {
  final String title;
  final Color color;

  const Category({required this.title, required this.color});
}
