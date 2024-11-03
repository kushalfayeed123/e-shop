import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/presentation/products/widgets/add_product_dialog.dart';
import 'package:eshop/presentation/shared/constants.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final bool createOrder;

  const ProductCard({
    super.key,
    required this.product,
    required this.createOrder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => createOrder
          ? addProductToCart(context, ref)
          : openEditProductPage(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: product.image ?? '',
                  fit: BoxFit.cover,
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(
                          width: screenWidth * 0.1,
                          child: Text(
                            product.name ?? '',
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(
                          width: screenWidth * 0.1,
                          child: Text(
                            '₦${oCcy.format(int.parse(product.sellingPrice ?? '0'))}',
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(
                          width: screenWidth * 0.1,
                          child: Text(
                            '${product.quantityOnHand ?? 0}',
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addProductToCart(BuildContext context, WidgetRef ref) async {
    await ref
        .read(transactionStateProvider.notifier)
        .addProductToCart(product, '1');
  }

  Future openEditProductPage(BuildContext context, WidgetRef ref) async {
    await ref.read(productStateProvider.notifier).getProduct(product.sku ?? '');
    return showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => const AddProductDialog(
        isEdit: true,
      ),
    );
  }
}
