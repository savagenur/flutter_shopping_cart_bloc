import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shopping_cart_bloc/cart/views/cart_page.dart';
import 'package:flutter_shopping_cart_bloc/shopping_repository.dart';

import 'cart/bloc/cart_bloc.dart';
import 'catalog/bloc/catalog_bloc.dart';
import 'catalog/view/catalog_page.dart';

class App extends StatelessWidget {
  final ShoppingRepository shoppingRepository;
  const App({Key? key, required this.shoppingRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CatalogBloc(shoppingRepository: ShoppingRepository())
            ..add(
              CatalogStarted(),
            ),
        ),
        BlocProvider(
          create: (context) =>
              CartBloc(shoppingRepository: ShoppingRepository())
                ..add(
                  CartStarted(),
                ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Bloc Shopping Cart',
        initialRoute: '/',
        routes: {
          '/': (_) => const CatalogPage(),
          '/cart': (_) => const CartPage(),
        },
      ),
    );
  }
}
