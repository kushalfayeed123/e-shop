import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop/core/domain/abstractions/product.abstraction.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ProductService implements IProductService {
  final CollectionReference<Map<String, dynamic>>
      _productDataCollectionReference =
      FirebaseFirestore.instance.collection("products");
  final storageReference = FirebaseStorage.instance.ref();

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

  @override
  Future<String> uploadProductImage(Uint8List imageData, String path) async {
    try {
      bool hasConnection = await InternetConnection().hasInternetAccess;
      if (hasConnection) {
        final mountainImagesRef = storageReference.child("images/$path.png");
        await mountainImagesRef.putData(imageData);
        final downloadUrl = await mountainImagesRef.getDownloadURL();
        return downloadUrl;
      } else {
        throw const HttpException(
            'You do not have a stable internet connection.');
      }
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
