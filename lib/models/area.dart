class Area {
  final String label;
  final String value;
  final int areaId;
  final String areaName;
  final String labelHe;
  final int migunTime;

  Area({
    required this.label,
    required this.value,
    required this.areaId,
    required this.areaName,
    required this.labelHe,
    required this.migunTime,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    final cityData = json['city_data'];

    return Area(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
      areaId: json['areaid'] ?? 0,
      areaName: json['areaname'] ?? '',
      labelHe: json['label_he'] ?? '',
      migunTime: json['migun_time'] ?? 0,
      // Additional properties based on your model
    );
  }
}
