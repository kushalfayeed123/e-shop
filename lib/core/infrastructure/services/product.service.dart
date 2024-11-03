import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop/core/domain/abstractions/product.abstraction.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';

class ProductService implements IProductService {
  final CollectionReference<Map<String, dynamic>>
      _productDataCollectionReference =
      FirebaseFirestore.instance.collection("products");
  @override
  Future<void> createProduct(Product product) async {
    try {
      await _productDataCollectionReference
          .doc(product.sku)
          .set(product.toJson());
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await _productDataCollectionReference
          .doc(productId)
          .update({'status': 'Deleted'});
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<Product> getProduct(String productId) async {
    try {
      final snapshot =
          await _productDataCollectionReference.doc(productId).get();
      return snapshot.exists
          ? Product.fromJson(snapshot.data()!)
          : throw const HttpException('Product not found');
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final snapshots = await _productDataCollectionReference
          .where('status', isEqualTo: 'Active')
          .get();
      return snapshots.docs.map((e) => Product.fromJson(e.data())).toList();
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      await _productDataCollectionReference
          .doc(product.sku)
          .update(product.toJson());
    } on FirebaseException catch (e) {
      final message = e.message ?? '';

      throw HttpException(message);
    } catch (e) {
      final message = e.toString();

      throw HttpException(message);
    }
  }
}
