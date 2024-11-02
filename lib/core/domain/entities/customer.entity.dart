import 'package:eshop/core/domain/entities/address.entity.dart';

class Customer {
  String? id;
  String? name;
  String? email;
  String? phone;
  Address? address;
  String? createdAt;
  String? updatedAt;

  Customer(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.createdAt,
      this.updatedAt});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
