// ignore_for_file: use_build_context_synchronously

import 'package:eshop/core/domain/entities/cart.entity.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';
import 'package:eshop/presentation/products/widgets/product_card.dart';
import 'package:eshop/presentation/shared/app_button.dart';
import 'package:eshop/presentation/shared/app_dialog.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateOrder extends ConsumerStatefulWidget {
  const CreateOrder({super.key});

  @override
  ConsumerState<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends ConsumerState<CreateOrder> {
  List<Product> allProducts = [];
  List<Product> searchedProducts = [];
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final state = ref.watch(productStateProvider).value;
    final cartState = ref.watch(transactionStateProvider).value?.cart;
    allProducts = state?.products ?? [];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => context.pop(),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 25,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "New Order",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Text(
                        "Wednesday, 12 July 2023",
                        style:
                            TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
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
                            labelText: 'Enter product name or product Id',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
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
                        action: () => openScanner(),
                        textColor: Colors.black,
                        text: 'Scan barcode',
                        hasBorder: false,
                        elevation: 5,
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
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
                          createOrder: true,
                        );
                      },
                    ),
                  )
                ],
              ),
            )),
            Container(
              width: screenWidth * 0.2,
              height: screenHeight,
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: (cartState ?? []).isEmpty
                            ? [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Center(
                                    child: Text(
                                      'Selected Products will show up here',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]
                            : (cartState ?? [])
                                .map((e) => _cartItem(e.item))
                                .toList(),
                      ))),
                  (cartState ?? []).isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  computeTotal(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => createOrder(true),
                                  child: Container(
                                    height: 45,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => createOrder(false),
                                  child: Container(
                                    height: 45,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        border: Border.all()),
                                    child: Center(
                                      child: Text(
                                        'Confirm',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                // AppButton(
                                //   isActive: true,
                                //   background: Colors.transparent,
                                //   action: () {},
                                //   textColor:
                                //       Theme.of(context).colorScheme.primary,
                                //   text: 'Cancel',
                                //   hasBorder: true,
                                //   elevation: 5,
                                //   isFullWidth: false,
                                // ),
                                // AppButton(
                                //   isActive: true,
                                //   background:
                                //       Theme.of(context).colorScheme.primary,
                                //   action: () {},
                                //   textColor: Colors.black,
                                //   text: 'Confirm',
                                //   hasBorder: false,
                                //   elevation: 5,
                                //   isFullWidth: false,
                                // ),
                              ],
                            )
                          ],
                        )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  String computeTotal() {
    final cartItems = ref.watch(transactionStateProvider).value?.cart;
    final sum = ((cartItems ?? []).map((e) => e.totalPrice))
        .reduce((a, b) => (a ?? 0) + (b ?? 0));

    return sum.toString();
  }

  void openScanner() {}

  Widget _cartItem(Product? item) {
    String quantity = (ref.watch(transactionStateProvider).value?.cart ?? [])
            .firstWhere((e) => e.item == item, orElse: () => CartProduct())
            .quantity ??
        '';
    int count = int.parse(quantity);
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item?.name ?? ''),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        if (count == 1) {
                          ref
                              .read(transactionStateProvider.notifier)
                              .removeItemFromCart(item ?? Product());
                        } else {
                          ref
                              .read(transactionStateProvider.notifier)
                              .updateCart(
                                  item ?? Product(), (count - 1).toString());
                        }
                      },
                      child: const Text('-')),
                  Text(count.toString()),
                  InkWell(
                      onTap: () {
                        ref.read(transactionStateProvider.notifier).updateCart(
                            item ?? Product(), (count + 1).toString());
                      },
                      child: const Text('+'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void createOrder(bool isCancel) async {
    try {
      AppDialog.showLoading(context);
      final transactionState = ref.watch(transactionStateProvider).value;
      final payload = TransactionModel(
          userId: FirebaseAuth.instance.currentUser?.uid,
          transactionType: 'Purchase',
          items: (transactionState?.cart ?? [])
              .map((e) => e.item ?? Product())
              .toList(),
          totalAmount: double.parse(computeTotal()),
          transactionDate: DateTime.now().toString(),
          status: isCancel ? 'In progress' : 'Completed');
      await ref
          .read(transactionStateProvider.notifier)
          .createTransaction(payload);
      AppDialog.hideLoading(context);
      AppDialog.showSuccessDialog(
          context, 'Order has been registered successfully', action: () {
        context.pop();
        context.pop();
      });
    } catch (e) {
      AppDialog.hideLoading(context);
      AppDialog.showErrorDialog(context, e.toString());
    }
  }
}
