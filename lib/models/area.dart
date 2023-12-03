class Area {
  final String label;
  final String value;
  final int areaId;
  final String areaName;
  final String labelHe;
  final int migunTime;

  Area({
    this.label,
    this.value,
    this.areaId,
    this.areaName,
    this.labelHe,
    this.migunTime,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    final cityData = json['city_data'];

    return Area(
      label: json['label'],
      value: json['value'],
      areaId: json['areaid'],
      areaName: json['areaname'],
      labelHe: json['label_he'],
      migunTime: json['migun_time'],
    );
  }
}
