import 'package:eshop/core/domain/entities/cart.entity.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';

class TransactionStateModel {
  List<TransactionModel>? orders;
  TransactionModel? currentOrder;
  List<CartProduct>? cart;

  TransactionStateModel({
    this.orders,
    this.currentOrder,
    this.cart,
  });
}
