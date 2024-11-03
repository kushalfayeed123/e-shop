import 'package:eshop/core/domain/entities/product.entity.dart';

class CartProduct {
  Product? item;
  String? quantity;
  int? totalPrice;
  CartProduct({this.item, this.quantity, this.totalPrice});
}
