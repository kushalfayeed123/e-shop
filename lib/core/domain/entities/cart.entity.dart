import 'package:eshop/core/domain/entities/product.entity.dart';

class CartProduct {
  Product? item;
  String? quantity;
  String? totalPrice;
  CartProduct({this.item, this.quantity, this.totalPrice});

  CartProduct.fromJson(Map<String, dynamic> json) {
    item = Product.fromJson(json['item']);
    quantity = json['quantity'];
    totalPrice = json[totalPrice];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item'] = item?.toJson();
    data['quantity'] = quantity;
    data['totalPrice'] = totalPrice;
    return data;
  }
}
