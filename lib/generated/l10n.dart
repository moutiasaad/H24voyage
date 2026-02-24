// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Flight Booking`
  String get appTitle {
    return Intl.message('Flight Booking', name: 'appTitle', desc: '', args: []);
  }

  /// `Flight`
  String get flight {
    return Intl.message('Flight', name: 'flight', desc: '', args: []);
  }

  /// `Skip`
  String get skipButton {
    return Intl.message('Skip', name: 'skipButton', desc: '', args: []);
  }

  /// `Book now\nand pay on arrival`
  String get onBoardTitle1 {
    return Intl.message(
      'Book now\nand pay on arrival',
      name: 'onBoardTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Find the best\nflights at the best price`
  String get onBoardTitle2 {
    return Intl.message(
      'Find the best\nflights at the best price',
      name: 'onBoardTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Travel with complete\npeace of mind`
  String get onBoardTitle3 {
    return Intl.message(
      'Travel with complete\npeace of mind',
      name: 'onBoardTitle3',
      desc: '',
      args: [],
    );
  }

  /// `You set the time`
  String get onBoardTagline {
    return Intl.message(
      'You set the time',
      name: 'onBoardTagline',
      desc: '',
      args: [],
    );
  }

  /// `Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa`
  String get onBoardSubTitle1 {
    return Intl.message(
      'Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa',
      name: 'onBoardSubTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa`
  String get onBoardSubTitle2 {
    return Intl.message(
      'Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa',
      name: 'onBoardSubTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa`
  String get onBoardSubTitle3 {
    return Intl.message(
      'Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa',
      name: 'onBoardSubTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Start Your Journey with`
  String get wcTitle {
    return Intl.message(
      'Start Your Journey with',
      name: 'wcTitle',
      desc: '',
      args: [],
    );
  }

  /// `Flight Booking`
  String get wcSubTitle {
    return Intl.message(
      'Flight Booking',
      name: 'wcSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa`
  String get wcDescription {
    return Intl.message(
      'Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa',
      name: 'wcDescription',
      desc: '',
      args: [],
    );
  }

  /// `Create An Account`
  String get createAccButton {
    return Intl.message(
      'Create An Account',
      name: 'createAccButton',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get loginButton {
    return Intl.message('Log In', name: 'loginButton', desc: '', args: []);
  }

  /// `Log In Your Account`
  String get loginTitle {
    return Intl.message(
      'Log In Your Account',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Enter your email`
  String get emailHint {
    return Intl.message(
      'Enter your email',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Enter your password`
  String get passwordHint {
    return Intl.message(
      'Enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Or Sign up with`
  String get orSignUpTitle {
    return Intl.message(
      'Or Sign up with',
      name: 'orSignUpTitle',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get alreadyHaveAcc {
    return Intl.message(
      'Already have an account? ',
      name: 'alreadyHaveAcc',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpButton {
    return Intl.message('Sign Up', name: 'signUpButton', desc: '', args: []);
  }

  /// `Full Name`
  String get nameLabel {
    return Intl.message('Full Name', name: 'nameLabel', desc: '', args: []);
  }

  /// `Enter your full name`
  String get nameHint {
    return Intl.message(
      'Enter your full name',
      name: 'nameHint',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phoneLabel {
    return Intl.message('Phone', name: 'phoneLabel', desc: '', args: []);
  }

  /// `Enter your phone number`
  String get phoneHint {
    return Intl.message(
      'Enter your phone number',
      name: 'phoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account? `
  String get noAccTitle1 {
    return Intl.message(
      'Don’t have an account? ',
      name: 'noAccTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get noAccTitle2 {
    return Intl.message(
      'Create New Account',
      name: 'noAccTitle2',
      desc: '',
      args: [],
    );
  }

  /// `OTP`
  String get otpTitle {
    return Intl.message('OTP', name: 'otpTitle', desc: '', args: []);
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `6-digits pin has been sent to your email address, `
  String get otpDesc1 {
    return Intl.message(
      '6-digits pin has been sent to your email address, ',
      name: 'otpDesc1',
      desc: '',
      args: [],
    );
  }

  /// `riead2562@gmail.com`
  String get otpDesc2 {
    return Intl.message(
      'riead2562@gmail.com',
      name: 'otpDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Didn’t receive code? `
  String get otpResendTitle1 {
    return Intl.message(
      'Didn’t receive code? ',
      name: 'otpResendTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get otpResendTitle2 {
    return Intl.message(
      'Resend Code',
      name: 'otpResendTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verifyButton {
    return Intl.message('Verify', name: 'verifyButton', desc: '', args: []);
  }

  /// `Forgot Password`
  String get fpAppBarTitle {
    return Intl.message(
      'Forgot Password',
      name: 'fpAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number below to receive your OTP number.`
  String get fpDesc1 {
    return Intl.message(
      'Please enter your phone number below to receive your OTP number.',
      name: 'fpDesc1',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get SendOtpTitle {
    return Intl.message('Send OTP', name: 'SendOtpTitle', desc: '', args: []);
  }

  /// `Home`
  String get navBarTitle1 {
    return Intl.message('Home', name: 'navBarTitle1', desc: '', args: []);
  }

  /// `My Booking`
  String get navBarTitle2 {
    return Intl.message('My Booking', name: 'navBarTitle2', desc: '', args: []);
  }

  /// `History`
  String get navBarTitle3 {
    return Intl.message('History', name: 'navBarTitle3', desc: '', args: []);
  }

  /// `Profile`
  String get navBarTitle4 {
    return Intl.message('Profile', name: 'navBarTitle4', desc: '', args: []);
  }

  /// `Hello 👋 `
  String get hello {
    return Intl.message('Hello 👋 ', name: 'hello', desc: '', args: []);
  }

  /// `Book your flight with confidence`
  String get bookFlightTitle {
    return Intl.message(
      'Book your flight with confidence',
      name: 'bookFlightTitle',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get fromTitle {
    return Intl.message('From', name: 'fromTitle', desc: '', args: []);
  }

  /// `To`
  String get toTitle {
    return Intl.message('To', name: 'toTitle', desc: '', args: []);
  }

  /// `One Ways`
  String get tab1 {
    return Intl.message('One Ways', name: 'tab1', desc: '', args: []);
  }

  /// `Round Trip`
  String get tab2 {
    return Intl.message('Round Trip', name: 'tab2', desc: '', args: []);
  }

  /// `Multicity`
  String get tab3 {
    return Intl.message('Multicity', name: 'tab3', desc: '', args: []);
  }

  /// `Date`
  String get dateTitle {
    return Intl.message('Date', name: 'dateTitle', desc: '', args: []);
  }

  /// `Passengers`
  String get travellerTitle {
    return Intl.message(
      'Passengers',
      name: 'travellerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Adults`
  String get adults {
    return Intl.message('Adults', name: 'adults', desc: '', args: []);
  }

  /// `Child`
  String get child {
    return Intl.message('Child', name: 'child', desc: '', args: []);
  }

  /// `Infants`
  String get infants {
    return Intl.message('Infants', name: 'infants', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Class`
  String get classTitle {
    return Intl.message('Class', name: 'classTitle', desc: '', args: []);
  }

  /// `Search Flight`
  String get searchFlight {
    return Intl.message(
      'Search Flight',
      name: 'searchFlight',
      desc: '',
      args: [],
    );
  }

  /// `Recent Searched`
  String get recentSearch {
    return Intl.message(
      'Recent Searched',
      name: 'recentSearch',
      desc: '',
      args: [],
    );
  }

  /// `Flight Booking Offers`
  String get flightOfferTitle {
    return Intl.message(
      'Flight Booking Offers',
      name: 'flightOfferTitle',
      desc: '',
      args: [],
    );
  }

  /// `Departure Date`
  String get departDate {
    return Intl.message(
      'Departure Date',
      name: 'departDate',
      desc: '',
      args: [],
    );
  }

  /// `Departure`
  String get departDateTitle {
    return Intl.message(
      'Departure',
      name: 'departDateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Return Date`
  String get returnDate {
    return Intl.message('Return Date', name: 'returnDate', desc: '', args: []);
  }

  /// `Return`
  String get returnDateTitle {
    return Intl.message('Return', name: 'returnDateTitle', desc: '', args: []);
  }

  /// `Add Fight`
  String get addFightButton {
    return Intl.message(
      'Add Fight',
      name: 'addFightButton',
      desc: '',
      args: [],
    );
  }

  /// `Where from?`
  String get searchScreenTitle {
    return Intl.message(
      'Where from?',
      name: 'searchScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Current Location`
  String get currentLocation {
    return Intl.message(
      'Current Location',
      name: 'currentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Use Current Location`
  String get useCurrentLocation {
    return Intl.message(
      'Use Current Location',
      name: 'useCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Recent Places`
  String get recentPlaceTitle {
    return Intl.message(
      'Recent Places',
      name: 'recentPlaceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message('Filter', name: 'filter', desc: '', args: []);
  }

  /// `Departure`
  String get departure {
    return Intl.message('Departure', name: 'departure', desc: '', args: []);
  }

  /// `Arrival`
  String get arrival {
    return Intl.message('Arrival', name: 'arrival', desc: '', args: []);
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message('Cancel', name: 'cancelButton', desc: '', args: []);
  }

  /// `Apply`
  String get applyButton {
    return Intl.message('Apply', name: 'applyButton', desc: '', args: []);
  }

  /// `Flight Details`
  String get flightDetails {
    return Intl.message(
      'Flight Details',
      name: 'flightDetails',
      desc: '',
      args: [],
    );
  }

  /// `Onward`
  String get onwardTitle {
    return Intl.message('Onward', name: 'onwardTitle', desc: '', args: []);
  }

  /// `Return`
  String get returnTitle {
    return Intl.message('Return', name: 'returnTitle', desc: '', args: []);
  }

  /// `Select Services`
  String get selectService {
    return Intl.message(
      'Select Services',
      name: 'selectService',
      desc: '',
      args: [],
    );
  }

  /// `Baggage Policy`
  String get bagPolicyTitle {
    return Intl.message(
      'Baggage Policy',
      name: 'bagPolicyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation Refund Policy`
  String get refundPolicyTitle {
    return Intl.message(
      'Cancellation Refund Policy',
      name: 'refundPolicyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter Promocode`
  String get promoCodeTitle {
    return Intl.message(
      'Enter Promocode',
      name: 'promoCodeTitle',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAllButton {
    return Intl.message('View All', name: 'viewAllButton', desc: '', args: []);
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Select Gender`
  String get selectGenderTitle {
    return Intl.message(
      'Select Gender',
      name: 'selectGenderTitle',
      desc: '',
      args: [],
    );
  }

  /// `First & Middle Name`
  String get nameTitle {
    return Intl.message(
      'First & Middle Name',
      name: 'nameTitle',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastNameTitle {
    return Intl.message('Last Name', name: 'lastNameTitle', desc: '', args: []);
  }

  /// `Enter Last Name`
  String get lastNameHint {
    return Intl.message(
      'Enter Last Name',
      name: 'lastNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Contact Information`
  String get contactInfoTitle {
    return Intl.message(
      'Contact Information',
      name: 'contactInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get paymentTitle {
    return Intl.message('Payment', name: 'paymentTitle', desc: '', args: []);
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Your payment cards`
  String get paymentCardTitle {
    return Intl.message(
      'Your payment cards',
      name: 'paymentCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add New Card`
  String get addNewCardTitle {
    return Intl.message(
      'Add New Card',
      name: 'addNewCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get DoneButton {
    return Intl.message('Done', name: 'DoneButton', desc: '', args: []);
  }

  /// `Ticket Status`
  String get ticketStatusTitle {
    return Intl.message(
      'Ticket Status',
      name: 'ticketStatusTitle',
      desc: '',
      args: [],
    );
  }

  /// `My Booking`
  String get myBookingTitle {
    return Intl.message(
      'My Booking',
      name: 'myBookingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message('Profile', name: 'profileTitle', desc: '', args: []);
  }

  /// `Setting`
  String get settingTitle {
    return Intl.message('Setting', name: 'settingTitle', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `English`
  String get englishTitle {
    return Intl.message('English', name: 'englishTitle', desc: '', args: []);
  }

  /// `Notification`
  String get notificationTitle {
    return Intl.message(
      'Notification',
      name: 'notificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message('Paid', name: 'paid', desc: '', args: []);
  }

  /// `Convenience Fee Added`
  String get convenienceFee {
    return Intl.message(
      'Convenience Fee Added',
      name: 'convenienceFee',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `{name} (Male)`
  String passengerMale(Object name) {
    return Intl.message(
      '$name (Male)',
      name: 'passengerMale',
      desc: 'Passenger name with male gender',
      args: [name],
    );
  }

  /// `My Profile`
  String get profileMyProfile {
    return Intl.message(
      'My Profile',
      name: 'profileMyProfile',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get profileSetting {
    return Intl.message('Setting', name: 'profileSetting', desc: '', args: []);
  }

  /// `Payments`
  String get profilePayments {
    return Intl.message(
      'Payments',
      name: 'profilePayments',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get profilePrivacy {
    return Intl.message(
      'Privacy Policy',
      name: 'profilePrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Share App`
  String get profileShare {
    return Intl.message('Share App', name: 'profileShare', desc: '', args: []);
  }

  /// `Log Out`
  String get profileLogout {
    return Intl.message('Log Out', name: 'profileLogout', desc: '', args: []);
  }

  /// `My Profile`
  String get myProfileTitle {
    return Intl.message(
      'My Profile',
      name: 'myProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get editButton {
    return Intl.message('Edit', name: 'editButton', desc: '', args: []);
  }

  /// `Full Name`
  String get fullNameLabel {
    return Intl.message('Full Name', name: 'fullNameLabel', desc: '', args: []);
  }

  /// `Currency`
  String get currencyTitle {
    return Intl.message('Currency', name: 'currencyTitle', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicyTitle {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicyTitle',
      desc: '',
      args: [],
    );
  }

  /// `At H24 Voyages, we are committed to protecting your privacy and ensuring that your personal information is handled in a safe and responsible manner.`
  String get privacyPolicyIntroduction {
    return Intl.message(
      'At H24 Voyages, we are committed to protecting your privacy and ensuring that your personal information is handled in a safe and responsible manner.',
      name: 'privacyPolicyIntroduction',
      desc: '',
      args: [],
    );
  }

  /// `Information We Collect`
  String get privacyInfoCollectionTitle {
    return Intl.message(
      'Information We Collect',
      name: 'privacyInfoCollectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `We collect personal information when you make a booking or register on our site...`
  String get privacyInfoCollection {
    return Intl.message(
      'We collect personal information when you make a booking or register on our site...',
      name: 'privacyInfoCollection',
      desc: '',
      args: [],
    );
  }

  /// `How We Use Your Information`
  String get privacyUseTitle {
    return Intl.message(
      'How We Use Your Information',
      name: 'privacyUseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your data is used to process bookings, communicate updates, and provide customer support...`
  String get privacyUse {
    return Intl.message(
      'Your data is used to process bookings, communicate updates, and provide customer support...',
      name: 'privacyUse',
      desc: '',
      args: [],
    );
  }

  /// `Sharing of Information`
  String get privacySharingTitle {
    return Intl.message(
      'Sharing of Information',
      name: 'privacySharingTitle',
      desc: '',
      args: [],
    );
  }

  /// `We may share data with partners such as airlines, hotels, and payment processors as necessary...`
  String get privacySharing {
    return Intl.message(
      'We may share data with partners such as airlines, hotels, and payment processors as necessary...',
      name: 'privacySharing',
      desc: '',
      args: [],
    );
  }

  /// `Security of Your Data`
  String get privacySecurityTitle {
    return Intl.message(
      'Security of Your Data',
      name: 'privacySecurityTitle',
      desc: '',
      args: [],
    );
  }

  /// `We implement security measures to protect your data, but no transmission over the internet can be guaranteed secure.`
  String get privacySecurity {
    return Intl.message(
      'We implement security measures to protect your data, but no transmission over the internet can be guaranteed secure.',
      name: 'privacySecurity',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get privacyContactTitle {
    return Intl.message(
      'Contact Us',
      name: 'privacyContactTitle',
      desc: '',
      args: [],
    );
  }

  /// `If you have any questions about this Privacy Policy, please contact us at info@h24voyages.com.`
  String get privacyContact {
    return Intl.message(
      'If you have any questions about this Privacy Policy, please contact us at info@h24voyages.com.',
      name: 'privacyContact',
      desc: '',
      args: [],
    );
  }

  /// `Economy`
  String get classEconomy {
    return Intl.message('Economy', name: 'classEconomy', desc: '', args: []);
  }

  /// `Business`
  String get classBusiness {
    return Intl.message('Business', name: 'classBusiness', desc: '', args: []);
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message('Total Price', name: 'totalPrice', desc: '', args: []);
  }

  /// `Proceed to Book`
  String get proceedToBook {
    return Intl.message(
      'Proceed to Book',
      name: 'proceedToBook',
      desc: '',
      args: [],
    );
  }

  /// `{hours} in flight`
  String nonStop(Object hours) {
    return Intl.message(
      '$hours in flight',
      name: 'nonStop',
      desc: '',
      args: [hours],
    );
  }

  /// `{count} stop`
  String stopCount(Object count) {
    return Intl.message(
      '$count stop',
      name: 'stopCount',
      desc: '',
      args: [count],
    );
  }

  /// `{hours} in flight`
  String inFlight(Object hours) {
    return Intl.message(
      '$hours in flight',
      name: 'inFlight',
      desc: '',
      args: [hours],
    );
  }

  /// `Sign in to save`
  String get welcomeTitle {
    return Intl.message(
      'Sign in to save',
      name: 'welcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to save at least\n10% with a free h24voyages membership`
  String get welcomeSubtitle {
    return Intl.message(
      'Sign in to save at least\n10% with a free h24voyages membership',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Continue with email`
  String get welcomeContinueEmail {
    return Intl.message(
      'Continue with email',
      name: 'welcomeContinueEmail',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get welcomeContinueGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'welcomeContinueGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Continue without signing in`
  String get welcomeSkipLogin {
    return Intl.message(
      'Continue without signing in',
      name: 'welcomeSkipLogin',
      desc: '',
      args: [],
    );
  }

  /// `By creating or signing in to an account, you agree to`
  String get welcomeTermsIntro {
    return Intl.message(
      'By creating or signing in to an account, you agree to',
      name: 'welcomeTermsIntro',
      desc: '',
      args: [],
    );
  }

  /// `our `
  String get welcomeTermsOur {
    return Intl.message('our ', name: 'welcomeTermsOur', desc: '', args: []);
  }

  /// `terms and conditions`
  String get welcomeTermsConditions {
    return Intl.message(
      'terms and conditions',
      name: 'welcomeTermsConditions',
      desc: '',
      args: [],
    );
  }

  /// ` and our `
  String get welcomeTermsAnd {
    return Intl.message(
      ' and our ',
      name: 'welcomeTermsAnd',
      desc: '',
      args: [],
    );
  }

  /// `privacy policy`
  String get welcomePrivacyPolicy {
    return Intl.message(
      'privacy policy',
      name: 'welcomePrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `All rights reserved. Copyright- h24voyages`
  String get welcomeCopyright {
    return Intl.message(
      'All rights reserved. Copyright- h24voyages',
      name: 'welcomeCopyright',
      desc: '',
      args: [],
    );
  }

  /// `Sign in or create an account`
  String get signUpTitle {
    return Intl.message(
      'Sign in or create an account',
      name: 'signUpTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with your h24voyages account\nand access our services.`
  String get signUpSubtitle {
    return Intl.message(
      'Sign in with your h24voyages account\nand access our services.',
      name: 'signUpSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Email address`
  String get signUpEmailLabel {
    return Intl.message(
      'Email address',
      name: 'signUpEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `email@email.com`
  String get signUpEmailHint {
    return Intl.message(
      'email@email.com',
      name: 'signUpEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address`
  String get signUpEmailEmpty {
    return Intl.message(
      'Please enter your email address',
      name: 'signUpEmailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get signUpEmailInvalid {
    return Intl.message(
      'Please enter a valid email address',
      name: 'signUpEmailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Login error`
  String get signUpLoginError {
    return Intl.message(
      'Login error',
      name: 'signUpLoginError',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUpRegister {
    return Intl.message('Sign up', name: 'signUpRegister', desc: '', args: []);
  }

  /// `By signing in, you agree to`
  String get signUpTermsShort {
    return Intl.message(
      'By signing in, you agree to',
      name: 'signUpTermsShort',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get signUpError {
    return Intl.message('Error', name: 'signUpError', desc: '', args: []);
  }

  /// `Sign up`
  String get registerTitle {
    return Intl.message('Sign up', name: 'registerTitle', desc: '', args: []);
  }

  /// `Sign up now to h24voyages\nand access our services.`
  String get registerSubtitle {
    return Intl.message(
      'Sign up now to h24voyages\nand access our services.',
      name: 'registerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get registerFirstName {
    return Intl.message(
      'First name',
      name: 'registerFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get registerLastName {
    return Intl.message(
      'Last name',
      name: 'registerLastName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get registerEmail {
    return Intl.message('Email', name: 'registerEmail', desc: '', args: []);
  }

  /// `Password`
  String get registerPassword {
    return Intl.message(
      'Password',
      name: 'registerPassword',
      desc: '',
      args: [],
    );
  }

  /// `Registration error`
  String get registerError {
    return Intl.message(
      'Registration error',
      name: 'registerError',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get registerUnknownError {
    return Intl.message(
      'Unknown error',
      name: 'registerUnknownError',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get registerFieldRequired {
    return Intl.message(
      'This field is required',
      name: 'registerFieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password required`
  String get registerPasswordRequired {
    return Intl.message(
      'Password required',
      name: 'registerPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `At least 6 characters`
  String get registerPasswordMinLength {
    return Intl.message(
      'At least 6 characters',
      name: 'registerPasswordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `A new code has been sent to {email}`
  String otpCodeSent(Object email) {
    return Intl.message(
      'A new code has been sent to $email',
      name: 'otpCodeSent',
      desc: '',
      args: [email],
    );
  }

  /// `Unable to resend code. Try again.`
  String get otpResendFailed {
    return Intl.message(
      'Unable to resend code. Try again.',
      name: 'otpResendFailed',
      desc: '',
      args: [],
    );
  }

  /// `Error resending code.`
  String get otpResendError {
    return Intl.message(
      'Error resending code.',
      name: 'otpResendError',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect code, please try again`
  String get otpWrongCode {
    return Intl.message(
      'Incorrect code, please try again',
      name: 'otpWrongCode',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful! Please sign in.`
  String get otpRegistrationSuccess {
    return Intl.message(
      'Registration successful! Please sign in.',
      name: 'otpRegistrationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Verify your email address to sign in`
  String get otpVerifyTitle {
    return Intl.message(
      'Verify your email address to sign in',
      name: 'otpVerifyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Verify your email address`
  String get otpVerifyTitleShort {
    return Intl.message(
      'Verify your email address',
      name: 'otpVerifyTitleShort',
      desc: '',
      args: [],
    );
  }

  /// `We sent a verification code to:\n`
  String get otpCodeSentTo {
    return Intl.message(
      'We sent a verification code to:\n',
      name: 'otpCodeSentTo',
      desc: '',
      args: [],
    );
  }

  /// `Code sent to: `
  String get otpCodeSentToShort {
    return Intl.message(
      'Code sent to: ',
      name: 'otpCodeSentToShort',
      desc: '',
      args: [],
    );
  }

  /// `email address`
  String get otpEmailFallback {
    return Intl.message(
      'email address',
      name: 'otpEmailFallback',
      desc: '',
      args: [],
    );
  }

  /// `\nPlease enter it to continue.`
  String get otpEnterToContinue {
    return Intl.message(
      '\nPlease enter it to continue.',
      name: 'otpEnterToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Verifying...`
  String get otpVerifying {
    return Intl.message(
      'Verifying...',
      name: 'otpVerifying',
      desc: '',
      args: [],
    );
  }

  /// `Verify email address`
  String get otpVerifyEmail {
    return Intl.message(
      'Verify email address',
      name: 'otpVerifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get navSearch {
    return Intl.message('Search', name: 'navSearch', desc: '', args: []);
  }

  /// `Bookings`
  String get navBookings {
    return Intl.message('Bookings', name: 'navBookings', desc: '', args: []);
  }

  /// `Support`
  String get navSupport {
    return Intl.message('Support', name: 'navSupport', desc: '', args: []);
  }

  /// `My account`
  String get navMyAccount {
    return Intl.message('My account', name: 'navMyAccount', desc: '', args: []);
  }

  /// `Hello, {name}`
  String homeGreeting(Object name) {
    return Intl.message(
      'Hello, $name',
      name: 'homeGreeting',
      desc: '',
      args: [name],
    );
  }

  /// `Welcome`
  String get homeWelcome {
    return Intl.message('Welcome', name: 'homeWelcome', desc: '', args: []);
  }

  /// `Book your flight`
  String get homeBookFlight {
    return Intl.message(
      'Book your flight',
      name: 'homeBookFlight',
      desc: '',
      args: [],
    );
  }

  /// `Departure place`
  String get homeDeparturePlace {
    return Intl.message(
      'Departure place',
      name: 'homeDeparturePlace',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get homeDestination {
    return Intl.message(
      'Destination',
      name: 'homeDestination',
      desc: '',
      args: [],
    );
  }

  /// `Select an airport`
  String get homeSelectAirport {
    return Intl.message(
      'Select an airport',
      name: 'homeSelectAirport',
      desc: '',
      args: [],
    );
  }

  /// `Departure`
  String get homeDeparture {
    return Intl.message('Departure', name: 'homeDeparture', desc: '', args: []);
  }

  /// `Return`
  String get homeReturn {
    return Intl.message('Return', name: 'homeReturn', desc: '', args: []);
  }

  /// `Passenger & Class`
  String get homePassengerClass {
    return Intl.message(
      'Passenger & Class',
      name: 'homePassengerClass',
      desc: '',
      args: [],
    );
  }

  /// `{count} Passenger(s)`
  String homePassengerCount(Object count) {
    return Intl.message(
      '$count Passenger(s)',
      name: 'homePassengerCount',
      desc: '',
      args: [count],
    );
  }

  /// `Direct flights`
  String get homeDirectFlights {
    return Intl.message(
      'Direct flights',
      name: 'homeDirectFlights',
      desc: '',
      args: [],
    );
  }

  /// `With baggage`
  String get homeWithBaggage {
    return Intl.message(
      'With baggage',
      name: 'homeWithBaggage',
      desc: '',
      args: [],
    );
  }

  /// `Class`
  String get homeClassLabel {
    return Intl.message('Class', name: 'homeClassLabel', desc: '', args: []);
  }

  /// `Economy`
  String get homeClassEconomy {
    return Intl.message(
      'Economy',
      name: 'homeClassEconomy',
      desc: '',
      args: [],
    );
  }

  /// `Premium Economy`
  String get homeClassPremiumEconomy {
    return Intl.message(
      'Premium Economy',
      name: 'homeClassPremiumEconomy',
      desc: '',
      args: [],
    );
  }

  /// `Business Class`
  String get homeClassBusiness {
    return Intl.message(
      'Business Class',
      name: 'homeClassBusiness',
      desc: '',
      args: [],
    );
  }

  /// `First Class`
  String get homeClassFirst {
    return Intl.message(
      'First Class',
      name: 'homeClassFirst',
      desc: '',
      args: [],
    );
  }

  /// `Economy`
  String get homeClassEconomyShort {
    return Intl.message(
      'Economy',
      name: 'homeClassEconomyShort',
      desc: '',
      args: [],
    );
  }

  /// `Business`
  String get homeClassBusinessShort {
    return Intl.message(
      'Business',
      name: 'homeClassBusinessShort',
      desc: '',
      args: [],
    );
  }

  /// `Prem. Economy`
  String get homeClassPremiumEconomyShort {
    return Intl.message(
      'Prem. Economy',
      name: 'homeClassPremiumEconomyShort',
      desc: '',
      args: [],
    );
  }

  /// `First`
  String get homeClassFirstShort {
    return Intl.message(
      'First',
      name: 'homeClassFirstShort',
      desc: '',
      args: [],
    );
  }

  /// `12 years and over`
  String get homeAdultsAge {
    return Intl.message(
      '12 years and over',
      name: 'homeAdultsAge',
      desc: '',
      args: [],
    );
  }

  /// `2 to 11 years at the time of travel`
  String get homeChildAge {
    return Intl.message(
      '2 to 11 years at the time of travel',
      name: 'homeChildAge',
      desc: '',
      args: [],
    );
  }

  /// `Under 2 years at the time of travel`
  String get homeInfantAge {
    return Intl.message(
      'Under 2 years at the time of travel',
      name: 'homeInfantAge',
      desc: '',
      args: [],
    );
  }

  /// `Young`
  String get homeYoung {
    return Intl.message('Young', name: 'homeYoung', desc: '', args: []);
  }

  /// `Between 12 and 24 years old, domestic flights only`
  String get homeYoungTooltip {
    return Intl.message(
      'Between 12 and 24 years old, domestic flights only',
      name: 'homeYoungTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Senior`
  String get homeSenior {
    return Intl.message('Senior', name: 'homeSenior', desc: '', args: []);
  }

  /// `Men 55+ and women 60+, AIR ALGERIE to FRANCE only`
  String get homeSeniorTooltip {
    return Intl.message(
      'Men 55+ and women 60+, AIR ALGERIE to FRANCE only',
      name: 'homeSeniorTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Children and infants must be accompanied by an adult during the flight.`
  String get homePassengerNote {
    return Intl.message(
      'Children and infants must be accompanied by an adult during the flight.',
      name: 'homePassengerNote',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get homeDone {
    return Intl.message('Done', name: 'homeDone', desc: '', args: []);
  }

  /// `Searching...`
  String get homeSearching {
    return Intl.message(
      'Searching...',
      name: 'homeSearching',
      desc: '',
      args: [],
    );
  }

  /// `Search flights`
  String get homeSearchFlights {
    return Intl.message(
      'Search flights',
      name: 'homeSearchFlights',
      desc: '',
      args: [],
    );
  }

  /// `Search error`
  String get homeSearchError {
    return Intl.message(
      'Search error',
      name: 'homeSearchError',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String homeErrorPrefix(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'homeErrorPrefix',
      desc: '',
      args: [error],
    );
  }

  /// `Please select departure and arrival airports.`
  String get homeSelectAirportsError {
    return Intl.message(
      'Please select departure and arrival airports.',
      name: 'homeSelectAirportsError',
      desc: '',
      args: [],
    );
  }

  /// `Please select a departure date.`
  String get homeSelectDepartureDate {
    return Intl.message(
      'Please select a departure date.',
      name: 'homeSelectDepartureDate',
      desc: '',
      args: [],
    );
  }

  /// `Please select a return date.`
  String get homeSelectReturnDate {
    return Intl.message(
      'Please select a return date.',
      name: 'homeSelectReturnDate',
      desc: '',
      args: [],
    );
  }

  /// `Please add at least 2 flights for multi-destination search.`
  String get homeMultiMinFlights {
    return Intl.message(
      'Please add at least 2 flights for multi-destination search.',
      name: 'homeMultiMinFlights',
      desc: '',
      args: [],
    );
  }

  /// `Please select departure and arrival airports for flight 1.`
  String get homeSelectAirportsFlight1 {
    return Intl.message(
      'Please select departure and arrival airports for flight 1.',
      name: 'homeSelectAirportsFlight1',
      desc: '',
      args: [],
    );
  }

  /// `Please select a departure date for flight 1.`
  String get homeSelectDateFlight1 {
    return Intl.message(
      'Please select a departure date for flight 1.',
      name: 'homeSelectDateFlight1',
      desc: '',
      args: [],
    );
  }

  /// `Please select airports for flight {n}.`
  String homeSelectAirportsFlightN(Object n) {
    return Intl.message(
      'Please select airports for flight $n.',
      name: 'homeSelectAirportsFlightN',
      desc: '',
      args: [n],
    );
  }

  /// `Please select a date for flight {n}.`
  String homeSelectDateFlightN(Object n) {
    return Intl.message(
      'Please select a date for flight $n.',
      name: 'homeSelectDateFlightN',
      desc: '',
      args: [n],
    );
  }

  /// `Get the best price`
  String get homeAdvantageTitle1 {
    return Intl.message(
      'Get the best price',
      name: 'homeAdvantageTitle1',
      desc: '',
      args: [],
    );
  }

  /// `every time`
  String get homeAdvantageSubtitle1 {
    return Intl.message(
      'every time',
      name: 'homeAdvantageSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `24/7 Customer service`
  String get homeAdvantageTitle2 {
    return Intl.message(
      '24/7 Customer service',
      name: 'homeAdvantageTitle2',
      desc: '',
      args: [],
    );
  }

  /// `at your service`
  String get homeAdvantageSubtitle2 {
    return Intl.message(
      'at your service',
      name: 'homeAdvantageSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Our advantages`
  String get homeAdvantagesSection {
    return Intl.message(
      'Our advantages',
      name: 'homeAdvantagesSection',
      desc: '',
      args: [],
    );
  }

  /// `Our offers for you`
  String get homeOffersSection {
    return Intl.message(
      'Our offers for you',
      name: 'homeOffersSection',
      desc: '',
      args: [],
    );
  }

  /// `Departure`
  String get homeDefaultDeparture {
    return Intl.message(
      'Departure',
      name: 'homeDefaultDeparture',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get homeDefaultDestination {
    return Intl.message(
      'Destination',
      name: 'homeDefaultDestination',
      desc: '',
      args: [],
    );
  }

  /// `Country, city or airport`
  String get searchSheetHint {
    return Intl.message(
      'Country, city or airport',
      name: 'searchSheetHint',
      desc: '',
      args: [],
    );
  }

  /// `Recent`
  String get searchSheetRecent {
    return Intl.message(
      'Recent',
      name: 'searchSheetRecent',
      desc: '',
      args: [],
    );
  }

  /// `Search results`
  String get searchSheetResults {
    return Intl.message(
      'Search results',
      name: 'searchSheetResults',
      desc: '',
      args: [],
    );
  }

  /// `Travel dates`
  String get datePickerTitleRoundTrip {
    return Intl.message(
      'Travel dates',
      name: 'datePickerTitleRoundTrip',
      desc: '',
      args: [],
    );
  }

  /// `Travel date`
  String get datePickerTitleOneWay {
    return Intl.message(
      'Travel date',
      name: 'datePickerTitleOneWay',
      desc: '',
      args: [],
    );
  }

  /// `Select a date`
  String get datePickerSelectDate {
    return Intl.message(
      'Select a date',
      name: 'datePickerSelectDate',
      desc: '',
      args: [],
    );
  }

  /// `Trip duration: `
  String get datePickerTripDuration {
    return Intl.message(
      'Trip duration: ',
      name: 'datePickerTripDuration',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get datePickerDay {
    return Intl.message('day', name: 'datePickerDay', desc: '', args: []);
  }

  /// `days`
  String get datePickerDays {
    return Intl.message('days', name: 'datePickerDays', desc: '', args: []);
  }

  /// `Confirm`
  String get datePickerConfirm {
    return Intl.message(
      'Confirm',
      name: 'datePickerConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Mon.`
  String get datePickerMon {
    return Intl.message('Mon.', name: 'datePickerMon', desc: '', args: []);
  }

  /// `Tue.`
  String get datePickerTue {
    return Intl.message('Tue.', name: 'datePickerTue', desc: '', args: []);
  }

  /// `Wed.`
  String get datePickerWed {
    return Intl.message('Wed.', name: 'datePickerWed', desc: '', args: []);
  }

  /// `Thu.`
  String get datePickerThu {
    return Intl.message('Thu.', name: 'datePickerThu', desc: '', args: []);
  }

  /// `Fri.`
  String get datePickerFri {
    return Intl.message('Fri.', name: 'datePickerFri', desc: '', args: []);
  }

  /// `Sat.`
  String get datePickerSat {
    return Intl.message('Sat.', name: 'datePickerSat', desc: '', args: []);
  }

  /// `Sun.`
  String get datePickerSun {
    return Intl.message('Sun.', name: 'datePickerSun', desc: '', args: []);
  }

  /// `Results`
  String get loadingResults {
    return Intl.message('Results', name: 'loadingResults', desc: '', args: []);
  }

  /// ` awaits you!`
  String get loadingAwaitsYou {
    return Intl.message(
      ' awaits you!',
      name: 'loadingAwaitsYou',
      desc: '',
      args: [],
    );
  }

  /// `Please wait...`
  String get loadingPleaseWait {
    return Intl.message(
      'Please wait...',
      name: 'loadingPleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Searching for flights`
  String get loadingSearchingFlights {
    return Intl.message(
      'Searching for flights',
      name: 'loadingSearchingFlights',
      desc: '',
      args: [],
    );
  }

  /// `CONNECTING TO`
  String get loadingConnectingTo {
    return Intl.message(
      'CONNECTING TO',
      name: 'loadingConnectingTo',
      desc: '',
      args: [],
    );
  }

  /// `providers`
  String get loadingProviders {
    return Intl.message(
      'providers',
      name: 'loadingProviders',
      desc: '',
      args: [],
    );
  }

  /// `RESULTS`
  String get loadingResultsLabel {
    return Intl.message(
      'RESULTS',
      name: 'loadingResultsLabel',
      desc: '',
      args: [],
    );
  }

  /// `flights found`
  String get loadingFlightsFound {
    return Intl.message(
      'flights found',
      name: 'loadingFlightsFound',
      desc: '',
      args: [],
    );
  }

  /// `Meanwhile`
  String get loadingMeanwhile {
    return Intl.message(
      'Meanwhile',
      name: 'loadingMeanwhile',
      desc: '',
      args: [],
    );
  }

  /// `Don't forget! Save up to `
  String get loadingPromoText1 {
    return Intl.message(
      'Don\'t forget! Save up to ',
      name: 'loadingPromoText1',
      desc: '',
      args: [],
    );
  }

  /// ` on your `
  String get loadingPromoText2 {
    return Intl.message(
      ' on your ',
      name: 'loadingPromoText2',
      desc: '',
      args: [],
    );
  }

  /// `accommodation`
  String get loadingPromoAccommodation {
    return Intl.message(
      'accommodation',
      name: 'loadingPromoAccommodation',
      desc: '',
      args: [],
    );
  }

  /// `Search error: {error}`
  String loadingSearchError(Object error) {
    return Intl.message(
      'Search error: $error',
      name: 'loadingSearchError',
      desc: '',
      args: [error],
    );
  }

  /// `No flights available for these criteria.\nTry other dates or destinations.`
  String get searchErrorNoFlights {
    return Intl.message(
      'No flights available for these criteria.\nTry other dates or destinations.',
      name: 'searchErrorNoFlights',
      desc: '',
      args: [],
    );
  }

  /// `The server is taking too long to respond.\nPlease try again in a moment.`
  String get searchErrorTimeout {
    return Intl.message(
      'The server is taking too long to respond.\nPlease try again in a moment.',
      name: 'searchErrorTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Internet connection unavailable.\nCheck your connection and try again.`
  String get searchErrorNoInternet {
    return Intl.message(
      'Internet connection unavailable.\nCheck your connection and try again.',
      name: 'searchErrorNoInternet',
      desc: '',
      args: [],
    );
  }

  /// `The search service is temporarily unavailable.\nPlease try again later.`
  String get searchErrorServer {
    return Intl.message(
      'The search service is temporarily unavailable.\nPlease try again later.',
      name: 'searchErrorServer',
      desc: '',
      args: [],
    );
  }

  /// `Your session has expired.\nPlease log in again and retry.`
  String get searchErrorSessionExpired {
    return Intl.message(
      'Your session has expired.\nPlease log in again and retry.',
      name: 'searchErrorSessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `Access denied to the search service.\nPlease log in again.`
  String get searchErrorForbidden {
    return Intl.message(
      'Access denied to the search service.\nPlease log in again.',
      name: 'searchErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `The search service is unavailable.\nPlease try again later.`
  String get searchErrorNotFound {
    return Intl.message(
      'The search service is unavailable.\nPlease try again later.',
      name: 'searchErrorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Too many searches in a short time.\nPlease wait before trying again.`
  String get searchErrorTooMany {
    return Intl.message(
      'Too many searches in a short time.\nPlease wait before trying again.',
      name: 'searchErrorTooMany',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred.\nPlease try again or modify your criteria.`
  String get searchErrorUnexpected {
    return Intl.message(
      'An unexpected error occurred.\nPlease try again or modify your criteria.',
      name: 'searchErrorUnexpected',
      desc: '',
      args: [],
    );
  }

  /// `Loading flights...`
  String get searchLoadingFlights {
    return Intl.message(
      'Loading flights...',
      name: 'searchLoadingFlights',
      desc: '',
      args: [],
    );
  }

  /// `No flights match your filters`
  String get searchNoFlightsForFilters {
    return Intl.message(
      'No flights match your filters',
      name: 'searchNoFlightsForFilters',
      desc: '',
      args: [],
    );
  }

  /// `Try modifying or resetting\nyour filters to see more results`
  String get searchTryModifyFilters {
    return Intl.message(
      'Try modifying or resetting\nyour filters to see more results',
      name: 'searchTryModifyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Reset filters`
  String get searchResetFilters {
    return Intl.message(
      'Reset filters',
      name: 'searchResetFilters',
      desc: '',
      args: [],
    );
  }

  /// `Page {current} / {total} - Scroll for more`
  String searchPageInfo(Object current, Object total) {
    return Intl.message(
      'Page $current / $total - Scroll for more',
      name: 'searchPageInfo',
      desc: '',
      args: [current, total],
    );
  }

  /// `Scroll to load more flights`
  String get searchScrollForMore {
    return Intl.message(
      'Scroll to load more flights',
      name: 'searchScrollForMore',
      desc: '',
      args: [],
    );
  }

  /// `Stay duration: `
  String get searchStayDuration {
    return Intl.message(
      'Stay duration: ',
      name: 'searchStayDuration',
      desc: '',
      args: [],
    );
  }

  /// `Search unavailable`
  String get searchUnavailable {
    return Intl.message(
      'Search unavailable',
      name: 'searchUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `No flights found`
  String get searchNoFlightsFound {
    return Intl.message(
      'No flights found',
      name: 'searchNoFlightsFound',
      desc: '',
      args: [],
    );
  }

  /// `Try modifying your dates or\nyour search criteria`
  String get searchTryModifyDates {
    return Intl.message(
      'Try modifying your dates or\nyour search criteria',
      name: 'searchTryModifyDates',
      desc: '',
      args: [],
    );
  }

  /// `Edit search`
  String get searchEditSearch {
    return Intl.message(
      'Edit search',
      name: 'searchEditSearch',
      desc: '',
      args: [],
    );
  }

  /// `Booking`
  String get detailBookingTitle {
    return Intl.message(
      'Booking',
      name: 'detailBookingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Fare offered by the airline`
  String get detailAirlineFare {
    return Intl.message(
      'Fare offered by the airline',
      name: 'detailAirlineFare',
      desc: '',
      args: [],
    );
  }

  /// `Cabin baggage`
  String get detailCabinBaggage {
    return Intl.message(
      'Cabin baggage',
      name: 'detailCabinBaggage',
      desc: '',
      args: [],
    );
  }

  /// `Seat selection`
  String get detailSeatSelection {
    return Intl.message(
      'Seat selection',
      name: 'detailSeatSelection',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get detailAvailable {
    return Intl.message(
      'Available',
      name: 'detailAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation`
  String get detailCancellation {
    return Intl.message(
      'Cancellation',
      name: 'detailCancellation',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation fees from {amount} {currency}`
  String detailCancellationFees(Object amount, Object currency) {
    return Intl.message(
      'Cancellation fees from $amount $currency',
      name: 'detailCancellationFees',
      desc: '',
      args: [amount, currency],
    );
  }

  /// `Checked baggage`
  String get detailCheckedBaggage {
    return Intl.message(
      'Checked baggage',
      name: 'detailCheckedBaggage',
      desc: '',
      args: [],
    );
  }

  /// `Meals`
  String get detailMeals {
    return Intl.message('Meals', name: 'detailMeals', desc: '', args: []);
  }

  /// `Date change`
  String get detailDateChange {
    return Intl.message(
      'Date change',
      name: 'detailDateChange',
      desc: '',
      args: [],
    );
  }

  /// `Date change fees from {amount} {currency}`
  String detailDateChangeFees(Object amount, Object currency) {
    return Intl.message(
      'Date change fees from $amount $currency',
      name: 'detailDateChangeFees',
      desc: '',
      args: [amount, currency],
    );
  }

  /// `{duration} in flight`
  String detailInFlight(Object duration) {
    return Intl.message(
      '$duration in flight',
      name: 'detailInFlight',
      desc: '',
      args: [duration],
    );
  }

  /// `Overnight layover in {city}`
  String detailOvernightLayover(Object city) {
    return Intl.message(
      'Overnight layover in $city',
      name: 'detailOvernightLayover',
      desc: '',
      args: [city],
    );
  }

  /// `{stops} stop | {duration} | {flightClass}`
  String detailStopInfo(Object stops, Object duration, Object flightClass) {
    return Intl.message(
      '$stops stop | $duration | $flightClass',
      name: 'detailStopInfo',
      desc: '',
      args: [stops, duration, flightClass],
    );
  }

  /// `Non-stop | {duration} | {flightClass}`
  String detailNonStopInfo(Object duration, Object flightClass) {
    return Intl.message(
      'Non-stop | $duration | $flightClass',
      name: 'detailNonStopInfo',
      desc: '',
      args: [duration, flightClass],
    );
  }

  /// `Recommended`
  String get cardRecommended {
    return Intl.message(
      'Recommended',
      name: 'cardRecommended',
      desc: '',
      args: [],
    );
  }

  /// `Book`
  String get cardBook {
    return Intl.message('Book', name: 'cardBook', desc: '', args: []);
  }

  /// `Direct`
  String get cardDirect {
    return Intl.message('Direct', name: 'cardDirect', desc: '', args: []);
  }

  /// `{count} stop`
  String cardStop(Object count) {
    return Intl.message(
      '$count stop',
      name: 'cardStop',
      desc: '',
      args: [count],
    );
  }

  /// `{count} stops`
  String cardStops(Object count) {
    return Intl.message(
      '$count stops',
      name: 'cardStops',
      desc: '',
      args: [count],
    );
  }

  /// `{count} stp`
  String cardStopShort(Object count) {
    return Intl.message(
      '$count stp',
      name: 'cardStopShort',
      desc: '',
      args: [count],
    );
  }

  /// `Direct flight`
  String get cardDirectFlight {
    return Intl.message(
      'Direct flight',
      name: 'cardDirectFlight',
      desc: '',
      args: [],
    );
  }

  /// `Direct flights`
  String get cardDirectFlights {
    return Intl.message(
      'Direct flights',
      name: 'cardDirectFlights',
      desc: '',
      args: [],
    );
  }

  /// `per person`
  String get cardPerPerson {
    return Intl.message(
      'per person',
      name: 'cardPerPerson',
      desc: '',
      args: [],
    );
  }

  /// `/pers.`
  String get cardPerPersonShort {
    return Intl.message(
      '/pers.',
      name: 'cardPerPersonShort',
      desc: '',
      args: [],
    );
  }

  /// `Flight details`
  String get cardFlightDetailsText {
    return Intl.message(
      'Flight details',
      name: 'cardFlightDetailsText',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get cardDetailsText {
    return Intl.message('Details', name: 'cardDetailsText', desc: '', args: []);
  }

  /// `Flight information`
  String get cardFlightInfo {
    return Intl.message(
      'Flight information',
      name: 'cardFlightInfo',
      desc: '',
      args: [],
    );
  }

  /// `Airline`
  String get cardAirline {
    return Intl.message('Airline', name: 'cardAirline', desc: '', args: []);
  }

  /// `Flight number`
  String get cardFlightNumber {
    return Intl.message(
      'Flight number',
      name: 'cardFlightNumber',
      desc: '',
      args: [],
    );
  }

  /// `Hold baggage`
  String get cardHoldBaggage {
    return Intl.message(
      'Hold baggage',
      name: 'cardHoldBaggage',
      desc: '',
      args: [],
    );
  }

  /// `{weight} included`
  String cardWeightIncluded(Object weight) {
    return Intl.message(
      '$weight included',
      name: 'cardWeightIncluded',
      desc: '',
      args: [weight],
    );
  }

  /// `Multi-dest. ({count})`
  String cardMultiDestShort(Object count) {
    return Intl.message(
      'Multi-dest. ($count)',
      name: 'cardMultiDestShort',
      desc: '',
      args: [count],
    );
  }

  /// `Multi-destination ({count} journeys)`
  String cardMultiDestFull(Object count) {
    return Intl.message(
      'Multi-destination ($count journeys)',
      name: 'cardMultiDestFull',
      desc: '',
      args: [count],
    );
  }

  /// `Baggage`
  String get cardBaggageShort {
    return Intl.message(
      'Baggage',
      name: 'cardBaggageShort',
      desc: '',
      args: [],
    );
  }

  /// `Baggage included`
  String get cardBaggageIncluded {
    return Intl.message(
      'Baggage included',
      name: 'cardBaggageIncluded',
      desc: '',
      args: [],
    );
  }

  /// `Refundable`
  String get cardRefundable {
    return Intl.message(
      'Refundable',
      name: 'cardRefundable',
      desc: '',
      args: [],
    );
  }

  /// `Journey {number}`
  String cardJourney(Object number) {
    return Intl.message(
      'Journey $number',
      name: 'cardJourney',
      desc: '',
      args: [number],
    );
  }

  /// `{count} stop total`
  String cardStopsTotal(Object count) {
    return Intl.message(
      '$count stop total',
      name: 'cardStopsTotal',
      desc: '',
      args: [count],
    );
  }

  /// `{count} stops total`
  String cardStopsTotalPlural(Object count) {
    return Intl.message(
      '$count stops total',
      name: 'cardStopsTotalPlural',
      desc: '',
      args: [count],
    );
  }

  /// `Sort by`
  String get sortBy {
    return Intl.message('Sort by', name: 'sortBy', desc: '', args: []);
  }

  /// `Cheapest`
  String get sortCheapest {
    return Intl.message('Cheapest', name: 'sortCheapest', desc: '', args: []);
  }

  /// `Most expensive`
  String get sortMostExpensive {
    return Intl.message(
      'Most expensive',
      name: 'sortMostExpensive',
      desc: '',
      args: [],
    );
  }

  /// `Departure time`
  String get sortDepartureTime {
    return Intl.message(
      'Departure time',
      name: 'sortDepartureTime',
      desc: '',
      args: [],
    );
  }

  /// `Arrival time`
  String get sortArrivalTime {
    return Intl.message(
      'Arrival time',
      name: 'sortArrivalTime',
      desc: '',
      args: [],
    );
  }

  /// `Flight duration`
  String get sortFlightDuration {
    return Intl.message(
      'Flight duration',
      name: 'sortFlightDuration',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get sheetApply {
    return Intl.message('Apply', name: 'sheetApply', desc: '', args: []);
  }

  /// `Filter`
  String get filterTitle {
    return Intl.message('Filter', name: 'filterTitle', desc: '', args: []);
  }

  /// `Outbound`
  String get filterOutbound {
    return Intl.message('Outbound', name: 'filterOutbound', desc: '', args: []);
  }

  /// `Return`
  String get filterReturn {
    return Intl.message('Return', name: 'filterReturn', desc: '', args: []);
  }

  /// `Reset`
  String get filterReset {
    return Intl.message('Reset', name: 'filterReset', desc: '', args: []);
  }

  /// `Select a price range`
  String get filterSelectPriceRange {
    return Intl.message(
      'Select a price range',
      name: 'filterSelectPriceRange',
      desc: '',
      args: [],
    );
  }

  /// `Min: {value} {currency}`
  String filterMin(Object value, Object currency) {
    return Intl.message(
      'Min: $value $currency',
      name: 'filterMin',
      desc: '',
      args: [value, currency],
    );
  }

  /// `Max: {value} {currency}`
  String filterMax(Object value, Object currency) {
    return Intl.message(
      'Max: $value $currency',
      name: 'filterMax',
      desc: '',
      args: [value, currency],
    );
  }

  /// `Early morning`
  String get filterEarlyMorning {
    return Intl.message(
      'Early morning',
      name: 'filterEarlyMorning',
      desc: '',
      args: [],
    );
  }

  /// `Morning`
  String get filterMorning {
    return Intl.message('Morning', name: 'filterMorning', desc: '', args: []);
  }

  /// `Evening`
  String get filterEvening {
    return Intl.message('Evening', name: 'filterEvening', desc: '', args: []);
  }

  /// `Departure`
  String get filterDepartureDefault {
    return Intl.message(
      'Departure',
      name: 'filterDepartureDefault',
      desc: '',
      args: [],
    );
  }

  /// `Arrival`
  String get filterArrivalDefault {
    return Intl.message(
      'Arrival',
      name: 'filterArrivalDefault',
      desc: '',
      args: [],
    );
  }

  /// `Departure from {city}`
  String filterDepartureFrom(Object city) {
    return Intl.message(
      'Departure from $city',
      name: 'filterDepartureFrom',
      desc: '',
      args: [city],
    );
  }

  /// `Arrival at {city}`
  String filterArrivalAt(Object city) {
    return Intl.message(
      'Arrival at $city',
      name: 'filterArrivalAt',
      desc: '',
      args: [city],
    );
  }

  /// `Layovers via`
  String get filterLayoversVia {
    return Intl.message(
      'Layovers via',
      name: 'filterLayoversVia',
      desc: '',
      args: [],
    );
  }

  /// `Not included`
  String get baggageNotIncluded {
    return Intl.message(
      'Not included',
      name: 'baggageNotIncluded',
      desc: '',
      args: [],
    );
  }

  /// `{count} piece`
  String baggagePiece(Object count) {
    return Intl.message(
      '$count piece',
      name: 'baggagePiece',
      desc: '',
      args: [count],
    );
  }

  /// `{count} pieces`
  String baggagePieces(Object count) {
    return Intl.message(
      '$count pieces',
      name: 'baggagePieces',
      desc: '',
      args: [count],
    );
  }

  /// `Baggage details`
  String get baggageDetailsTitle {
    return Intl.message(
      'Baggage details',
      name: 'baggageDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Checked baggage:`
  String get baggageCheckedLabel {
    return Intl.message(
      'Checked baggage:',
      name: 'baggageCheckedLabel',
      desc: '',
      args: [],
    );
  }

  /// `Cabin baggage:`
  String get baggageCabinLabel {
    return Intl.message(
      'Cabin baggage:',
      name: 'baggageCabinLabel',
      desc: '',
      args: [],
    );
  }

  /// `Price details`
  String get priceDetailsTitle {
    return Intl.message(
      'Price details',
      name: 'priceDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Non-refundable`
  String get priceNonRefundable {
    return Intl.message(
      'Non-refundable',
      name: 'priceNonRefundable',
      desc: '',
      args: [],
    );
  }

  /// `Base fare`
  String get priceBaseFare {
    return Intl.message('Base fare', name: 'priceBaseFare', desc: '', args: []);
  }

  /// `Taxes per {type}`
  String priceTaxesPer(Object type) {
    return Intl.message(
      'Taxes per $type',
      name: 'priceTaxesPer',
      desc: '',
      args: [type],
    );
  }

  /// `1x Adult`
  String get priceAdultFallback {
    return Intl.message(
      '1x Adult',
      name: 'priceAdultFallback',
      desc: '',
      args: [],
    );
  }

  /// `Taxes per adult`
  String get priceTaxesPerAdult {
    return Intl.message(
      'Taxes per adult',
      name: 'priceTaxesPerAdult',
      desc: '',
      args: [],
    );
  }

  /// `Total incl. tax`
  String get priceTotalInclTax {
    return Intl.message(
      'Total incl. tax',
      name: 'priceTotalInclTax',
      desc: '',
      args: [],
    );
  }

  /// `Flight details`
  String get sheetFlightDetails {
    return Intl.message(
      'Flight details',
      name: 'sheetFlightDetails',
      desc: '',
      args: [],
    );
  }

  /// `Round trip flight`
  String get sheetRoundTrip {
    return Intl.message(
      'Round trip flight',
      name: 'sheetRoundTrip',
      desc: '',
      args: [],
    );
  }

  /// `One way flight`
  String get sheetOneWay {
    return Intl.message(
      'One way flight',
      name: 'sheetOneWay',
      desc: '',
      args: [],
    );
  }

  /// `Book this flight`
  String get sheetBookFlight {
    return Intl.message(
      'Book this flight',
      name: 'sheetBookFlight',
      desc: '',
      args: [],
    );
  }

  /// `{price} {currency}/ pers`
  String sheetPricePerPerson(Object price, Object currency) {
    return Intl.message(
      '$price $currency/ pers',
      name: 'sheetPricePerPerson',
      desc: '',
      args: [price, currency],
    );
  }

  /// `Airport {code}`
  String segmentAirportFallback(Object code) {
    return Intl.message(
      'Airport $code',
      name: 'segmentAirportFallback',
      desc: '',
      args: [code],
    );
  }

  /// `Terminal {terminal}`
  String segmentTerminal(Object terminal) {
    return Intl.message(
      'Terminal $terminal',
      name: 'segmentTerminal',
      desc: '',
      args: [terminal],
    );
  }

  /// `Flight {code} {number}`
  String segmentFlightInfo(Object code, Object number) {
    return Intl.message(
      'Flight $code $number',
      name: 'segmentFlightInfo',
      desc: '',
      args: [code, number],
    );
  }

  /// `{count} seats`
  String segmentSeats(Object count) {
    return Intl.message(
      '$count seats',
      name: 'segmentSeats',
      desc: '',
      args: [count],
    );
  }

  /// `Baggage`
  String get segmentBaggage {
    return Intl.message('Baggage', name: 'segmentBaggage', desc: '', args: []);
  }

  /// `Checked baggage: {bag}`
  String segmentCheckedBag(Object bag) {
    return Intl.message(
      'Checked baggage: $bag',
      name: 'segmentCheckedBag',
      desc: '',
      args: [bag],
    );
  }

  /// `Cabin baggage: {bag}`
  String segmentCabinBag(Object bag) {
    return Intl.message(
      'Cabin baggage: $bag',
      name: 'segmentCabinBag',
      desc: '',
      args: [bag],
    );
  }

  /// `Layover at {airport} ({code})`
  String layoverAt(Object airport, Object code) {
    return Intl.message(
      'Layover at $airport ($code)',
      name: 'layoverAt',
      desc: '',
      args: [airport, code],
    );
  }

  /// `Duration: {time}`
  String layoverDuration(Object time) {
    return Intl.message(
      'Duration: $time',
      name: 'layoverDuration',
      desc: '',
      args: [time],
    );
  }

  /// `All`
  String get chipAll {
    return Intl.message('All', name: 'chipAll', desc: '', args: []);
  }

  /// `{from} to {to}`
  String editRouteInfo(Object from, Object to) {
    return Intl.message(
      '$from to $to',
      name: 'editRouteInfo',
      desc: '',
      args: [from, to],
    );
  }

  /// `Select class`
  String get editSelectClass {
    return Intl.message(
      'Select class',
      name: 'editSelectClass',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get editSelect {
    return Intl.message('Select', name: 'editSelect', desc: '', args: []);
  }

  /// `Select a date`
  String get editSelectDate {
    return Intl.message(
      'Select a date',
      name: 'editSelectDate',
      desc: '',
      args: [],
    );
  }

  /// `{city} ({code} - all airports)`
  String editAirportAll(Object city, Object code) {
    return Intl.message(
      '$city ($code - all airports)',
      name: 'editAirportAll',
      desc: '',
      args: [city, code],
    );
  }

  /// `{city} ({code} - airport..)`
  String editAirportSingle(Object city, Object code) {
    return Intl.message(
      '$city ($code - airport..)',
      name: 'editAirportSingle',
      desc: '',
      args: [city, code],
    );
  }

  /// `{count} Passenger(s), {className}`
  String editPassengerSummary(Object count, Object className) {
    return Intl.message(
      '$count Passenger(s), $className',
      name: 'editPassengerSummary',
      desc: '',
      args: [count, className],
    );
  }

  /// `Price ↑`
  String get sortCheapestShort {
    return Intl.message(
      'Price ↑',
      name: 'sortCheapestShort',
      desc: '',
      args: [],
    );
  }

  /// `Price ↓`
  String get sortExpensiveShort {
    return Intl.message(
      'Price ↓',
      name: 'sortExpensiveShort',
      desc: '',
      args: [],
    );
  }

  /// `Departure`
  String get sortDepartureShort {
    return Intl.message(
      'Departure',
      name: 'sortDepartureShort',
      desc: '',
      args: [],
    );
  }

  /// `Arrival`
  String get sortArrivalShort {
    return Intl.message(
      'Arrival',
      name: 'sortArrivalShort',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get sortDurationShort {
    return Intl.message(
      'Duration',
      name: 'sortDurationShort',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sortDefaultShort {
    return Intl.message('Sort', name: 'sortDefaultShort', desc: '', args: []);
  }

  /// `Manage my account`
  String get profileManageAccount {
    return Intl.message(
      'Manage my account',
      name: 'profileManageAccount',
      desc: '',
      args: [],
    );
  }

  /// `Personal details`
  String get profilePersonalInfo {
    return Intl.message(
      'Personal details',
      name: 'profilePersonalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Registered travelers`
  String get profileRegisteredTravelers {
    return Intl.message(
      'Registered travelers',
      name: 'profileRegisteredTravelers',
      desc: '',
      args: [],
    );
  }

  /// `Refer a friend`
  String get profileReferFriend {
    return Intl.message(
      'Refer a friend',
      name: 'profileReferFriend',
      desc: '',
      args: [],
    );
  }

  /// `Security settings`
  String get profileSecuritySettings {
    return Intl.message(
      'Security settings',
      name: 'profileSecuritySettings',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get profileSettingsSection {
    return Intl.message(
      'Settings',
      name: 'profileSettingsSection',
      desc: '',
      args: [],
    );
  }

  /// `Currencies`
  String get profileCurrencies {
    return Intl.message(
      'Currencies',
      name: 'profileCurrencies',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get profileLanguages {
    return Intl.message(
      'Languages',
      name: 'profileLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get profileNotifications {
    return Intl.message(
      'Notifications',
      name: 'profileNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Terms and conditions`
  String get profileTerms {
    return Intl.message(
      'Terms and conditions',
      name: 'profileTerms',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get profileHelpSection {
    return Intl.message('Help', name: 'profileHelpSection', desc: '', args: []);
  }

  /// `Contact customer service`
  String get profileContactSupport {
    return Intl.message(
      'Contact customer service',
      name: 'profileContactSupport',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get profileFaq {
    return Intl.message('FAQ', name: 'profileFaq', desc: '', args: []);
  }

  /// `Referral`
  String get profileReferralTitle {
    return Intl.message(
      'Referral',
      name: 'profileReferralTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share your referral code with your friends!`
  String get profileReferralMessage {
    return Intl.message(
      'Share your referral code with your friends!',
      name: 'profileReferralMessage',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get profileClose {
    return Intl.message('Close', name: 'profileClose', desc: '', args: []);
  }

  /// `Disable account`
  String get profileDisableAccount {
    return Intl.message(
      'Disable account',
      name: 'profileDisableAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to disable your account? This action is irreversible and you will be logged out.`
  String get profileDisableConfirm {
    return Intl.message(
      'Are you sure you want to disable your account? This action is irreversible and you will be logged out.',
      name: 'profileDisableConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Disable`
  String get profileDisable {
    return Intl.message('Disable', name: 'profileDisable', desc: '', args: []);
  }

  /// `Account disabled successfully`
  String get profileDisableSuccess {
    return Intl.message(
      'Account disabled successfully',
      name: 'profileDisableSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Account deactivation failed`
  String get profileDisableFailed {
    return Intl.message(
      'Account deactivation failed',
      name: 'profileDisableFailed',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String profileError(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'profileError',
      desc: '',
      args: [error],
    );
  }

  /// `Logout`
  String get profileLogoutTitle {
    return Intl.message(
      'Logout',
      name: 'profileLogoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get profileLogoutConfirm {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'profileLogoutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get profileCancel {
    return Intl.message('Cancel', name: 'profileCancel', desc: '', args: []);
  }

  /// `Log out`
  String get profileLogoutAction {
    return Intl.message(
      'Log out',
      name: 'profileLogoutAction',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get profileLogoutButton {
    return Intl.message(
      'Log out',
      name: 'profileLogoutButton',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfileTitle {
    return Intl.message(
      'Edit profile',
      name: 'editProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get editProfilePersonalInfo {
    return Intl.message(
      'Personal information',
      name: 'editProfilePersonalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in name and email`
  String get editProfileFillNameEmail {
    return Intl.message(
      'Please fill in name and email',
      name: 'editProfileFillNameEmail',
      desc: '',
      args: [],
    );
  }

  /// `Uploading image...`
  String get editProfileUploadingImage {
    return Intl.message(
      'Uploading image...',
      name: 'editProfileUploadingImage',
      desc: '',
      args: [],
    );
  }

  /// `Image upload failed. Try again.`
  String get editProfileUploadFailed {
    return Intl.message(
      'Image upload failed. Try again.',
      name: 'editProfileUploadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated`
  String get editProfileUpdated {
    return Intl.message(
      'Profile updated',
      name: 'editProfileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error updating`
  String get editProfileUpdateError {
    return Intl.message(
      'Error updating',
      name: 'editProfileUpdateError',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get editProfileErrorGeneric {
    return Intl.message(
      'Error',
      name: 'editProfileErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get editProfileUpdate {
    return Intl.message(
      'Update',
      name: 'editProfileUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get editProfileCivility {
    return Intl.message(
      'Title',
      name: 'editProfileCivility',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get editProfileSelectOption {
    return Intl.message(
      'Select',
      name: 'editProfileSelectOption',
      desc: '',
      args: [],
    );
  }

  /// `First Last Name`
  String get editProfileFullNameHint {
    return Intl.message(
      'First Last Name',
      name: 'editProfileFullNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get editProfileFullNameLabel {
    return Intl.message(
      'Full name',
      name: 'editProfileFullNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `email@example.com`
  String get editProfileEmailHint {
    return Intl.message(
      'email@example.com',
      name: 'editProfileEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get editProfileEmailLabel {
    return Intl.message(
      'Email',
      name: 'editProfileEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get editProfilePhoneLabel {
    return Intl.message(
      'Phone',
      name: 'editProfilePhoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Postal code`
  String get editProfilePostCodeLabel {
    return Intl.message(
      'Postal code',
      name: 'editProfilePostCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `123 Main Street`
  String get editProfileAddressHint {
    return Intl.message(
      '123 Main Street',
      name: 'editProfileAddressHint',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get editProfileAddressLabel {
    return Intl.message(
      'Address',
      name: 'editProfileAddressLabel',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get editProfileCityLabel {
    return Intl.message(
      'City',
      name: 'editProfileCityLabel',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get editProfileCountryLabel {
    return Intl.message(
      'Country',
      name: 'editProfileCountryLabel',
      desc: '',
      args: [],
    );
  }

  /// `YYYY-MM-DD`
  String get editProfileBirthDateHint {
    return Intl.message(
      'YYYY-MM-DD',
      name: 'editProfileBirthDateHint',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get editProfileBirthDateLabel {
    return Intl.message(
      'Date of birth',
      name: 'editProfileBirthDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `New passwords do not match`
  String get changePwMismatch {
    return Intl.message(
      'New passwords do not match',
      name: 'changePwMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Password updated successfully`
  String get changePwSuccess {
    return Intl.message(
      'Password updated successfully',
      name: 'changePwSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Password update failed`
  String get changePwFailed {
    return Intl.message(
      'Password update failed',
      name: 'changePwFailed',
      desc: '',
      args: [],
    );
  }

  /// `Your new password must be at least 8 characters`
  String get changePwInfoText {
    return Intl.message(
      'Your new password must be at least 8 characters',
      name: 'changePwInfoText',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get changePwCurrentLabel {
    return Intl.message(
      'Current password',
      name: 'changePwCurrentLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter your current password`
  String get changePwCurrentHint {
    return Intl.message(
      'Enter your current password',
      name: 'changePwCurrentHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your current password`
  String get changePwCurrentRequired {
    return Intl.message(
      'Please enter your current password',
      name: 'changePwCurrentRequired',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get changePwNewLabel {
    return Intl.message(
      'New password',
      name: 'changePwNewLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password`
  String get changePwNewHint {
    return Intl.message(
      'Enter your new password',
      name: 'changePwNewHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password`
  String get changePwNewRequired {
    return Intl.message(
      'Please enter a new password',
      name: 'changePwNewRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get changePwMinLength {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'changePwMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get changePwConfirmLabel {
    return Intl.message(
      'Confirm new password',
      name: 'changePwConfirmLabel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your new password`
  String get changePwConfirmHint {
    return Intl.message(
      'Confirm your new password',
      name: 'changePwConfirmHint',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get changePwConfirmRequired {
    return Intl.message(
      'Please confirm your password',
      name: 'changePwConfirmRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get changePwNoMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'changePwNoMatch',
      desc: '',
      args: [],
    );
  }

  /// `Algeria`
  String get currencyAlgeria {
    return Intl.message('Algeria', name: 'currencyAlgeria', desc: '', args: []);
  }

  /// `France`
  String get currencyFrance {
    return Intl.message('France', name: 'currencyFrance', desc: '', args: []);
  }

  /// `Tunisia`
  String get currencyTunisia {
    return Intl.message('Tunisia', name: 'currencyTunisia', desc: '', args: []);
  }

  /// `Clear All`
  String get notificationAllClear {
    return Intl.message(
      'Clear All',
      name: 'notificationAllClear',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get notificationToday {
    return Intl.message('Today', name: 'notificationToday', desc: '', args: []);
  }

  /// `Yesterday`
  String get notificationYesterday {
    return Intl.message(
      'Yesterday',
      name: 'notificationYesterday',
      desc: '',
      args: [],
    );
  }

  /// `Payment Successful!`
  String get notificationPaymentSuccessTitle {
    return Intl.message(
      'Payment Successful!',
      name: 'notificationPaymentSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your payment has been processed successfully.`
  String get notificationPaymentSuccessDesc {
    return Intl.message(
      'Your payment has been processed successfully.',
      name: 'notificationPaymentSuccessDesc',
      desc: '',
      args: [],
    );
  }

  /// `{date}, {timeAgo}`
  String notificationTimeAgo(Object date, Object timeAgo) {
    return Intl.message(
      '$date, $timeAgo',
      name: 'notificationTimeAgo',
      desc: '',
      args: [date, timeAgo],
    );
  }

  /// `{count} min ago`
  String notificationMinutesAgo(Object count) {
    return Intl.message(
      '$count min ago',
      name: 'notificationMinutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `1 min ago`
  String get notificationMinuteAgo {
    return Intl.message(
      '1 min ago',
      name: 'notificationMinuteAgo',
      desc: '',
      args: [],
    );
  }

  /// `Inbox`
  String get inboxTitle {
    return Intl.message('Inbox', name: 'inboxTitle', desc: '', args: []);
  }

  /// `No notifications yet`
  String get inboxEmptyTitle {
    return Intl.message(
      'No notifications yet',
      name: 'inboxEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `You will receive alerts about your trips and your account. Have you chosen your next destination yet?`
  String get inboxEmptyDescription {
    return Intl.message(
      'You will receive alerts about your trips and your account. Have you chosen your next destination yet?',
      name: 'inboxEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get inboxExploreButton {
    return Intl.message(
      'Explore',
      name: 'inboxExploreButton',
      desc: '',
      args: [],
    );
  }

  /// `Bookings`
  String get bookingTitle {
    return Intl.message('Bookings', name: 'bookingTitle', desc: '', args: []);
  }

  /// `Active`
  String get bookingTabActive {
    return Intl.message('Active', name: 'bookingTabActive', desc: '', args: []);
  }

  /// `Past`
  String get bookingTabPast {
    return Intl.message('Past', name: 'bookingTabPast', desc: '', args: []);
  }

  /// `Cancelled`
  String get bookingTabCancelled {
    return Intl.message(
      'Cancelled',
      name: 'bookingTabCancelled',
      desc: '',
      args: [],
    );
  }

  /// `No active bookings`
  String get bookingEmptyActive {
    return Intl.message(
      'No active bookings',
      name: 'bookingEmptyActive',
      desc: '',
      args: [],
    );
  }

  /// `No past trips`
  String get bookingEmptyPast {
    return Intl.message(
      'No past trips',
      name: 'bookingEmptyPast',
      desc: '',
      args: [],
    );
  }

  /// `No cancelled bookings`
  String get bookingEmptyCancelled {
    return Intl.message(
      'No cancelled bookings',
      name: 'bookingEmptyCancelled',
      desc: '',
      args: [],
    );
  }

  /// `No bookings`
  String get bookingEmptyDefault {
    return Intl.message(
      'No bookings',
      name: 'bookingEmptyDefault',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get bookingDetails {
    return Intl.message('Details', name: 'bookingDetails', desc: '', args: []);
  }

  /// `In progress`
  String get statusInProgress {
    return Intl.message(
      'In progress',
      name: 'statusInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get statusConfirmed {
    return Intl.message(
      'Confirmed',
      name: 'statusConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get statusCompleted {
    return Intl.message(
      'Completed',
      name: 'statusCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get statusCancelled {
    return Intl.message(
      'Cancelled',
      name: 'statusCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Customer support`
  String get supportTitle {
    return Intl.message(
      'Customer support',
      name: 'supportTitle',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get supportTabAll {
    return Intl.message('All', name: 'supportTabAll', desc: '', args: []);
  }

  /// `Active`
  String get supportTabActive {
    return Intl.message('Active', name: 'supportTabActive', desc: '', args: []);
  }

  /// `Resolved`
  String get supportTabResolved {
    return Intl.message(
      'Resolved',
      name: 'supportTabResolved',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get supportTabClosed {
    return Intl.message('Closed', name: 'supportTabClosed', desc: '', args: []);
  }

  /// `Manage and track your requests in real time`
  String get supportBanner {
    return Intl.message(
      'Manage and track your requests in real time',
      name: 'supportBanner',
      desc: '',
      args: [],
    );
  }

  /// `Helpdesk`
  String get supportHelpdesk {
    return Intl.message(
      'Helpdesk',
      name: 'supportHelpdesk',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get supportFilter {
    return Intl.message('Filter', name: 'supportFilter', desc: '', args: []);
  }

  /// `Ticket`
  String get supportTicket {
    return Intl.message('Ticket', name: 'supportTicket', desc: '', args: []);
  }

  /// `Details`
  String get supportDetails {
    return Intl.message('Details', name: 'supportDetails', desc: '', args: []);
  }

  /// `in progress`
  String get supportStatusInProgress {
    return Intl.message(
      'in progress',
      name: 'supportStatusInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get supportStatusActive {
    return Intl.message(
      'Active',
      name: 'supportStatusActive',
      desc: '',
      args: [],
    );
  }

  /// `Resolved`
  String get supportStatusResolved {
    return Intl.message(
      'Resolved',
      name: 'supportStatusResolved',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get supportStatusClosed {
    return Intl.message(
      'Closed',
      name: 'supportStatusClosed',
      desc: '',
      args: [],
    );
  }

  /// `Ticket detail`
  String get ticketDetailTitle {
    return Intl.message(
      'Ticket detail',
      name: 'ticketDetailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get ticketDetailClose {
    return Intl.message('Close', name: 'ticketDetailClose', desc: '', args: []);
  }

  /// `Urgent`
  String get ticketDetailStatusUrgent {
    return Intl.message(
      'Urgent',
      name: 'ticketDetailStatusUrgent',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get ticketDetailStatusOpen {
    return Intl.message(
      'Open',
      name: 'ticketDetailStatusOpen',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get ticketDetailStatusPending {
    return Intl.message(
      'Pending',
      name: 'ticketDetailStatusPending',
      desc: '',
      args: [],
    );
  }

  /// `Resolved`
  String get ticketDetailStatusResolved {
    return Intl.message(
      'Resolved',
      name: 'ticketDetailStatusResolved',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get ticketDetailStatusClosed {
    return Intl.message(
      'Closed',
      name: 'ticketDetailStatusClosed',
      desc: '',
      args: [],
    );
  }

  /// `Created on {created} · Updated {updated}`
  String ticketDetailCreatedUpdated(Object created, Object updated) {
    return Intl.message(
      'Created on $created · Updated $updated',
      name: 'ticketDetailCreatedUpdated',
      desc: '',
      args: [created, updated],
    );
  }

  /// `This ticket is closed`
  String get ticketDetailTicketClosed {
    return Intl.message(
      'This ticket is closed',
      name: 'ticketDetailTicketClosed',
      desc: '',
      args: [],
    );
  }

  /// `Write a message...`
  String get ticketDetailMessageHint {
    return Intl.message(
      'Write a message...',
      name: 'ticketDetailMessageHint',
      desc: '',
      args: [],
    );
  }

  /// `Close the ticket?`
  String get ticketDetailCloseDialog {
    return Intl.message(
      'Close the ticket?',
      name: 'ticketDetailCloseDialog',
      desc: '',
      args: [],
    );
  }

  /// `You will no longer be able to send messages once the ticket is closed.`
  String get ticketDetailCloseWarning {
    return Intl.message(
      'You will no longer be able to send messages once the ticket is closed.',
      name: 'ticketDetailCloseWarning',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get ticketDetailCancel {
    return Intl.message(
      'Cancel',
      name: 'ticketDetailCancel',
      desc: '',
      args: [],
    );
  }

  /// `Ticket details`
  String get createTicketDetailsTitle {
    return Intl.message(
      'Ticket details',
      name: 'createTicketDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get createTicketStatus {
    return Intl.message(
      'Status',
      name: 'createTicketStatus',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get createTicketPriority {
    return Intl.message(
      'Priority',
      name: 'createTicketPriority',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get createTicketStatusOpen {
    return Intl.message(
      'Open',
      name: 'createTicketStatusOpen',
      desc: '',
      args: [],
    );
  }

  /// `In progress`
  String get createTicketStatusInProgress {
    return Intl.message(
      'In progress',
      name: 'createTicketStatusInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Resolved`
  String get createTicketStatusResolved {
    return Intl.message(
      'Resolved',
      name: 'createTicketStatusResolved',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get createTicketStatusClosed {
    return Intl.message(
      'Closed',
      name: 'createTicketStatusClosed',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get createTicketPriorityLow {
    return Intl.message(
      'Low',
      name: 'createTicketPriorityLow',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get createTicketPriorityNormal {
    return Intl.message(
      'Normal',
      name: 'createTicketPriorityNormal',
      desc: '',
      args: [],
    );
  }

  /// `Urgent`
  String get createTicketPriorityUrgent {
    return Intl.message(
      'Urgent',
      name: 'createTicketPriorityUrgent',
      desc: '',
      args: [],
    );
  }

  /// `Created by`
  String get createTicketCreatedBy {
    return Intl.message(
      'Created by',
      name: 'createTicketCreatedBy',
      desc: '',
      args: [],
    );
  }

  /// `Created on`
  String get createTicketCreatedOn {
    return Intl.message(
      'Created on',
      name: 'createTicketCreatedOn',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get createTicketUpdatedOn {
    return Intl.message(
      'Updated',
      name: 'createTicketUpdatedOn',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get createTicketServices {
    return Intl.message(
      'Services',
      name: 'createTicketServices',
      desc: '',
      args: [],
    );
  }

  /// `Close ticket`
  String get createTicketCloseTicket {
    return Intl.message(
      'Close ticket',
      name: 'createTicketCloseTicket',
      desc: '',
      args: [],
    );
  }

  /// `Conversation`
  String get createTicketConversation {
    return Intl.message(
      'Conversation',
      name: 'createTicketConversation',
      desc: '',
      args: [],
    );
  }

  /// `Write a reply`
  String get createTicketWriteReply {
    return Intl.message(
      'Write a reply',
      name: 'createTicketWriteReply',
      desc: '',
      args: [],
    );
  }

  /// `Write your message here...`
  String get createTicketMessageHint {
    return Intl.message(
      'Write your message here...',
      name: 'createTicketMessageHint',
      desc: '',
      args: [],
    );
  }

  /// `Attachments`
  String get createTicketAttachments {
    return Intl.message(
      'Attachments',
      name: 'createTicketAttachments',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get createTicketSend {
    return Intl.message('Send', name: 'createTicketSend', desc: '', args: []);
  }

  /// `You`
  String get createTicketYou {
    return Intl.message('You', name: 'createTicketYou', desc: '', args: []);
  }

  /// `Flight quote request`
  String get createTicketDefaultSubject {
    return Intl.message(
      'Flight quote request',
      name: 'createTicketDefaultSubject',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get faqTitle {
    return Intl.message('FAQ', name: 'faqTitle', desc: '', args: []);
  }

  /// `Search a question...`
  String get faqSearchHint {
    return Intl.message(
      'Search a question...',
      name: 'faqSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get faqAllCategory {
    return Intl.message('All', name: 'faqAllCategory', desc: '', args: []);
  }

  /// `All questions`
  String get faqAllQuestions {
    return Intl.message(
      'All questions',
      name: 'faqAllQuestions',
      desc: '',
      args: [],
    );
  }

  /// `{count} questions`
  String faqQuestionCount(Object count) {
    return Intl.message(
      '$count questions',
      name: 'faqQuestionCount',
      desc: '',
      args: [count],
    );
  }

  /// `No results`
  String get faqNoResults {
    return Intl.message('No results', name: 'faqNoResults', desc: '', args: []);
  }

  /// `No question matches your search.`
  String get faqNoResultsDesc {
    return Intl.message(
      'No question matches your search.',
      name: 'faqNoResultsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Didn't find your answer?`
  String get faqNotFoundAnswer {
    return Intl.message(
      'Didn\'t find your answer?',
      name: 'faqNotFoundAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Our support team is available to help you.`
  String get faqSupportAvailable {
    return Intl.message(
      'Our support team is available to help you.',
      name: 'faqSupportAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Contact support`
  String get faqContactSupport {
    return Intl.message(
      'Contact support',
      name: 'faqContactSupport',
      desc: '',
      args: [],
    );
  }

  /// `Booking`
  String get faqCatReservation {
    return Intl.message(
      'Booking',
      name: 'faqCatReservation',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get faqCatPayment {
    return Intl.message('Payment', name: 'faqCatPayment', desc: '', args: []);
  }

  /// `Modification`
  String get faqCatModification {
    return Intl.message(
      'Modification',
      name: 'faqCatModification',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation & Refund`
  String get faqCatRefund {
    return Intl.message(
      'Cancellation & Refund',
      name: 'faqCatRefund',
      desc: '',
      args: [],
    );
  }

  /// `Baggage`
  String get faqCatBaggage {
    return Intl.message('Baggage', name: 'faqCatBaggage', desc: '', args: []);
  }

  /// `How do I book a flight?`
  String get faqQ1 {
    return Intl.message(
      'How do I book a flight?',
      name: 'faqQ1',
      desc: '',
      args: [],
    );
  }

  /// `To book a flight, follow these steps:\n\n1. Search for your flight by entering your departure city, destination and dates\n2. Select the flight that suits you\n3. Choose your travel class (Classic or Flex)\n4. Fill in the passenger information\n5. Proceed to payment\n\nYou will receive your confirmation by email.`
  String get faqA1 {
    return Intl.message(
      'To book a flight, follow these steps:\n\n1. Search for your flight by entering your departure city, destination and dates\n2. Select the flight that suits you\n3. Choose your travel class (Classic or Flex)\n4. Fill in the passenger information\n5. Proceed to payment\n\nYou will receive your confirmation by email.',
      name: 'faqA1',
      desc: '',
      args: [],
    );
  }

  /// `Can I book for multiple passengers?`
  String get faqQ2 {
    return Intl.message(
      'Can I book for multiple passengers?',
      name: 'faqQ2',
      desc: '',
      args: [],
    );
  }

  /// `Yes, you can book up to 9 passengers per booking (adults, children and infants combined). Each passenger's information will need to be provided during the booking.`
  String get faqA2 {
    return Intl.message(
      'Yes, you can book up to 9 passengers per booking (adults, children and infants combined). Each passenger\'s information will need to be provided during the booking.',
      name: 'faqA2',
      desc: '',
      args: [],
    );
  }

  /// `How do I add baggage to my booking?`
  String get faqQ3 {
    return Intl.message(
      'How do I add baggage to my booking?',
      name: 'faqQ3',
      desc: '',
      args: [],
    );
  }

  /// `You can add extra baggage:\n\n• During the booking, at the options step\n• After the booking, in the "Manage my booking" section\n\nNote: Adding baggage is cheaper during the initial booking.`
  String get faqA3 {
    return Intl.message(
      'You can add extra baggage:\n\n• During the booking, at the options step\n• After the booking, in the "Manage my booking" section\n\nNote: Adding baggage is cheaper during the initial booking.',
      name: 'faqA3',
      desc: '',
      args: [],
    );
  }

  /// `What payment methods are accepted?`
  String get faqQ4 {
    return Intl.message(
      'What payment methods are accepted?',
      name: 'faqQ4',
      desc: '',
      args: [],
    );
  }

  /// `We accept the following payment methods:\n\n• Bank cards (Visa, Mastercard)\n• CIB / EDAHABIA card\n• Bank transfer\n• Payment at the agency\n\nAll payments are secure and encrypted.`
  String get faqA4 {
    return Intl.message(
      'We accept the following payment methods:\n\n• Bank cards (Visa, Mastercard)\n• CIB / EDAHABIA card\n• Bank transfer\n• Payment at the agency\n\nAll payments are secure and encrypted.',
      name: 'faqA4',
      desc: '',
      args: [],
    );
  }

  /// `My transaction failed, what should I do?`
  String get faqQ5 {
    return Intl.message(
      'My transaction failed, what should I do?',
      name: 'faqQ5',
      desc: '',
      args: [],
    );
  }

  /// `If your transaction failed:\n\n1. Check that your card information is correct\n2. Make sure your card is enabled for online payments\n3. Check your payment limit\n4. Try another payment method\n\nIf the problem persists, contact our support.`
  String get faqA5 {
    return Intl.message(
      'If your transaction failed:\n\n1. Check that your card information is correct\n2. Make sure your card is enabled for online payments\n3. Check your payment limit\n4. Try another payment method\n\nIf the problem persists, contact our support.',
      name: 'faqA5',
      desc: '',
      args: [],
    );
  }

  /// `How do I get an invoice?`
  String get faqQ6 {
    return Intl.message(
      'How do I get an invoice?',
      name: 'faqQ6',
      desc: '',
      args: [],
    );
  }

  /// `Your invoice is automatically sent by email after booking confirmation. You can also download it from the "My bookings" section in your personal area.`
  String get faqA6 {
    return Intl.message(
      'Your invoice is automatically sent by email after booking confirmation. You can also download it from the "My bookings" section in your personal area.',
      name: 'faqA6',
      desc: '',
      args: [],
    );
  }

  /// `How do I modify my booking?`
  String get faqQ7 {
    return Intl.message(
      'How do I modify my booking?',
      name: 'faqQ7',
      desc: '',
      args: [],
    );
  }

  /// `To modify your booking:\n\n1. Log in to your account\n2. Go to "My bookings"\n3. Select the booking to modify\n4. Click "Modify"\n\nNote: Fees may apply depending on your fare (Classic or Flex).`
  String get faqA7 {
    return Intl.message(
      'To modify your booking:\n\n1. Log in to your account\n2. Go to "My bookings"\n3. Select the booking to modify\n4. Click "Modify"\n\nNote: Fees may apply depending on your fare (Classic or Flex).',
      name: 'faqA7',
      desc: '',
      args: [],
    );
  }

  /// `Can I change the name on my booking?`
  String get faqQ8 {
    return Intl.message(
      'Can I change the name on my booking?',
      name: 'faqQ8',
      desc: '',
      args: [],
    );
  }

  /// `Name changes are only possible for minor corrections (typo). For a complete passenger change, you must cancel and make a new booking.`
  String get faqA8 {
    return Intl.message(
      'Name changes are only possible for minor corrections (typo). For a complete passenger change, you must cancel and make a new booking.',
      name: 'faqA8',
      desc: '',
      args: [],
    );
  }

  /// `What are the modification fees?`
  String get faqQ9 {
    return Intl.message(
      'What are the modification fees?',
      name: 'faqQ9',
      desc: '',
      args: [],
    );
  }

  /// `Fees depend on your fare:\n\n• Flex fare: Free modifications\n• Classic fare: Fee of 7000 DZD per passenger\n\n+ Possible fare difference if the new flight is more expensive.`
  String get faqA9 {
    return Intl.message(
      'Fees depend on your fare:\n\n• Flex fare: Free modifications\n• Classic fare: Fee of 7000 DZD per passenger\n\n+ Possible fare difference if the new flight is more expensive.',
      name: 'faqA9',
      desc: '',
      args: [],
    );
  }

  /// `How do I cancel my booking?`
  String get faqQ10 {
    return Intl.message(
      'How do I cancel my booking?',
      name: 'faqQ10',
      desc: '',
      args: [],
    );
  }

  /// `To cancel your booking:\n\n1. Log in to your account\n2. Go to "My bookings"\n3. Select the relevant booking\n4. Click "Cancel"\n5. Confirm the cancellation\n\nA confirmation email will be sent to you.`
  String get faqA10 {
    return Intl.message(
      'To cancel your booking:\n\n1. Log in to your account\n2. Go to "My bookings"\n3. Select the relevant booking\n4. Click "Cancel"\n5. Confirm the cancellation\n\nA confirmation email will be sent to you.',
      name: 'faqA10',
      desc: '',
      args: [],
    );
  }

  /// `What are the cancellation fees?`
  String get faqQ11 {
    return Intl.message(
      'What are the cancellation fees?',
      name: 'faqQ11',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation fees vary depending on your fare:\n\n• Flex fare: Free cancellation\n• Classic fare: Fee of 5000 DZD per passenger\n\nFor cancellations less than 24h before departure, special conditions apply.`
  String get faqA11 {
    return Intl.message(
      'Cancellation fees vary depending on your fare:\n\n• Flex fare: Free cancellation\n• Classic fare: Fee of 5000 DZD per passenger\n\nFor cancellations less than 24h before departure, special conditions apply.',
      name: 'faqA11',
      desc: '',
      args: [],
    );
  }

  /// `When will I receive my refund?`
  String get faqQ12 {
    return Intl.message(
      'When will I receive my refund?',
      name: 'faqQ12',
      desc: '',
      args: [],
    );
  }

  /// `The refund timeframe is 7 to 14 business days after your request is validated. The amount will be credited to the same payment method used during the booking.`
  String get faqA12 {
    return Intl.message(
      'The refund timeframe is 7 to 14 business days after your request is validated. The amount will be credited to the same payment method used during the booking.',
      name: 'faqA12',
      desc: '',
      args: [],
    );
  }

  /// `What is the included baggage allowance?`
  String get faqQ13 {
    return Intl.message(
      'What is the included baggage allowance?',
      name: 'faqQ13',
      desc: '',
      args: [],
    );
  }

  /// `The baggage allowance depends on your class:\n\n• Economy: 1 bag of 23kg in hold + 1 cabin bag of 8kg\n• Business: 2 bags of 32kg in hold + 1 cabin bag of 12kg\n\nMaximum dimensions vary by airline.`
  String get faqA13 {
    return Intl.message(
      'The baggage allowance depends on your class:\n\n• Economy: 1 bag of 23kg in hold + 1 cabin bag of 8kg\n• Business: 2 bags of 32kg in hold + 1 cabin bag of 12kg\n\nMaximum dimensions vary by airline.',
      name: 'faqA13',
      desc: '',
      args: [],
    );
  }

  /// `What should I do if my baggage is lost?`
  String get faqQ14 {
    return Intl.message(
      'What should I do if my baggage is lost?',
      name: 'faqQ14',
      desc: '',
      args: [],
    );
  }

  /// `If your baggage is lost:\n\n1. Report it immediately at the airport baggage counter\n2. Fill in a PIR form (Property Irregularity Report)\n3. Keep your case number\n4. Contact our support with this information\n\nWe will assist you throughout the process.`
  String get faqA14 {
    return Intl.message(
      'If your baggage is lost:\n\n1. Report it immediately at the airport baggage counter\n2. Fill in a PIR form (Property Irregularity Report)\n3. Keep your case number\n4. Contact our support with this information\n\nWe will assist you throughout the process.',
      name: 'faqA14',
      desc: '',
      args: [],
    );
  }

  /// `Can I transport special items?`
  String get faqQ15 {
    return Intl.message(
      'Can I transport special items?',
      name: 'faqQ15',
      desc: '',
      args: [],
    );
  }

  /// `Some items require prior declaration:\n\n• Sports equipment (bicycle, ski, golf)\n• Musical instruments\n• Pets\n• Medical equipment\n\nContact us at least 48h before your flight to arrange transport.`
  String get faqA15 {
    return Intl.message(
      'Some items require prior declaration:\n\n• Sports equipment (bicycle, ski, golf)\n• Musical instruments\n• Pets\n• Medical equipment\n\nContact us at least 48h before your flight to arrange transport.',
      name: 'faqA15',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
