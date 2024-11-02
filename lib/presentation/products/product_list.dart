import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/presentation/products/widgets/add_product_dialog.dart';
import 'package:eshop/presentation/shared/app_button.dart';
import 'package:eshop/presentation/products/widgets/product_card.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductList extends ConsumerStatefulWidget {
  const ProductList({super.key});

  @override
  ConsumerState<ProductList> createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<ProductList> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productStateProvider).value;
    final products = state?.products ?? [];
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Orders",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [],
              )
            ],
          ),
          const SizedBox(height: 20),
          products.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No Products yet.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    AppButton(
                        isActive: true,
                        background: Theme.of(context).colorScheme.primary,
                        action: () {},
                        textColor: Theme.of(context).colorScheme.tertiary,
                        text: 'Add Product',
                        hasBorder: true,
                        elevation: 10)
                  ],
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                ),
        ],
      ),
    );
  }

  Future openAddProductPage() {
    return showDialog(
      context: context,
      builder: (context) => AddProductDialog(onAddProduct: onAddProduct),
    );
  }

  Future<void> onAddProduct(Product payload) async {}
}
