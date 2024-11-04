// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:eshop/core/domain/entities/cart.entity.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';
import 'package:eshop/presentation/products/widgets/product_card.dart';
import 'package:eshop/presentation/shared/constants.dart';
import 'package:eshop/presentation/shared/widgets/app_button.dart';
import 'package:eshop/presentation/shared/widgets/app_dialog.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CreateOrder extends ConsumerStatefulWidget {
  const CreateOrder({super.key});

  @override
  ConsumerState<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends ConsumerState<CreateOrder> {
  List<Product> allProducts = [];
  List<Product> searchedProducts = [];
  final MobileScannerController controller = MobileScannerController();
  bool barcodeScanned = false;

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
                        action: () => _openScanner(),
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
                      height: MediaQuery.of(context).size.height * 0.75,
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
                                .map((e) => _cartItem(e.item ?? Product()))
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
    double sum = itemsTotal();

    return '₦${oCcy.format(double.parse(sum.toString()))}';
  }

  double itemsTotal() {
    final cartItems = ref.watch(transactionStateProvider).value?.cart;
    final sum = ((cartItems ?? [])
        .map((e) => double.parse(e.totalPrice ?? '0'))).reduce((a, b) => a + b);
    return sum;
  }

  String computeUnformatedTotal() {
    double sum = itemsTotal();

    return sum.toDouble().toString();
  }

  Future _openScanner() {
    unawaited(controller.start());

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: screenWidth * 0.5,
          height: screenHeight * 0.6,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: RotatedBox(
            quarterTurns:
                ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 3 : 0,
            child: MobileScanner(
              controller: controller,
              onDetect: (value) => _handleBarcode,
            ),
          ),
        ),
      ),
    );
  }

  _handleBarcode(BarcodeCapture barcode) async {
    if (!barcodeScanned) {
      AppDialog.showInfoDialog(context, barcode.barcodes[0].rawValue ?? '',
          'Barcode value', () {}, 'Ok');
      if ((barcode.barcodes[0].rawValue ?? '').isNotEmpty) {
        barcodeScanned = true;
        final scanResult = barcode.barcodes[0].rawValue ?? '';
        final scannedProduct = allProducts.firstWhere(
          (e) => e.sku == scanResult,
          orElse: () => Product(),
        );
        if ((scannedProduct.sku != null)) {
          await addToCartAction(scannedProduct);
        } else {
          AppDialog.showErrorDialog(context, 'Item not found');
        }
      } else {
        barcodeScanned = false;
        const error = 'Code is invalid';
        AppDialog.showErrorDialog(context, error);
      }
    }
  }

  Future<void> addToCartAction(Product scannedProduct) async {
    try {
      await ref
          .read(transactionStateProvider.notifier)
          .addProductToCart(scannedProduct, '1');
      context.pop();
    } catch (e) {
      AppDialog.showErrorDialog(context, e.toString());
    }
  }

  Widget _cartItem(Product item) {
    String quantity = (ref.watch(transactionStateProvider).value?.cart ?? [])
            .firstWhere((e) => e.item == item, orElse: () => CartProduct())
            .quantity ??
        '0';
    int count = int.parse(quantity);
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                      radius: 40,
                      onTap: () {
                        if (count == 1) {
                          ref
                              .read(transactionStateProvider.notifier)
                              .removeItemFromCart(item ?? Product());
                        } else {
                          ref
                              .read(transactionStateProvider.notifier)
                              .updateCart(item ?? Product(),
                                  (count - 1).toString(), false);
                        }
                      },
                      child: Image.asset(
                        'assets/images/minus-circle.png',
                        width: 25,
                      )),
                  Text(count.toString()),
                  InkWell(
                      radius: 40,
                      onTap: () {
                        ref.read(transactionStateProvider.notifier).updateCart(
                            item ?? Product(), (count + 1).toString(), false);
                      },
                      child: Image.asset(
                        'assets/images/add.png',
                        width: 25,
                      ))
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
          items: (transactionState?.cart ?? []).toList(),
          totalAmount: itemsTotal().toString(),
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
