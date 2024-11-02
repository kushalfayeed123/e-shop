class Device {
  String? id;
  String? deviceType;
  String? appVersion;
  String? osVersion;
  String? token;

  Device({this.id, this.deviceType, this.appVersion, this.osVersion});

  Device.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceType = json['deviceType'];
    appVersion = json['appVersion'];
    osVersion = json['osVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deviceType'] = deviceType;
    data['appVersion'] = appVersion;
    data['osVersion'] = osVersion;
    return data;
  }
}
