class AlertCategory {
  final int category;
  final String label;
  final String description;
  final String link;

  AlertCategory({
    required this.category,
    required this.label,
    required this.description,
    required this.link,
  });

  factory AlertCategory.fromJson(Map<String, dynamic> json) {
    return AlertCategory(
      category: json['category'],
      label: json['label'],
      description: json['description1'],
      link: json['link2'],
    );
  }
}
