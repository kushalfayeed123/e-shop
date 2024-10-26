class Device {
  String? deviceId;
  String? deviceType;
  String? appVersion;
  String? osVersion;

  Device({this.deviceId, this.deviceType, this.appVersion, this.osVersion});

  Device.fromJson(Map<String, dynamic> json) {
    deviceId = json['device_id'];
    deviceType = json['device_type'];
    appVersion = json['app_version'];
    osVersion = json['os_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['device_id'] = deviceId;
    data['device_type'] = deviceType;
    data['app_version'] = appVersion;
    data['os_version'] = osVersion;
    return data;
  }
}
