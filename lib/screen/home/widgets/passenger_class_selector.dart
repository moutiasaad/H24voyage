import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';

/// A tappable card row displaying the passenger count and class selection.
/// Shows a person icon, the total passenger count, and the selected class name.
class PassengerClassSelector extends StatelessWidget {
  final int totalPassengers;
  final String classDisplayName;
  final VoidCallback onTap;

  const PassengerClassSelector({
    Key? key,
    required this.totalPassengers,
    required this.classDisplayName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: kPrimaryColor,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang.S.of(context).homePassengerClass,
                      style: kTextStyle.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${lang.S.of(context).homePassengerCount(totalPassengers)}, $classDisplayName',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
