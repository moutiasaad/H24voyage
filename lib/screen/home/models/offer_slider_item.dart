import 'package:flutter/material.dart';

class OfferSliderItem {
  final String id;
  final String backgroundImage;
  final VoidCallback? onTap;

  OfferSliderItem({
    required this.id,
    required this.backgroundImage,
    this.onTap,
  });

  factory OfferSliderItem.fromJson(Map<String, dynamic> json) {
    return OfferSliderItem(
      id: json['id'] ?? '',
      backgroundImage: json['background_image'] ?? '',
    );
  }
}
