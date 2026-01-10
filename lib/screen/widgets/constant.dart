import 'package:flight_booking/Model/FareOption.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// H24Voyages Brand Colors
const kPrimaryColor = Color(0xFFFF5722); // Main orange/coral from the website
const kSubSubTitleColor = Color(0xFFFFB299); // Lighter orange tint
const kTitleColor = Color(0xFF1A1A1A); // Dark text (almost black)
const kSecondaryColor = Color(0xFFECEBEB);
const kSubTitleColor = Color(0xFF6F7B8C); // Gray text (keeping original as it works well)
const kLightNeutralColor = Color(0xFFFFAB91); // Light orange accent
const kDarkWhite = Color(0xFFF2F2F2);
const Color kWebsiteGreyBg = Color(0xFFF3F4F6); // light grey like website
// slightly darker for sections/cards // Light gray background
const kWhite = Color(0xFFFFFFFF); // Pure white
const kBorderColorTextField = Color(0xFFE3E7EA); // Light border (keeping original)
const ratingBarColor = Color(0xFFFFB33E); // Yellow/gold for ratings
const kPageBackground = Color(0xFFECEBEB);
// Additional H24 Colors
const kAccentOrange = Color(0xFFFF6B35); // Secondary orange tone
const kDarkBackground = Color(0xFF2C2C2C); // Dark sections
const kSuccessGreen = Color(0xFF4CAF50); // For success states
const kWarningYellow = Color(0xFFFFC107); // For warnings

final kTextStyle = GoogleFonts.jost( // Using Jost to match the modern feel
  color: kTitleColor,
);

// Primary button with H24 orange
const kButtonDecoration = BoxDecoration(
  color: kPrimaryColor,
  borderRadius: BorderRadius.all(
    Radius.circular(50.0), // More rounded for modern look
  ),
  boxShadow: [
    BoxShadow(
      color: Color(0x40FF5722), // Orange shadow with 25% opacity
      blurRadius: 8.0,
      offset: Offset(0, 4),
    ),
  ],
);

// Gradient button decoration (matching website's vibrant style)
const kGradientButtonDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [kPrimaryColor, kAccentOrange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  borderRadius: BorderRadius.all(
    Radius.circular(50.0),
  ),
  boxShadow: [
    BoxShadow(
      color: Color(0x40FF5722),
      blurRadius: 8.0,
      offset: Offset(0, 4),
    ),
  ],
);

// Outlined button (white with orange border)
const kOutlinedButtonDecoration = BoxDecoration(
  color: kWhite,
  borderRadius: BorderRadius.all(
    Radius.circular(50.0),
  ),
  border: Border(
    top: BorderSide(color: kPrimaryColor, width: 2.0),
    bottom: BorderSide(color: kPrimaryColor, width: 2.0),
    left: BorderSide(color: kPrimaryColor, width: 2.0),
    right: BorderSide(color: kPrimaryColor, width: 2.0),
  ),
);

// Secondary button (light background)
const kSecondaryButtonDecoration = BoxDecoration(
  color: kSecondaryColor,
  borderRadius: BorderRadius.all(
    Radius.circular(50.0),
  ),
);

InputDecoration kInputDecoration = InputDecoration(
  hintStyle: GoogleFonts.jost(color: kSubTitleColor),
  labelStyle: GoogleFonts.jost(color: kTitleColor),
  filled: true,
  fillColor: kWhite,
  enabledBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12.0), // Slightly more rounded
    ),
    borderSide: BorderSide(color: kBorderColorTextField, width: 1.5),
  ),
  focusedBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12.0),
    ),
    borderSide: BorderSide(color: kBorderColorTextField, width: 1.5), // Same as enabled border
  ),
  errorBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12.0),
    ),
    borderSide: BorderSide(color: Colors.red, width: 1.5),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12.0),
    ),
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(
      color: kBorderColorTextField,
      width: 1.5,
    ),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
  border: outlineInputBorder(),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(
      color: kBorderColorTextField,
      width: 1.5,
    ),
  ),
  enabledBorder: outlineInputBorder(),
);

// Currency sign - keeping flexible
const String currencySign = 'DZD'; // Algerian Dinar based on the website

bool isReturn = false;
int selectedIndex = 0;

// Flight class options (adapted from H24Voyages context)
List<String> titleList = [
  'Flex',
  'Classic',
  'Flex',
];
String gValue = 'Classic';

List<FareOption> fareOptions = [
  FareOption(
    title: 'Classic',
    oldPrice: 16000,
    price: 14450,
    cancellationFee: 5000,
    dateChangeFee: 7000,
  ),
  FareOption(
    title: 'Flex',
    oldPrice: 18000,
    price: 16500,
    cancellationFee: 0,
    dateChangeFee: 0,
  ),
];
FareOption selectedFare = fareOptions[0]; // default = Classic
// Additional UI Constants
const double kDefaultPadding = 16.0;
const double kDefaultRadius = 12.0;
const double kButtonRadius = 50.0;

// Box decoration with shadow
BoxDecoration kCardDecoration = BoxDecoration(
  color: kWhite,
  borderRadius: BorderRadius.circular(kDefaultRadius),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10.0,
      offset: const Offset(0, 2),
    ),
  ],
);

// Gradient background (optional, for hero sections)
const kBackgroundGradient = LinearGradient(
  colors: [kWhite, kDarkWhite],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Text Styles using H24 colors
final kHeadlineStyle = GoogleFonts.jost(
  fontSize: 32.0,
  fontWeight: FontWeight.bold,
  color: kTitleColor,
);

final kSubheadingStyle = GoogleFonts.jost(
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
  color: kTitleColor,
);

final kBodyTextStyle = GoogleFonts.jost(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
  color: kSubTitleColor,
);

final kButtonTextStyle = GoogleFonts.jost(
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
  color: kWhite,
);

final kLinkTextStyle = GoogleFonts.jost(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  color: kPrimaryColor,
  decoration: TextDecoration.underline,
);