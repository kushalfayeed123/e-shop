class Address {
  String? street;
  String? city;
  String? state;
  String? zipCode;
  String? country;

  Address({this.street, this.city, this.state, this.zipCode, this.country});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['zip_code'] = zipCode;
    data['country'] = country;
    return data;
  }
}
