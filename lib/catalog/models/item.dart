import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Item extends Equatable {
  final int id;
  final String name;
  final Color color;
  final int price = 42;

  Item(
    this.id,
    this.name,
  ) : color = Colors.primaries[id % Colors.primaries.length];

  @override
  List<Object?> get props => [id, name, price, color];
}
