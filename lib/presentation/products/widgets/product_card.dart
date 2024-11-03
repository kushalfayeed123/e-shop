import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/presentation/products/widgets/add_product_dialog.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    final oCcy = NumberFormat("#,##0.00", "en_US");

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
                child: Image.network(
                  product.image ?? '',
                  fit: BoxFit.cover,
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' ₦${oCcy.format(int.parse(product.sellingPrice ?? '0'))}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' ${product.quantityOnHand ?? 0} units',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addProductToCart(BuildContext context, WidgetRef ref) async {
    final currentCart = ref.read(transactionStateProvider).value?.cart;
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
