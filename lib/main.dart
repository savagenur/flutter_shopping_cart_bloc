import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shopping_cart_bloc/app.dart';
import 'package:flutter_shopping_cart_bloc/shopping_repository.dart';
import 'package:flutter_shopping_cart_bloc/simple_bloc_observer.dart';
void main() {
  // Bloc.observer = SimpleBlocObserver();
  runApp(App(shoppingRepository: ShoppingRepository()));
}





