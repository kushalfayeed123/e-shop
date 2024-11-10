import 'dart:typed_data';

import 'package:eshop/core/domain/entities/product.entity.dart';

abstract class IProductService {
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<Product> getProduct(String productId);
  Future<List<Product>> getProducts();
  Future<void> deleteProduct(String productId);
  Future<String> uploadProductImage(Uint8List imageData, String path);
}
