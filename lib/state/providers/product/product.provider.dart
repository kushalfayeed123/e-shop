import 'package:eshop/core/domain/abstractions/product.abstraction.dart';
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
    final currentState = state.asData?.value;
    final res = await _productService.getProducts();
    final newStateSlice = ProductStateModel(
      products: res,
      currentProduct: currentState?.currentProduct,
    );
    setState(newStateSlice);
  }

  Future<void> getProduct(String id) async {
    final currentState = state.asData?.value;
    final res = await _productService.getProduct(id);
    final newStateSlice = ProductStateModel(
      products: currentState?.products,
      currentProduct: res,
    );
    setState(newStateSlice);
  }
}
