import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final Color backgroundColor;
  final int itemCount;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.backgroundColor,
    this.itemCount = 0,
  });
}
