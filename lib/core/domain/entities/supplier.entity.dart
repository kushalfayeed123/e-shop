import 'package:eshop/core/domain/entities/address.entity.dart';

class Supplier {
  String? supplierId;
  String? name;
  String? contactPerson;
  String? email;
  String? phone;
  Address? address;
  List<String>? productsSupplied;
  String? createdAt;
  String? updatedAt;

  Supplier(
      {this.supplierId,
      this.name,
      this.contactPerson,
      this.email,
      this.phone,
      this.address,
      this.productsSupplied,
      this.createdAt,
      this.updatedAt});

  Supplier.fromJson(Map<String, dynamic> json) {
    supplierId = json['supplier_id'];
    name = json['name'];
    contactPerson = json['contact_person'];
    email = json['email'];
    phone = json['phone'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    productsSupplied = json['products_supplied'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplier_id'] = supplierId;
    data['name'] = name;
    data['contact_person'] = contactPerson;
    data['email'] = email;
    data['phone'] = phone;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['products_supplied'] = productsSupplied;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
