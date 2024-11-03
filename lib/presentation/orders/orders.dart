import 'package:eshop/core/domain/entities/transaction.entity.dart';
import 'package:eshop/presentation/shared/app_button.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
  }

  String getFormattedDate(String date) {
    final formatedDate = DateFormat.yMMMEd().format(DateTime.parse(date));
    return formatedDate;
  }

  String getFormattedTime(String date) {
    final formatedDate = DateFormat.jm().format(DateTime.parse(date));
    return formatedDate;
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(transactionStateProvider).value;
    final orders = orderState?.orders;
    final screenWidth = MediaQuery.of(context).size.width;
    final formatedDate = DateFormat.yMMMEd().format(DateTime.now());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Orders",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  formatedDate,
                  style:
                      const TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Order Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth * 0.3,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodySmall,
                    onChanged: (value) => {},
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search_rounded),
                      labelText: 'Search Orders',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary)),
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
                  action: () => context.push('/newOrder'),
                  textColor: Colors.black,
                  text: 'New Order',
                  hasBorder: false,
                  elevation: 5,
                )
              ],
            ),
            const SizedBox(height: 20),
            // Order Cards
            Expanded(
                child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: (orders ?? []).length,
              itemBuilder: (context, index) {
                // final order = searchedProducts.isEmpty
                //     ? allProducts[index]
                //     : searchedProducts[index];
                final order = (orders ?? [])[index];
                return _buildOrderCard(order);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(TransactionModel order) {
    final oCcy = NumberFormat("#,##0.00", "en_US");

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 120,
                child: Text('${order.id}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: (order.status ?? '').toLowerCase() == 'completed'
                        ? Colors.greenAccent.withOpacity(0.7)
                        : Theme.of(context).colorScheme.primary),
                child: Center(
                    child: Text(
                  order.status ?? '',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: (order.status ?? '').toLowerCase() == 'completed'
                          ? Colors.white
                          : Colors.black,
                      fontSize: 12),
                )),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getFormattedDate(order.transactionDate ?? ''),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 12)),
              Text(getFormattedTime(order.transactionDate ?? ''),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Divider(
            indent: 5,
            endIndent: 5,
            color: Theme.of(context).colorScheme.primary,
            thickness: 0.3,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.19,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          'items',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 10, color: Colors.white24),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Qty',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 10, color: Colors.white24),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Price',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 10, color: Colors.white24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ...(order.items ?? []).map(
                    (e) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                e.name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: Text(
                                '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: Text(
                                '₦${oCcy.format(int.parse(e.sellingPrice ?? '0'))}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(
            indent: 5,
            endIndent: 5,
            color: Theme.of(context).colorScheme.primary,
            thickness: 0.3,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12,
                    ),
              ),
              Text(
                '₦${oCcy.format(order.totalAmount)}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
