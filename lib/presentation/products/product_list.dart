import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/presentation/products/widgets/add_product_dialog.dart';
import 'package:eshop/presentation/shared/widgets/app_button.dart';
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
  List<Product> allProducts = [];
  List<Product> searchedProducts = [];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final state = ref.watch(productStateProvider).value;
    allProducts = state?.products ?? [];
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
      width: screenWidth,
      child: Column(
        children: [
          allProducts.isEmpty
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenWidth * 0.3,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodySmall,
                        onChanged: (value) => searchProduct(value),
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.search_rounded),
                          labelText: 'Search Products',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    AppButton(
                      isActive: true,
                      background: Theme.of(context).colorScheme.primary,
                      action: () => openAddProductPage(),
                      textColor: Colors.black,
                      text: 'Add Product',
                      hasBorder: false,
                      elevation: 5,
                    )
                  ],
                ),
          const SizedBox(height: 20),
          allProducts.isEmpty
              ? SizedBox(
                  height: screenHeight * 0.8,
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Products yet.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 28),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppButton(
                          isActive: true,
                          background: Theme.of(context).colorScheme.primary,
                          action: () => openAddProductPage(),
                          textColor: Theme.of(context).colorScheme.secondary,
                          text: 'Add Product',
                          hasBorder: true,
                          elevation: 10)
                    ],
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: searchedProducts.isEmpty
                        ? allProducts.length
                        : searchedProducts.length,
                    itemBuilder: (context, index) {
                      final product = searchedProducts.isEmpty
                          ? allProducts[index]
                          : searchedProducts[index];
                      return ProductCard(
                        product: product,
                        createOrder: false,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Future openAddProductPage() {
    return showDialog(
      context: context,
      builder: (context) => const AddProductDialog(
        isEdit: false,
      ),
    );
  }

  void searchProduct(String param) {
    if (param.isEmpty) {
      searchedProducts = allProducts;
    } else {
      searchedProducts = allProducts
          .where((e) =>
              (e.name ?? '').toLowerCase().contains(param.toLowerCase()) ||
              (e.sku ?? '').toLowerCase().contains(param.toLowerCase()) ||
              (e.description ?? '')
                  .toLowerCase()
                  .contains(param.toLowerCase()) ||
              (e.category ?? '').toLowerCase().contains(param.toLowerCase()))
          .toList();
    }

    setState(() {});
  }
}
