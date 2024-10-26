class Attributes {
  String? color;
  String? size;
  String? weight;

  Attributes({this.color, this.size, this.weight});

  Attributes.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    size = json['size'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['size'] = size;
    data['weight'] = weight;
    return data;
  }
}
