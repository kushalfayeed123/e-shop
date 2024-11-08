import 'package:eshop/core/domain/abstractions/product.abstraction.dart';
import 'package:eshop/core/domain/abstractions/transaction.abstraction.dart';
import 'package:eshop/core/domain/entities/cart.entity.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';
import 'package:eshop/locator.dart';
import 'package:eshop/state/models/transaction.state.model.dart';
import 'package:eshop/state/providers/user/user.provider.dart';
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
      final allUsers = await ref.read(userStateProvider.notifier).returnUsers();
      final allAdminUsers =
          allUsers.where((e) => (e.role ?? '').toLowerCase() == 'admin');

      final tokens = allAdminUsers.map((e) => e.device?.token ?? '').toList();
      await _transactionService.createTransaction(payload, tokens);
      if ((payload.status ?? '').toLowerCase() == 'completed') {
        for (CartProduct product in (payload.items ?? [])) {
          final productQuantity = (currentState?.cart ?? []).firstWhere(
            (e) => e.item == product.item,
            orElse: () => CartProduct(),
          );

          product.item?.quantityOnHand =
              (double.parse(product.item?.quantityOnHand ?? '0') -
                      double.parse(productQuantity.quantity ?? '0'))
                  .toString();
          product.item?.quantityReserved =
              (double.parse(product.item?.quantityReserved ?? '0') -
                      double.parse(productQuantity.quantity ?? '0'))
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

  void clearOrderState() {
    final currentState = state.asData?.value;

    final newState = TransactionStateModel(
        orders: currentState?.orders,
        currentOrder: currentState?.currentOrder,
        cart: []);
    setState(newState);
  }

  void clearCurrentOrder() {
    final currentState = state.asData?.value;

    final newState = TransactionStateModel(
        orders: currentState?.orders, currentOrder: null, cart: []);
    setState(newState);
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
    try {
      final currentState = state.asData?.value;
      List<CartProduct> payload = currentState?.cart ?? [];
      payload = payload.toSet().toList();

      if ((payload.map((e) => e.item)).contains(product)) {
        return;
      } else {
        // await setState(updatedStateSlice);
        await updateCart(product, quantity, true);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCart(
      Product product, String quantity, bool isCreate) async {
    try {
      final currentState = state.asData?.value;
      List<CartProduct> payload = currentState?.cart ?? [];
      if (isCreate) {
        final cartProduct = CartProduct(item: product, quantity: quantity);
        payload = [...payload, cartProduct];
      }
      final newProduct = payload.firstWhere(
        (e) => e.item?.sku == product.sku,
        orElse: () => CartProduct(),
      );
      newProduct.quantity = quantity;
      newProduct.totalPrice =
          (double.parse(newProduct.item?.sellingPrice ?? '0') *
                  double.parse(newProduct.quantity ?? '0'))
              .toString();
      payload = [...payload, newProduct];
      payload = payload.toSet().toList();

      final updatedStateSlice = TransactionStateModel(
        orders: currentState?.orders,
        currentOrder: currentState?.currentOrder,
        cart: payload,
      );
      setState(updatedStateSlice);
    } catch (e) {
      rethrow;
    }
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
