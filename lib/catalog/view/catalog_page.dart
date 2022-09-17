import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shopping_cart_bloc/cart/bloc/cart_bloc.dart';
import 'package:flutter_shopping_cart_bloc/cart/models/cart.dart';
import 'package:flutter_shopping_cart_bloc/catalog/bloc/catalog_bloc.dart';

import '../models/item.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const CatalogAppBar(),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 12,
            ),
          ),
          BlocBuilder<CatalogBloc, CatalogState>(builder: (context, state) {
            if (state is CatalogLoading) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is CatalogLoaded) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => CatalogListItem(
                        item: state.catalog.getByPosition(index)),
                    childCount: state.catalog.itemNames.length),
              );
            }
            return const SliverFillRemaining(
                child: Text("Something went wrong!"));
          })
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final Item item;
  const AddButton({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CartLoaded) {
          final isInCart = state.cart.items.contains(item);
          return TextButton(
            onPressed: isInCart
                ? null
                : () => context.read<CartBloc>().add(CartItemAdded(item)),
            child: isInCart
                ? const Icon(
                    Icons.check,
                    semanticLabel: 'ADDED',
                  )
                : const Text('ADD'),
          );
        }
        return const Text("Something went wrong!");
      },
    );
  }
}

class CatalogAppBar extends StatelessWidget {
  const CatalogAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(title: const Text('Catalog'), floating: true, actions: [
      IconButton(
          onPressed: () => Navigator.of(context).pushNamed('/cart'),
          icon: Stack(
            children: [
              Positioned.fill(child: const Icon(Icons.shopping_cart)),
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: BlocBuilder<CartBloc, CartState>(
                      builder: ((context, state) {
                    if (state is CartLoaded) {
                      if (state.cart.items.length == 0) {
                        return Container();
                      } else {
                      return  CircleAvatar(
                          radius: 8,
                          child: Text(
                            state.cart.items.length.toString(),
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      }
                    }
                    return Text('.');
                  })))
            ],
          ))
    ]);
  }
}

class CatalogListItem extends StatelessWidget {
  final Item item;
  const CatalogListItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.headline6;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ColoredBox(color: item.color),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
                child: Text(
              item.name,
              style: textTheme,
            )),
            const SizedBox(
              width: 24,
            ),
            AddButton(item: item),
          ],
        ),
      ),
    );
  }
}
