// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:eshop/core/domain/entities/cart.entity.dart';
import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/core/domain/entities/transaction.entity.dart';
import 'package:eshop/presentation/products/widgets/product_card.dart';
import 'package:eshop/presentation/shared/constants.dart';
import 'package:eshop/presentation/shared/widgets/app_button.dart';
import 'package:eshop/presentation/shared/widgets/app_dialog.dart';
import 'package:eshop/presentation/shared/widgets/scanner.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:eshop/state/providers/transaction/transaction.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
  bool barcodeScanned = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    barcodeScanned = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final state = ref.watch(productStateProvider).value;
    final cartState = ref.watch(transactionStateProvider).value?.cart;
    final currentOrder =
        ref.watch(transactionStateProvider).value?.currentOrder;
    allProducts = state?.products ?? [];
    final formatedDate = DateFormat.yMMMEd().format(DateTime.now());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: ResponsiveRowColumn(
          layout: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
              ? ResponsiveRowColumnType.ROW
              : ResponsiveRowColumnType.COLUMN,
          rowMainAxisAlignment: MainAxisAlignment.start,
          columnMainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ResponsiveRowColumnItem(
              child: Expanded(
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
                              onTap: () {
                                context.pop();
                              },
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 25,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              (cartState ?? []).isNotEmpty
                                  ? (currentOrder?.id ?? '')
                                  : "New Order",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          formatedDate,
                          style: const TextStyle(
                              color: Color(0xFFB3B3B3), fontSize: 14),
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
                            onChanged: (value) => searchProducts(value),
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

                    const SizedBox(height: 20),
                    ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppButton(
                                isActive: true,
                                background: Colors.transparent,
                                action: () => _showCartBottomSheet(cartState),
                                textColor: Colors.white,
                                text: 'View Cart',
                                hasBorder: true,
                                elevation: 5,
                              )
                            ],
                          ),

                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveBreakpoints.of(context)
                                  .largerThan(MOBILE)
                              ? 4
                              : 1,
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
            ),
            ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                ? ResponsiveRowColumnItem(
                    child: Container(
                      width:
                          ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                              ? screenWidth * 0.2
                              : screenWidth,
                      height:
                          ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                              ? screenHeight
                              : screenHeight * 0.2,
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: ResponsiveRowColumn(
                        layout:
                            ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                                ? ResponsiveRowColumnType.COLUMN
                                : ResponsiveRowColumnType.ROW,
                        columnMainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ResponsiveRowColumnItem(
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: SingleChildScrollView(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: (cartState ?? []).isEmpty
                                      ? [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                            child: Center(
                                              child: Text(
                                                'Selected Products will show up here',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        ]
                                      : (cartState ?? [])
                                          .map((e) => _cartItem(
                                              e.item ?? Product(),
                                              cartState,
                                              null))
                                          .toList(),
                                ))),
                          ),
                          ResponsiveRowColumnItem(
                            child: (cartState ?? []).isEmpty
                                ? const SizedBox.shrink()
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Text(
                                            computeTotal(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () => showConfirmation(
                                                action: 'cancel'),
                                            child: Container(
                                              height: 45,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                            onTap: () => showConfirmation(
                                                action: 'save'),
                                            child: Container(
                                              height: 45,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  border: Border.all()),
                                              child: Center(
                                                child: Text(
                                                  'Save',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                          )
                        ],
                      ),
                    ),
                  )
                : const ResponsiveRowColumnItem(child: SizedBox.shrink())
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: screenWidth * 0.5,
          height: screenHeight * 0.6,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: Scanner(
            onScanned: (BarcodeCapture value) async {
              if (barcodeScanned == false) {
                if ((value.barcodes[0].displayValue ?? '').isNotEmpty) {
                  await _handleBarcode(value, context);
                } else {
                  barcodeScanned = false;
                  AppDialog.showErrorDialog(context, 'Code is invalid');
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleBarcode(
      BarcodeCapture barcode, BuildContext context) async {
    try {
      final scanResult = barcode.barcodes[0].rawValue ?? '';
      final scannedProduct = allProducts.firstWhere(
        (e) => e.sku == scanResult,
        orElse: () => Product(),
      );
      if ((scannedProduct.sku != null)) {
        barcodeScanned = true;
        final snackBar = SnackBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Text(
            'Product has been added to cart.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
        await ref
            .read(transactionStateProvider.notifier)
            .addProductToCart(scannedProduct, '1');

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
        Navigator.of(context).pop();
      } else {
        AppDialog.showErrorDialog(context, 'Item not found');
      }
    } catch (e) {
      AppDialog.showErrorDialog(context, e.toString());
    }
  }

  Widget _cartItem(
    Product item,
    List<CartProduct>? cartState,
    StateSetter? setState,
  ) {
    final quantity = (cartState ?? [])
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
            Text(item.name ?? ''),
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
                              .removeItemFromCart(item);
                        } else {
                          ref
                              .read(transactionStateProvider.notifier)
                              .updateCart(item, (count - 1).toString(), false);
                        }
                        if (setState != null) {
                          setState(() {});
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
                        ref
                            .read(transactionStateProvider.notifier)
                            .updateCart(item, (count + 1).toString(), false);
                        if (setState != null) {
                          setState(() {});
                        }
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

  void searchProducts(String param) {
    if (param.isEmpty) {
      searchedProducts = [];
    } else {
      searchedProducts = allProducts
          .where((e) =>
              (e.name ?? '').toLowerCase().contains(param.toLowerCase()) ||
              (e.sku ?? '').toLowerCase().contains(param.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void showConfirmation({required String action}) {
    AppDialog.showConfirmationDialog(context,
        info: action == 'cancel'
            ? 'This action will clear your current order. Are you sure you want to continue?'
            : 'Would you like to complete this order or pause it. Ensure payment has been confirmed before completing the order',
        title: action == 'cancel' ? 'Cancel Order' : 'Confirm Payment',
        confirmAction: () =>
            action == 'cancel' ? clearOrder() : createOrder(false),
        confirmActionText: action == 'cancel' ? 'Continue' : 'Complete',
        denyAction: () =>
            action == 'cancel' ? context.pop() : createOrder(true),
        denyActionText: action == 'cancel' ? 'Cancel' : 'Pause');
  }

  void clearOrder() {
    ref.read(transactionStateProvider.notifier).clearOrderState();
    context.pop();
    context.pop();
  }

  void createOrder(bool isCancel) async {
    try {
      AppDialog.showLoading(context);
      final transactionState = ref.watch(transactionStateProvider).value;
      final payload = TransactionModel(
          id: transactionState?.currentOrder?.id ?? '',
          userId: FirebaseAuth.instance.currentUser?.uid,
          transactionType: 'Purchase',
          items: (transactionState?.cart ?? []).toList(),
          totalAmount: itemsTotal().toString(),
          transactionDate: DateTime.now().toString(),
          status: isCancel ? 'In progress' : 'Completed');

      if (transactionState?.currentOrder != null) {
        await ref
            .read(transactionStateProvider.notifier)
            .updateTransaction(payload);
      } else {
        await ref
            .read(transactionStateProvider.notifier)
            .createTransaction(payload);
      }
      AppDialog.hideLoading(context);
      AppDialog.showSuccessDialog(
          context, 'Order has been registered successfully', action: () {
        context.pop();
        context.pop();
        context.pop();
        if (ResponsiveBreakpoints.of(context).smallerThan(TABLET)) {
          context.pop();
        }
      });
    } catch (e) {
      AppDialog.hideLoading(context);
      AppDialog.showErrorDialog(context, e.toString());
    }
  }

  void _showCartBottomSheet(List<CartProduct>? cartState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (BuildContext context, setState) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Adjust initial size as desired
          minChildSize: 0.5,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            return Container(
              width: screenWidth,
              height: screenHeight * 0.6,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: ResponsiveRowColumn(
                  layout: ResponsiveRowColumnType.COLUMN,
                  columnMainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ResponsiveRowColumnItem(
                      child: SizedBox(
                        height: screenHeight * 0.3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (cartState ?? []).isEmpty
                                ? [
                                    SizedBox(
                                      height: screenHeight * 0.2,
                                      child: Center(
                                        child: Text(
                                          'Selected Products will show up here',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  ]
                                : (cartState ?? [])
                                    .map((e) => _cartItem(e.item ?? Product(),
                                        cartState, setState))
                                    .toList(),
                          ),
                        ),
                      ),
                    ),
                    ResponsiveRowColumnItem(
                      child: (cartState ?? []).isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Text(
                                      computeTotal(),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          showConfirmation(action: 'cancel'),
                                      child: Container(
                                        height: 45,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
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
                                      onTap: () =>
                                          showConfirmation(action: 'save'),
                                      child: Container(
                                        height: 45,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          border: Border.all(),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Save',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
