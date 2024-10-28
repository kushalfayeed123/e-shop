import 'package:eshop/core/domain/entities/product_attributes.entity.dart';

class Product {
  String? id;
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
      {this.id,
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
    id = json['id'];
    name = json['name'];
    description = json['description'];
    sku = json['sku'];
    barcode = json['barcode'];
    category = json['category'];
    supplierId = json['supplierId'];
    costPrice = json['costPrice'];
    sellingPrice = json['sellingPrice'];
    quantityOnHand = json['quantityOnHand'];
    quantityReserved = json['quantityReserved'];
    reorderLevel = json['reorderLevel'];
    reorderQuantity = json['reorderQuantity'];
    status = json['status'];
    attributes = json['attributes'] != null
        ? Attributes.fromJson(json['attributes'])
        : null;
    images = json['images'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['sku'] = sku;
    data['barcode'] = barcode;
    data['category'] = category;
    data['supplierId'] = supplierId;
    data['costPrice'] = costPrice;
    data['sellingPrice'] = sellingPrice;
    data['quantityOnHand'] = quantityOnHand;
    data['quantityReserved'] = quantityReserved;
    data['reorderLevel'] = reorderLevel;
    data['reorderQuantity'] = reorderQuantity;
    data['status'] = status;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    data['images'] = images;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
