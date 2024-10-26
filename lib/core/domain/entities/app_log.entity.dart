import 'package:eshop/core/domain/entities/device.entity.dart';

class AppLog {
  String? logId;
  String? userId;
  String? eventType;
  String? timestamp;
  Device? device;
  String? description;

  AppLog(
      {this.logId,
      this.userId,
      this.eventType,
      this.timestamp,
      this.device,
      this.description});

  AppLog.fromJson(Map<String, dynamic> json) {
    logId = json['log_id'];
    userId = json['user_id'];
    eventType = json['event_type'];
    timestamp = json['timestamp'];
    device = json['device_info'] != null
        ? Device.fromJson(json['device_info'])
        : null;
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['log_id'] = logId;
    data['user_id'] = userId;
    data['event_type'] = eventType;
    data['timestamp'] = timestamp;
    if (device != null) {
      data['device_info'] = device!.toJson();
    }
    data['description'] = description;
    return data;
  }
}
