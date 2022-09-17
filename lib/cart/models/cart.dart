import 'package:equatable/equatable.dart';

import 'package:flutter_shopping_cart_bloc/catalog/models/item.dart';

class Cart extends Equatable {
  final List<Item> items;
  const Cart({
    this.items = const <Item>[],
  });

  int get totalPrice {
    return items.fold(0, (total, current) => total + current.price);
  }
  
  @override
  List<Object?> get props => [items];
}
