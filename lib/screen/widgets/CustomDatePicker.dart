import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final bool isRoundTrip;

  const CustomDatePicker({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
    this.isRoundTrip = true,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? departureDate;
  DateTime? returnDate;

  @override
  void initState() {
    super.initState();
    departureDate = widget.initialStartDate;
    // Only set return date if it's a round trip
    returnDate = widget.isRoundTrip ? widget.initialEndDate : null;
  }

  String _getFormattedDate(DateTime date) {
    return DateFormat('dd MMMM', 'fr_FR').format(date);
  }

  String _getDayOfWeek(DateTime date) {
    return DateFormat('EEEE', 'fr_FR').format(date);
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      if (!widget.isRoundTrip) {
        // For one-way trip (Aller simple), only select departure and close
        departureDate = day;
        returnDate = null;
        // Automatically confirm and close after selecting departure date
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pop(context, {
            'departure': departureDate,
            'return': null,
          });
        });
      } else {
        // For round-trip (Aller-retour), allow selecting both dates
        if (departureDate == null || (departureDate != null && returnDate != null)) {
          // First selection or restart selection
          departureDate = day;
          returnDate = null;
        } else if (day.isBefore(departureDate!)) {
          // If selected date is before departure, make it new departure
          departureDate = day;
          returnDate = null;
        } else {
          // Second selection (return date)
          returnDate = day;
        }
      }
    });
  }

  bool _isInRange(DateTime day) {
    if (departureDate == null || returnDate == null) return false;
    return day.isAfter(departureDate!.subtract(const Duration(days: 1))) &&
        day.isBefore(returnDate!.add(const Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    widget.isRoundTrip ? 'Dates de voyage' : 'Date de voyage',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: SmallTapEffect(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: kPrimaryColor),
                  ),
                ),
              ],
            ),
          ),

          // Departure and Return Date Display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                // Departure Date
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Départ',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        departureDate != null
                            ? _getFormattedDate(departureDate!)
                            : 'Sélectionner une date',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: departureDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                      if (departureDate != null)
                        Text(
                          _getDayOfWeek(departureDate!),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.isRoundTrip)
                  Container(
                    width: 1,
                    height: 60,
                    color: Colors.grey.shade300,
                  ),
                // Return Date (only for round-trip)
                if (widget.isRoundTrip)
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Retour',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          returnDate != null
                              ? _getFormattedDate(returnDate!)
                              : 'Sélectionner une date',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,

                            color: returnDate != null ? kPrimaryColor : Colors.grey,
                          ),
                        ),
                        if (returnDate != null)
                          Text(
                            _getDayOfWeek(returnDate!),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Divider below DÉPART and RETOUR section
          Divider(
            thickness: 1.0,
            color: Colors.grey.shade300,
            height: 1,
          ),

          // Calendar
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMonthCalendar(DateTime.now()),
                  _buildMonthCalendar(DateTime(DateTime.now().year, DateTime.now().month + 1)),
                  _buildMonthCalendar(DateTime(DateTime.now().year, DateTime.now().month + 2)),
                ],
              ),
            ),
          ),

          // Bottom Section
          if (departureDate != null && returnDate != null)
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Duration display
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: 'Durée du voyage : '),
                            TextSpan(
                              text: '${returnDate!.difference(departureDate!).inDays} jour${returnDate!.difference(departureDate!).inDays > 1 ? 's' : ''}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'departure': departureDate,
                          'return': returnDate,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Confirmer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        ),
      ),
    );
  }

  Widget _buildMonthCalendar(DateTime month) {
    final monthName = DateFormat('MMMM yyyy', 'fr_FR').format(month);
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday - 1; // 0 = Monday, 6 = Sunday

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            monthName.substring(0, 1).toUpperCase() + monthName.substring(1),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Weekday headers
          Row(
            children: [
              Expanded(child: _buildWeekdayHeader('Lun.')),
              Expanded(child: _buildWeekdayHeader('Mar.')),
              Expanded(child: _buildWeekdayHeader('Mer.')),
              Expanded(child: _buildWeekdayHeader('Jeu.')),
              Expanded(child: _buildWeekdayHeader('Ven.')),
              Expanded(child: _buildWeekdayHeader('Sam.')),
              Expanded(child: _buildWeekdayHeader('Dim.')),
            ],
          ),
          const SizedBox(height: 10),
          // Calendar grid
          ...List.generate((daysInMonth + startWeekday) ~/ 7 + 1, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final dayNumber = weekIndex * 7 + dayIndex - startWeekday + 1;
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const Expanded(child: SizedBox(height: 40));
                  }
                  final date = DateTime(month.year, month.month, dayNumber);
                  final today = DateTime.now();
                  final isToday = date.year == today.year &&
                      date.month == today.month &&
                      date.day == today.day;
                  final isBeforeToday = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
                  final isDeparture = departureDate != null &&
                      date.year == departureDate!.year &&
                      date.month == departureDate!.month &&
                      date.day == departureDate!.day;
                  final isReturn = returnDate != null &&
                      date.year == returnDate!.year &&
                      date.month == returnDate!.month &&
                      date.day == returnDate!.day;
                  final inRange = _isInRange(date);

                  // Check if we should show grey on left or right side
                  final showGreyOnLeft = (departureDate != null && returnDate != null) && (inRange || isReturn) && !isDeparture;
                  final showGreyOnRight = (departureDate != null && returnDate != null) && (inRange || isDeparture) && !isReturn;

                  return Expanded(
                    child: SmallTapEffect(
                      onTap: isBeforeToday ? null : () => _onDaySelected(date),
                      child: Stack(
                        children: [
                          // Background with left/right split
                          Positioned.fill(
                            child: Row(
                              children: [
                                // Left half
                                Expanded(
                                  child: Container(
                                    color: showGreyOnLeft ? Colors.grey.shade200 : Colors.transparent,
                                  ),
                                ),
                                // Right half
                                Expanded(
                                  child: Container(
                                    color: showGreyOnRight ? Colors.grey.shade200 : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Circle
                          Container(
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isDeparture
                                      ? Colors.grey.shade800
                                      : isReturn
                                          ? kPrimaryColor
                                          : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: isToday && !isDeparture && !isReturn
                                      ? Border.all(color: Colors.grey.shade800, width: 1.5)
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$dayNumber',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isBeforeToday
                                        ? Colors.grey.shade400
                                        : (isDeparture || isReturn)
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: (isDeparture || isReturn) ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
