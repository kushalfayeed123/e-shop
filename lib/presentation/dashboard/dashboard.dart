import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final formatedDate = DateFormat.yMMMEd().format(DateTime.now());
    final orderState = ref.watch(transactionStateProvider).value?.orders ?? [];
    final completedOrders =
        orderState.where((e) => (e.status ?? '').toLowerCase() == 'completed');
    final pendingOrders = orderState
        .where((e) => (e.status ?? '').toLowerCase() == 'in progress');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                formatedDate,
                style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Info Cards
          Row(
            children: [
              _buildInfoCard("Total Orders", orderState.length.toString(),
                  const Color(0xFF1E1E1E), const Color(0xFFB3B3B3)),
              _buildInfoCard(
                  "Completed Orders",
                  completedOrders.length.toString(),
                  const Color(0xFF1E1E1E),
                  const Color(0xFFB3B3B3)),
              _buildInfoCard("Pending", pendingOrders.length.toString(),
                  const Color(0xFF1E1E1E), const Color(0xFFB3B3B3)),
            ],
          ),
          const SizedBox(height: 20),
          // Order List and Payment sections
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildOrderList(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPopularDishesSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    final orders = ref.watch(transactionStateProvider).value?.orders ?? [];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "Today's Orders",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 30,
          ),
          OrderListView(orders: orders)
          // Add more widgets to build the order list
        ],
      ),
    );
  }

  Widget _buildPopularDishesSection() {
    final state = ref.watch(productStateProvider).value?.products;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "Popular Products",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 30,
          ),
          ProductsListView(products: state)
          // Add widgets for popular dishes
        ],
      ),
    );
  }
}

class OrderListView extends StatelessWidget {
  final List<TransactionModel> orders;

  const OrderListView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: ListTile(
                title: Row(
                  children: [
                    // 1. Initials Container
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (order.id ?? '').substring(0, 2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 2. Column with Order ID and Number of Items
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${order.id}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(order.items ?? []).length} items purchased',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // 3. Transaction Status
                    Text(
                      order.status ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: order.status == 'Completed'
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductsListView extends StatelessWidget {
  final List<Product>? products;

  const ProductsListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: (products ?? []).length,
        itemBuilder: (context, index) {
          final product = products![index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: ListTile(
                title: Row(
                  children: [
                    // 1. Initials Container
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (product.sku ?? '').substring(0, 2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 2. Column with Order ID and Number of Items
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Id: ${product.sku}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    // 3. Transaction Status
                    Text(
                      product.status ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: product.status == 'Active'
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Example Order class to represent each order
class Order {
  final String initials;
  final String id;
  final int items;
  final String status;

  Order({
    required this.initials,
    required this.id,
    required this.items,
    required this.status,
  });
}
