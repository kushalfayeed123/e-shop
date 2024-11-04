import 'package:eshop/core/domain/abstractions/product.abstraction.dart';
import 'package:eshop/core/domain/abstractions/transaction.abstraction.dart';
import 'package:eshop/core/domain/entities/cart.entity.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';
import 'package:eshop/locator.dart';
import 'package:eshop/state/models/transaction.state.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'transaction.provider.g.dart';

@riverpod
class TransactionState extends _$TransactionState {
  final ITransactionService _transactionService =
      locator<ITransactionService>();
  final IProductService _productService = locator<IProductService>();

  @override
  AsyncValue<TransactionStateModel> build() {
    final defaultState = AsyncValue.data(TransactionStateModel());
    return defaultState;
  }

  setState(TransactionStateModel stateSlice) {
    state = const AsyncValue.loading();
    state = AsyncValue.data(stateSlice);
  }

  Future<void> createTransaction(TransactionModel payload) async {
    try {
      final currentState = state.asData?.value;
      await _transactionService.createTransaction(payload);
      if ((payload.status ?? '').toLowerCase() == 'completed') {
        for (CartProduct product in (payload.items ?? [])) {
          final productQuantity = (currentState?.cart ?? []).firstWhere(
            (e) => e.item == product,
            orElse: () => CartProduct(),
          );

          product.item?.quantityOnHand =
              (int.parse(product.item?.quantityOnHand ?? '0') -
                      int.parse(productQuantity.quantity ?? '0'))
                  .toString();
          product.item?.quantityReserved =
              (int.parse(product.item?.quantityReserved ?? '0') -
                      int.parse(productQuantity.quantity ?? '0'))
                  .toString();
          await _productService.updateProduct(product.item ?? Product());
        }
      }
      final newState = TransactionStateModel(
          orders: currentState?.orders,
          currentOrder: currentState?.currentOrder,
          cart: []);
      setState(newState);
      await getTransactions();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getTransactions() async {
    try {
      final currentState = state.asData?.value;
      final res = await _transactionService.getTransactions();
      final updatedStateSlice = TransactionStateModel(
        orders: res,
        currentOrder: currentState?.currentOrder,
        cart: currentState?.cart,
      );
      setState(updatedStateSlice);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getTransaction(String transactionId) async {
    try {
      final currentState = state.asData?.value;
      final res = await _transactionService.getTransaction(transactionId);
      final updatedStateSlice = TransactionStateModel(
        orders: currentState?.orders,
        currentOrder: res,
        cart: currentState?.cart,
      );
      setState(updatedStateSlice);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTransaction(TransactionModel payload) async {
    try {
      await _transactionService.updateTransaction(payload);
      await getTransactions();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProductToCart(Product product, String quantity) async {
    final cartProduct = CartProduct(item: product, quantity: quantity);
    final currentState = state.asData?.value;
    List<CartProduct> payload = currentState?.cart ?? [];
    if ((payload.map((e) => e.item)).contains(product)) {
      return;
    } else {
      payload = [...payload, cartProduct];
      final updatedStateSlice = TransactionStateModel(
        orders: currentState?.orders,
        currentOrder: currentState?.currentOrder,
        cart: payload,
      );
      setState(updatedStateSlice);
      updateCart(product, quantity);
    }
  }

  Future<void> updateCart(Product product, String quantity) async {
    final currentState = state.asData?.value;
    List<CartProduct> payload = currentState?.cart ?? [];
    final newProduct = payload.firstWhere(
      (e) => e.item?.sku == product.sku,
      orElse: () => CartProduct(),
    );
    // payload.removeWhere((e) => e.item == newProduct.item);
    newProduct.quantity = quantity;
    newProduct.totalPrice = (int.parse(newProduct.item?.sellingPrice ?? '0') *
            int.parse(newProduct.quantity ?? '0'))
        .toString();
    payload = [...payload, newProduct];
    payload = payload.toSet().toList();

    final updatedStateSlice = TransactionStateModel(
      orders: currentState?.orders,
      currentOrder: currentState?.currentOrder,
      cart: payload,
    );
    setState(updatedStateSlice);
  }

  Future<void> removeItemFromCart(Product product) async {
    final currentState = state.asData?.value;
    List<CartProduct> payload = currentState?.cart ?? [];

    payload.removeWhere((e) => e.item == product);

    final updatedStateSlice = TransactionStateModel(
      orders: currentState?.orders,
      currentOrder: currentState?.currentOrder,
      cart: payload,
    );
    setState(updatedStateSlice);
  }
}
