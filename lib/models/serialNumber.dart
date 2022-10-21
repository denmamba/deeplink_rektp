class DeviceManager {
  int idDevice = 0;
  String serialNumber = "";
  int statusDevice = 0;
  String registerDate = "";

  DeviceManager(
      this.idDevice, this.serialNumber, this.registerDate, this.statusDevice);

  DeviceManager.fromJson(Map<String, dynamic> json) {
    idDevice = json['id_device'];
    serialNumber = json['serial_number'];
    statusDevice = json['status_device'];
    registerDate = json['register_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_device'] = this.idDevice;
    data['serial_number'] = this.registerDate;
    data['status_device'] = this.statusDevice;
    data['register_date'] = this.serialNumber;
    return data;
  }
}
