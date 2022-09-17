import 'package:equatable/equatable.dart';
import 'package:flutter_shopping_cart_bloc/catalog/models/item.dart';

class Catalog extends Equatable {
  final List<String> itemNames;
  const Catalog({required this.itemNames});
  Item getById(int id) => Item(id, itemNames[id % itemNames.length]);
  Item getByPosition(int position) => getById(position);

  @override
  List<Object?> get props => [itemNames];
}
