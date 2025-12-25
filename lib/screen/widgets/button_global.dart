import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant.dart';

/// 🔹 Filled button
class ButtonGlobal extends StatelessWidget {
  final String buttontext;
  final Decoration buttonDecoration;
  final VoidCallback onPressed;

  const ButtonGlobal({
    Key? key,
    required this.buttontext,
    required this.buttonDecoration,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: buttonDecoration is BoxDecoration
            ? (buttonDecoration as BoxDecoration).copyWith(
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        )
            : buttonDecoration,
        child: Center(
          child: Text(
            buttontext,
            style: kTextStyle.copyWith(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹 Outlined / colored text button (no icon)
class ButtonGlobalWithoutIcon extends StatelessWidget {
  final String buttontext;
  final Decoration buttonDecoration;
  final VoidCallback onPressed;
  final Color buttonTextColor;

  const ButtonGlobalWithoutIcon({
    Key? key,
    required this.buttontext,
    required this.buttonDecoration,
    required this.onPressed,
    required this.buttonTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: buttonDecoration is BoxDecoration
            ? (buttonDecoration as BoxDecoration).copyWith(
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        )
            : buttonDecoration,
        child: Center(
          child: Text(
            buttontext,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: buttonTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹 Button with icon
class ButtonGlobalWithIcon extends StatelessWidget {
  final String buttontext;
  final Decoration buttonDecoration;
  final VoidCallback onPressed;
  final Color buttonTextColor;
  final IconData buttonIcon;

  const ButtonGlobalWithIcon({
    Key? key,
    required this.buttontext,
    required this.buttonDecoration,
    required this.onPressed,
    required this.buttonTextColor,
    required this.buttonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: buttonDecoration is BoxDecoration
            ? (buttonDecoration as BoxDecoration).copyWith(
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        )
            : buttonDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(buttonIcon, color: buttonTextColor),
            const SizedBox(width: 8),
            Text(
              buttontext,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: buttonTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
