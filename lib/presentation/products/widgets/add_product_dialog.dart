// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:eshop/presentation/shared/app_button.dart';
import 'package:eshop/presentation/shared/app_dialog.dart';
import 'package:eshop/state/providers/product/product.provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';

class AddProductDialog extends ConsumerStatefulWidget
    with WidgetsBindingObserver {
  final bool isEdit;
  const AddProductDialog({super.key, required this.isEdit});

  @override
  AddProductDialogState createState() => AddProductDialogState();
}

class AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final MobileScannerController controller = MobileScannerController(
      // required options for the scanner
      );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  StreamSubscription<Object?>? _subscription;

  String? name;
  String? description;
  String? sku;
  String? barcode;
  String? category;
  String? supplierId;
  double? costPrice;
  int? sellingPrice;
  int? quantityOnHand;
  int? quantityReserved;
  int? reorderLevel;
  int? reorderQuantity;
  String? status;
  File? image;
  bool barcodeScanned = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!controller.value.hasCameraPermission) {
      return;
    }
    _subscription = controller.barcodes.listen(_handleBarcode);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      final product = ref.read(productStateProvider).value?.currentProduct;
      _nameController.text = product?.name ?? '';
      _descriptionController.text = product?.description ?? '';
      _quantityController.text = product?.quantityOnHand ?? '';
      _categoryController.text = product?.category ?? '';
      _costPriceController.text = product?.costPrice ?? '';
      _sellingPriceController.text = product?.sellingPrice ?? '';
      image = File(product?.image ?? '');
    }
    setState(() {});
  }

  @override
  void dispose() async {
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: screenWidth * 0.5,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Text(
                      widget.isEdit ? 'Update Product' : 'Add Product',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    InkWell(
                      onTap: () => context.pop(),
                      child: Image.asset(
                        'assets/images/close.png',
                        width: 30,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField('Name', _nameController),
                _buildTextField('Description', _descriptionController),
                InkWell(
                  onTap: () => _pickImage(),
                  child: Container(
                    width: screenWidth * 0.5,
                    height: 120,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 53, 56, 58),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: image != null
                          ? Image.network(
                              image?.path ?? '',
                              fit: BoxFit.contain,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/cloud-upload.png',
                                  width: 20,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Upload product image',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    barcodeScanned
                        ? _buildTextField('Product Id', _idController)
                        : InkWell(
                            onTap: () => _openScanner(),
                            child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 45,
                                width: screenWidth * 0.47,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    'Scan Barcode',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                )),
                          ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.23,
                      child: _buildTextField('Quantity', _quantityController),
                    ),
                    SizedBox(
                      width: screenWidth * 0.23,
                      child: _buildTextField('Category', _categoryController),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.23,
                      child:
                          _buildTextField('Cost Price', _costPriceController),
                    ),
                    SizedBox(
                      width: screenWidth * 0.23,
                      child: _buildTextField(
                          'Selling Price', _sellingPriceController),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      isActive: true,
                      background: Theme.of(context).colorScheme.primary,
                      action: () => onAddProduct(),
                      textColor: Colors.black,
                      text: widget.isEdit ? 'Update Product' : 'Add Product',
                      hasBorder: false,
                      elevation: 10,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    widget.isEdit
                        ? AppButton(
                            isActive: true,
                            background: Colors.redAccent,
                            action: () {
                              onDeleteProduct();
                            },
                            textColor: Colors.white,
                            text: 'Delete Product',
                            hasBorder: false,
                            elevation: 10,
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onDeleteProduct() async {
    try {
      AppDialog.showLoading(context);
      final product = ref.read(productStateProvider).value?.currentProduct;

      await ref
          .read(productStateProvider.notifier)
          .deleteProduct(product?.sku ?? '');
      AppDialog.showSuccessDialog(
          context, 'Product has been deleted successfully', action: () {
        context.pop();
        context.pop();
      });
    } catch (e) {
      if (mounted) {
        AppDialog.hideLoading(context);
        AppDialog.showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> onAddProduct() async {
    try {
      final product = ref.watch(productStateProvider).value?.currentProduct;

      // if (_formKey.currentState?.validate() ?? false) {
      AppDialog.showLoading(context);
      const uuid = Uuid();
      final payload = Product(
          name: _nameController.text,
          description: _descriptionController.text,
          sku: widget.isEdit
              ? (product?.sku ?? '')
              : (barcode ?? '').isNotEmpty
                  ? barcode
                  : uuid.v4().split('-').join().substring(0, 14),
          category: _categoryController.text,
          costPrice: _costPriceController.text,
          sellingPrice: _sellingPriceController.text,
          quantityOnHand: _quantityController.text,
          quantityReserved: _quantityController.text,
          image: (widget.isEdit && (image?.path ?? '').isEmpty)
              ? product?.image
              : image?.path ?? '',
          status: widget.isEdit ? product?.status ?? '' : 'Active',
          createdAt: widget.isEdit
              ? (product?.createdAt ?? '')
              : DateTime.now().toString(),
          updatedAt: DateTime.now().toString());
      if (widget.isEdit) {
        await ref.read(productStateProvider.notifier).updateProduct(payload);
      } else {
        await ref.read(productStateProvider.notifier).createProduct(payload);
      }
      if (mounted) {
        AppDialog.hideLoading(context);
        AppDialog.showSuccessDialog(
          context,
          action: () {
            context.pop();
            context.pop();
          },
          widget.isEdit
              ? 'Product updated successfully'
              : 'Product created successfully',
        );
        // }
      }
    } catch (e) {
      if (mounted) {
        AppDialog.hideLoading(context);
        AppDialog.showErrorDialog(context, e.toString());
      }
    }
  }

  _handleBarcode(BarcodeCapture barcode) {
    if (kDebugMode) {
      print(barcode.barcodes[0].rawValue);
    }
    context.pop();
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
          child: MobileScanner(
            controller: controller,
            onDetect: (barcodes) => _handleBarcode,
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final xImage = await picker.pickImage(source: ImageSource.gallery);
    image = File(xImage?.path ?? '');
    setState(() {});
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: label == 'Description' ? 10 : 1,
        minLines: label == 'Description' ? 5 : 1,
        controller: controller,
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary)),
          labelStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
