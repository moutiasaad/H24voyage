class AdvantageSliderItem {
  final String id;
  final String backgroundImage;
  final String? iconImage;
  final String title;
  final String subtitle;

  AdvantageSliderItem({
    required this.id,
    required this.backgroundImage,
    this.iconImage,
    required this.title,
    required this.subtitle,
  });

  factory AdvantageSliderItem.fromJson(Map<String, dynamic> json) {
    return AdvantageSliderItem(
      id: json['id'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      iconImage: json['icon_image'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }
}
