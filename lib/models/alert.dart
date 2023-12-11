class AlertModel {
  final String alertDate;
  final String title;
  final String data;
  final int category;

  AlertModel({
    required this.alertDate,
    required this.title,
    required this.data,
    required this.category,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      alertDate: json['alertDate'] ?? '',
      title: json['title'] ?? '',
      data: json['data'] ?? '',
      category: json['category'] ?? 0,
    );
  }
}