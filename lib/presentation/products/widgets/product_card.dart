import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: product.images != null && product.images!.isNotEmpty
                ? Image.network(product.images!.first, fit: BoxFit.cover)
                : Container(color: Colors.grey[300]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'Unnamed Product',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'SKU: ${product.sku ?? 'N/A'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'On Hand: ${product.quantityOnHand ?? 0}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
