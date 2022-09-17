import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_shopping_cart_bloc/cart/models/cart.dart';
import 'package:flutter_shopping_cart_bloc/catalog/models/item.dart';
import 'package:flutter_shopping_cart_bloc/shopping_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ShoppingRepository shoppingRepository;

  CartBloc({
    required this.shoppingRepository,
  }) : super(CartLoading()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await shoppingRepository.loadCartItems();
      emit(CartLoaded(cart: Cart(items: [...items])));
    } catch (e) {
      emit(CartError());
    }
  }

  Future<void> _onItemAdded(
      CartItemAdded event, Emitter<CartState> emit) async {
    final state = this.state;
    if (state is CartLoaded) {
      try {
        shoppingRepository.addItemToCart(event.item);
        emit(
          CartLoaded(
            cart: Cart(
              items: [...state.cart.items, event.item],
            ),
          ),
        );
      } catch (e) {
        emit(CartError());
      }
    }
  }

  Future<void> _onItemRemoved(
      CartItemRemoved event, Emitter<CartState> emit) async {
    final state = this.state;
    if (state is CartLoaded) {
      try {
        shoppingRepository.removeItemFromCart(event.item);
        emit(
          CartLoaded(
            cart: Cart(
              items: [...state.cart.items]..remove(event.item),
            ),
          ),
        );
      } catch (e) {
        emit(CartError());
      }
    }
  }
}
