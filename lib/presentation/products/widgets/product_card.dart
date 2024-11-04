// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/presentation/products/widgets/add_product_dialog.dart';
import 'package:eshop/presentation/shared/constants.dart';
import 'package:eshop/presentation/shared/widgets/app_dialog.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerStatefulWidget {
  final Product product;
  final bool createOrder;

  const ProductCard({
    super.key,
    required this.product,
    required this.createOrder,
  });

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () =>
          widget.createOrder ? addProductToCartAction() : openEditProductPage(),
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
                  child: Image.file(
                File(widget.product.image ?? ''),
                fit: BoxFit.cover,
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
              )),
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
                            widget.product.name ?? '',
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
                            '₦${oCcy.format(double.parse(widget.product.sellingPrice ?? '0'))}',
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
                            '${widget.product.quantityOnHand ?? 0}',
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

  Future addProductToCartAction() async {
    try {
      await ref
          .read(transactionStateProvider.notifier)
          .addProductToCart(widget.product, '1');
    } catch (e) {
      AppDialog.showErrorDialog(context, e.toString());
    }
  }

  Future openEditProductPage() async {
    await ref
        .read(productStateProvider.notifier)
        .getProduct(widget.product.sku ?? '');
    return showDialog(
      context: context,
      builder: (context) => const AddProductDialog(
        isEdit: true,
      ),
    );
  }
}
