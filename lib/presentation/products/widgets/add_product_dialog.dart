import 'package:eshop/core/domain/entities/product.entity.dart';
import 'package:flutter/material.dart';

class AddProductDialog extends StatefulWidget {
  final Function(Product) onAddProduct;

  const AddProductDialog({super.key, required this.onAddProduct});

  @override
  AddProductDialogState createState() => AddProductDialogState();
}

class AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Product',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField('Name', (value) => name = value),
                _buildTextField('Description', (value) => description = value),
                _buildTextField('SKU', (value) => sku = value),
                _buildTextField('Barcode', (value) => barcode = value),
                _buildTextField('Category', (value) => category = value),
                _buildTextField('Supplier ID', (value) => supplierId = value),
                _buildTextField('Cost Price',
                    (value) => costPrice = double.tryParse(value)),
                _buildTextField('Selling Price',
                    (value) => sellingPrice = int.tryParse(value)),
                _buildTextField('Quantity On Hand',
                    (value) => quantityOnHand = int.tryParse(value)),
                _buildTextField('Quantity Reserved',
                    (value) => quantityReserved = int.tryParse(value)),
                _buildTextField('Reorder Level',
                    (value) => reorderLevel = int.tryParse(value)),
                _buildTextField('Reorder Quantity',
                    (value) => reorderQuantity = int.tryParse(value)),
                _buildTextField('Status', (value) => status = value),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      widget.onAddProduct(
                        Product(
                          name: name,
                          description: description,
                          sku: sku,
                          barcode: barcode,
                          category: category,
                          supplierId: supplierId,
                          costPrice: costPrice,
                          sellingPrice: sellingPrice,
                          quantityOnHand: quantityOnHand,
                          quantityReserved: quantityReserved,
                          reorderLevel: reorderLevel,
                          reorderQuantity: reorderQuantity,
                          status: status,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        onSaved: (value) => onSave(value ?? ''),
      ),
    );
  }
}
