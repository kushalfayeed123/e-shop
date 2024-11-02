import 'package:eshop/core/domain/entities/product.entity.dart';

class ProductStateModel {
  Product? currentProduct;
  List<Product>? products;
  ProductStateModel({this.currentProduct, this.products});
}
