import 'package:flight_booking/Model/ReservationStatus.dart';
import 'package:flutter/material.dart';
import 'package:flight_booking/generated/l10n.dart';

extension ReservationStatusExtension on ReservationStatus {

  /// ✅ TRANSLATED LABEL
  String localizedLabel(S l10n) {
    switch (this) {
      case ReservationStatus.enCours:
        return l10n.statusInProgress;
      case ReservationStatus.confirme:
        return l10n.statusConfirmed;
      case ReservationStatus.termine:
        return l10n.statusCompleted;
      case ReservationStatus.annule:
        return l10n.statusCancelled;
    }
  }

  /// 🎨 BACKGROUND COLOR
  Color get backgroundColor {
    switch (this) {
      case ReservationStatus.enCours:
        return const Color(0xFFFFF0E8);
      case ReservationStatus.confirme:
        return const Color(0xFFE8F5E9);
      case ReservationStatus.termine:
        return const Color(0xFFE3F2FD);
      case ReservationStatus.annule:
        return const Color(0xFFFFEBEE);
    }
  }

  /// 🎨 TEXT COLOR
  Color get textColor {
    switch (this) {
      case ReservationStatus.enCours:
        return const Color(0xFFFF6A00);
      case ReservationStatus.confirme:
        return const Color(0xFF4CAF50);
      case ReservationStatus.termine:
        return const Color(0xFF2196F3);
      case ReservationStatus.annule:
        return const Color(0xFFF44336);
    }
  }
}
