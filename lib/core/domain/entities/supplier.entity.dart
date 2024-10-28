import 'package:eshop/core/domain/entities/address.entity.dart';

class Supplier {
  String? id;
  String? name;
  String? contactPerson;
  String? email;
  String? phone;
  Address? address;
  List<String>? productsSupplied;
  String? createdAt;
  String? updatedAt;

  Supplier(
      {this.id,
      this.name,
      this.contactPerson,
      this.email,
      this.phone,
      this.address,
      this.productsSupplied,
      this.createdAt,
      this.updatedAt});

  Supplier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contactPerson = json['contactPerson'];
    email = json['email'];
    phone = json['phone'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    productsSupplied = json['productsSupplied'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplier_id'] = id;
    data['name'] = name;
    data['contactPerson'] = contactPerson;
    data['email'] = email;
    data['phone'] = phone;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['productsSupplied'] = productsSupplied;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
