import 'package:eshop/core/domain/entities/cart.entity.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';
import 'package:eshop/presentation/shared/constants.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:eshop/state/providers/user/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  String _computeGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good morning! ";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon! ";
    } else if (hour >= 17 && hour < 21) {
      return "Good evening! ";
    } else {
      return "Good evening!";
    }
  }

  viewOrder(TransactionModel order) async {
    if (order.status == 'In progress') {
      final itemsInCart = order.items;
      for (CartProduct item in (itemsInCart ?? [])) {
        await ref
            .read(transactionStateProvider.notifier)
            .addProductToCart(item.item ?? Product(), item.quantity ?? '');
        await ref
            .read(transactionStateProvider.notifier)
            .getTransaction(order.id ?? '');
      }
      if (mounted) {
        context.push('/newOrder');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider).value?.currentUser;

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
          ResponsiveRowColumn(
            rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
            columnCrossAxisAlignment: CrossAxisAlignment.start,
            rowSpacing: 5,
            columnSpacing: 5,
            layout: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            children: [
              ResponsiveRowColumnItem(
                child: Row(
                  children: [
                    Text(
                      _computeGreeting(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      (userState?.name ?? ''),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ResponsiveRowColumnItem(
                child: Text(
                  formatedDate,
                  style:
                      const TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
                ),
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
                  "Confirmed Orders",
                  completedOrders.length.toString(),
                  const Color(0xFF1E1E1E),
                  const Color(0xFFB3B3B3)),
              _buildInfoCard("Pending Orders", pendingOrders.length.toString(),
                  const Color(0xFF1E1E1E), const Color(0xFFB3B3B3)),
            ],
          ),
          const SizedBox(height: 20),
          // Order List and Payment sections
          Expanded(
            child: ResponsiveRowColumn(
              rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
              columnCrossAxisAlignment: CrossAxisAlignment.start,
              rowSpacing: 16,
              columnSpacing: 5,
              layout: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                  ? ResponsiveRowColumnType.ROW
                  : ResponsiveRowColumnType.COLUMN,
              children: [
                ResponsiveRowColumnItem(
                  child: Expanded(
                    child: _buildOrderList(),
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Expanded(
                    child: _buildPopularDishesSection(),
                  ),
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
        margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.all(8.0),
        height: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                    ? 16
                    : 14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                            ? 24
                            : 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    final orders = ref.watch(transactionStateProvider).value?.orders ?? [];
    final todayOrders = orders
        .where((e) =>
            DateTime.parse(e.transactionDate ?? '').day == DateTime.now().day)
        .toList();
    orders.sort((a, b) => DateTime.parse(b.transactionDate ?? '')
        .compareTo(DateTime.parse(a.transactionDate ?? '')));
    return Container(
      padding: const EdgeInsets.all(8),
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
          OrderListView(orders: todayOrders)
          // Add more widgets to build the order list
        ],
      ),
    );
  }

  Widget _buildPopularDishesSection() {
    final state = ref.watch(productStateProvider).value?.products;
    return Container(
      padding: const EdgeInsets.all(8),
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
          SizedBox(
            height:
                ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 30 : 10,
          ),
          ProductsListView(products: state)
          // Add widgets for popular dishes
        ],
      ),
    );
  }
}

class OrderListView extends ConsumerWidget {
  final List<TransactionModel> orders;

  const OrderListView({super.key, required this.orders});

  Future _handleRefresh(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(productStateProvider.notifier).getProducts();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to refresh: $e'),
        ));
      }
    }
  }

  viewOrder(TransactionModel order, WidgetRef ref, BuildContext context) async {
    if (order.status == 'In progress') {
      final itemsInCart = order.items;
      for (CartProduct item in (itemsInCart ?? [])) {
        await ref
            .read(transactionStateProvider.notifier)
            .addProductToCart(item.item ?? Product(), item.quantity ?? '');
        await ref
            .read(transactionStateProvider.notifier)
            .getTransaction(order.id ?? '');
      }
      if (context.mounted) {
        context.push('/newOrder');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref, context),
        child: ListView.builder(
          itemCount: orders.length,
          padding: const EdgeInsets.all(3),
          itemBuilder: (context, index) {
            final order = orders[index];
            return InkWell(
              onTap: () => viewOrder(order, ref, context),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(order.items ?? []).length} items purchased',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₦${oCcy.format(double.parse(order.totalAmount ?? ''))}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),

                      // 3. Transaction Status
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.MMMEd().format(DateTime.parse(
                                    order.transactionDate ?? '')),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 12),
                              ),
                              Text(
                                ',',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                DateFormat.jmv().format(DateTime.parse(
                                    order.transactionDate ?? '')),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductsListView extends ConsumerWidget {
  final List<Product>? products;

  const ProductsListView({super.key, required this.products});

  Future _handleRefresh(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(productStateProvider.notifier).getProducts();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to refresh: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref, context),
        child: ListView.builder(
          itemCount: (products ?? []).length,
          itemBuilder: (context, index) {
            final product = products![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
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
                          (product.name ?? '').substring(0, 2),
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
                              ' ${product.name}',
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
