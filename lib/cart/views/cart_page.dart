import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: ColoredBox(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(32),
              child: CartList(),
            )),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            CartTotal(),
          ],
        ),
      ),
    );
  }
}

class CartList extends StatelessWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemNameStyle = Theme.of(context).textTheme.headline6;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const CircularProgressIndicator();
        }
        if (state is CartLoaded) {
          return ListView.separated(
            itemCount: state.cart.items.length,
            separatorBuilder: (_, __) {
              return const SizedBox(
                height: 4,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final item = state.cart.items[index];
              return Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                child: ListTile(
                  leading: const Icon(Icons.done),
                  title: Text(
                    item.name,
                    style: itemNameStyle,
                  ),
                  onLongPress: () {
                    context.read<CartBloc>().add(CartItemRemoved(item));
                  },
                ),
              );
            },
          );
        }
        return const Text("Something went wrong");
      },
    );
  }
}

class CartTotal extends StatelessWidget {
  const CartTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hugeStyle =
        Theme.of(context).textTheme.headline1?.copyWith(fontSize: 48);
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CartBloc, CartState>(builder: (context, state) {
              if (state is CartLoading) {
                return const CircularProgressIndicator();
              }
              if (state is CartLoaded) {
                return Text(
                  '\$${state.cart.totalPrice}',
                  style: hugeStyle,
                );
              }
              return Text("Something went wrong!");
            }),
            SizedBox(
              width: 24,
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Buying not supported yet.')),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
