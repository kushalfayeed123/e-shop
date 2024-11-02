import 'package:eshop/core/domain/entities/device.entity.dart';

class AppLog {
  String? id;
  String? userId;
  String? eventType;
  String? timestamp;
  Device? device;
  String? description;

  AppLog(
      {this.id,
      this.userId,
      this.eventType,
      this.timestamp,
      this.device,
      this.description});

  AppLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    eventType = json['eventType'];
    timestamp = json['timestamp'];
    device = json['device'] != null ? Device.fromJson(json['device']) : null;
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['eventType'] = eventType;
    data['timestamp'] = timestamp;
    if (device != null) {
      data['device'] = device!.toJson();
    }
    data['description'] = description;
    return data;
  }
}
