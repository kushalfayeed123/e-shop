import 'package:eshop/core/domain/entities/product_attributes.entity.dart';

class Product {
  String? productId;
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
  Attributes? attributes;
  List<String>? images;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.productId,
      this.name,
      this.description,
      this.sku,
      this.barcode,
      this.category,
      this.supplierId,
      this.costPrice,
      this.sellingPrice,
      this.quantityOnHand,
      this.quantityReserved,
      this.reorderLevel,
      this.reorderQuantity,
      this.status,
      this.attributes,
      this.images,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    description = json['description'];
    sku = json['sku'];
    barcode = json['barcode'];
    category = json['category'];
    supplierId = json['supplier_id'];
    costPrice = json['cost_price'];
    sellingPrice = json['selling_price'];
    quantityOnHand = json['quantity_on_hand'];
    quantityReserved = json['quantity_reserved'];
    reorderLevel = json['reorder_level'];
    reorderQuantity = json['reorder_quantity'];
    status = json['status'];
    attributes = json['attributes'] != null
        ? Attributes.fromJson(json['attributes'])
        : null;
    images = json['images'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['name'] = name;
    data['description'] = description;
    data['sku'] = sku;
    data['barcode'] = barcode;
    data['category'] = category;
    data['supplier_id'] = supplierId;
    data['cost_price'] = costPrice;
    data['selling_price'] = sellingPrice;
    data['quantity_on_hand'] = quantityOnHand;
    data['quantity_reserved'] = quantityReserved;
    data['reorder_level'] = reorderLevel;
    data['reorder_quantity'] = reorderQuantity;
    data['status'] = status;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    data['images'] = images;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
