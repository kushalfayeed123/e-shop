import 'dart:io';
import 'dart:typed_data';

import 'package:eshop/core/domain/abstractions/product.abstraction.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/locator.dart';
import 'package:eshop/state/models/product.state.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'product.provider.g.dart';

@riverpod
class ProductState extends _$ProductState {
  final IProductService _productService = locator<IProductService>();

  @override
  AsyncValue<ProductStateModel> build() {
    final defaultState = AsyncValue.data(ProductStateModel());
    return defaultState;
  }

  setState(ProductStateModel stateSlice) {
    state = const AsyncValue.loading();
    state = AsyncValue.data(stateSlice);
  }

  Future<void> getProducts() async {
    try {
      final currentState = state.asData?.value;
      final res = await _productService.getProducts();
      final newStateSlice = ProductStateModel(
        products: res,
        currentProduct: currentState?.currentProduct,
      );
      setState(newStateSlice);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getProduct(String id) async {
    try {
      final currentState = state.asData?.value;
      final res = await _productService.getProduct(id);
      final newStateSlice = ProductStateModel(
        products: currentState?.products,
        currentProduct: res,
      );
      setState(newStateSlice);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createProduct(Product payload) async {
    try {
      final products = state.asData?.value.products;
      if ((products ?? [])
          .any((e) => e.name == payload.name && e.sku == payload.sku)) {
        throw const HttpException('Product already exists');
      } else {
        await _productService.createProduct(payload);
        await getProducts();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product payload) async {
    try {
      await _productService.updateProduct(payload);
      await getProducts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _productService.deleteProduct(id);
      await getProducts();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadProductImage(Uint8List imageData, String path) async {
    try {
      return await _productService.uploadProductImage(imageData, path);
    } catch (e) {
      rethrow;
    }
  }
}
