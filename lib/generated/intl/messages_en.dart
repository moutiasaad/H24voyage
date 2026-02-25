// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) => "${count} piece";

  static String m1(count) => "${count} pieces";

  static String m2(number) => "Journey ${number}";

  static String m3(count) => "Multi-destination (${count} journeys)";

  static String m4(count) => "Multi-dest. (${count})";

  static String m5(count) => "${count} stop";

  static String m6(count) => "${count} stp";

  static String m7(count) => "${count} stops";

  static String m8(count) => "${count} stop total";

  static String m9(count) => "${count} stops total";

  static String m10(weight) => "${weight} included";

  static String m11(amount, currency) =>
      "Cancellation fees from ${amount} ${currency}";

  static String m12(amount, currency) =>
      "Date change fees from ${amount} ${currency}";

  static String m13(duration) => "${duration} in flight";

  static String m14(duration, flightClass) =>
      "Non-stop | ${duration} | ${flightClass}";

  static String m15(city) => "Overnight layover in ${city}";

  static String m16(stops, duration, flightClass) =>
      "${stops} stop | ${duration} | ${flightClass}";

  static String m17(city, code) => "${city} (${code} - all airports)";

  static String m18(city, code) => "${city} (${code} - airport..)";

  static String m19(count, className) => "${count} Passenger(s), ${className}";

  static String m20(from, to) => "${from} to ${to}";

  static String m21(count) => "${count} questions";

  static String m22(city) => "Arrival at ${city}";

  static String m23(city) => "Departure from ${city}";

  static String m24(value, currency) => "Max: ${value} ${currency}";

  static String m25(value, currency) => "Min: ${value} ${currency}";

  static String m26(error) => "Error: ${error}";

  static String m27(name) => "Hello, ${name}";

  static String m28(count) => "${count} Passenger(s)";

  static String m29(n) => "Please select airports for flight ${n}.";

  static String m30(n) => "Please select a date for flight ${n}.";

  static String m31(hours) => "${hours} in flight";

  static String m32(airport, code) => "Layover at ${airport} (${code})";

  static String m33(time) => "Duration: ${time}";

  static String m34(error) => "Search error: ${error}";

  static String m35(hours) => "${hours} in flight";

  static String m36(count) => "${count} min ago";

  static String m37(date, timeAgo) => "${date}, ${timeAgo}";

  static String m38(email) => "A new code has been sent to ${email}";

  static String m39(name) => "${name} (Male)";

  static String m40(count) => "${count} flights available";

  static String m41(type) => "Taxes per ${type}";

  static String m42(error) => "Error: ${error}";

  static String m43(current, total) =>
      "Page ${current} / ${total} - Scroll for more";

  static String m44(code) => "Airport ${code}";

  static String m45(bag) => "Cabin baggage: ${bag}";

  static String m46(bag) => "Checked baggage: ${bag}";

  static String m47(code, number) => "Flight ${code} ${number}";

  static String m48(count) => "${count} seats";

  static String m49(terminal) => "Terminal ${terminal}";

  static String m50(price, currency) => "${price} ${currency}/ pers";

  static String m51(count) => "${count} stop";

  static String m52(created, updated) =>
      "Created on ${created} · Updated ${updated}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "DoneButton": MessageLookupByLibrary.simpleMessage("Done"),
    "SendOtpTitle": MessageLookupByLibrary.simpleMessage("Send OTP"),
    "addFightButton": MessageLookupByLibrary.simpleMessage("Add Fight"),
    "addNewCardTitle": MessageLookupByLibrary.simpleMessage("Add New Card"),
    "adults": MessageLookupByLibrary.simpleMessage("Adults"),
    "alreadyHaveAcc": MessageLookupByLibrary.simpleMessage(
      "Already have an account? ",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Flight Booking"),
    "applyButton": MessageLookupByLibrary.simpleMessage("Apply"),
    "arrival": MessageLookupByLibrary.simpleMessage("Arrival"),
    "bagPolicyTitle": MessageLookupByLibrary.simpleMessage("Baggage Policy"),
    "baggageCabinLabel": MessageLookupByLibrary.simpleMessage("Cabin baggage:"),
    "baggageCheckedLabel": MessageLookupByLibrary.simpleMessage(
      "Checked baggage:",
    ),
    "baggageDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "Baggage details",
    ),
    "baggageNotIncluded": MessageLookupByLibrary.simpleMessage("Not included"),
    "baggagePiece": m0,
    "baggagePieces": m1,
    "bookFlightTitle": MessageLookupByLibrary.simpleMessage(
      "Book your flight with confidence",
    ),
    "bookingBalance": MessageLookupByLibrary.simpleMessage("Balance"),
    "bookingBusSeat": MessageLookupByLibrary.simpleMessage("Seat"),
    "bookingCarDays": MessageLookupByLibrary.simpleMessage("days"),
    "bookingCarPickup": MessageLookupByLibrary.simpleMessage("Pickup"),
    "bookingCarReturn": MessageLookupByLibrary.simpleMessage("Return"),
    "bookingCategoryBus": MessageLookupByLibrary.simpleMessage("Bus"),
    "bookingCategoryCars": MessageLookupByLibrary.simpleMessage("Cars"),
    "bookingCategoryFlights": MessageLookupByLibrary.simpleMessage("Flights"),
    "bookingCategoryHotels": MessageLookupByLibrary.simpleMessage("Hotels"),
    "bookingDetailAdults": MessageLookupByLibrary.simpleMessage("Adults"),
    "bookingDetailArrival": MessageLookupByLibrary.simpleMessage("Arrival"),
    "bookingDetailBookingDate": MessageLookupByLibrary.simpleMessage(
      "Booking date",
    ),
    "bookingDetailBookingId": MessageLookupByLibrary.simpleMessage(
      "Booking ID",
    ),
    "bookingDetailChildren": MessageLookupByLibrary.simpleMessage("Children"),
    "bookingDetailClass": MessageLookupByLibrary.simpleMessage("Class"),
    "bookingDetailDeparture": MessageLookupByLibrary.simpleMessage("Departure"),
    "bookingDetailInfants": MessageLookupByLibrary.simpleMessage("Infants"),
    "bookingDetailLastTicketDate": MessageLookupByLibrary.simpleMessage(
      "Last ticket date",
    ),
    "bookingDetailMulti": MessageLookupByLibrary.simpleMessage(
      "Multi-destination",
    ),
    "bookingDetailOneway": MessageLookupByLibrary.simpleMessage("One way"),
    "bookingDetailPassenger": MessageLookupByLibrary.simpleMessage("Passenger"),
    "bookingDetailRoundtrip": MessageLookupByLibrary.simpleMessage(
      "Round trip",
    ),
    "bookingDetailSegment": MessageLookupByLibrary.simpleMessage("Segment"),
    "bookingDetailSegments": MessageLookupByLibrary.simpleMessage(
      "Flight segments",
    ),
    "bookingDetailStatus": MessageLookupByLibrary.simpleMessage("Status"),
    "bookingDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Reservation details",
    ),
    "bookingDetailTotalPrice": MessageLookupByLibrary.simpleMessage(
      "Total price",
    ),
    "bookingDetailTripType": MessageLookupByLibrary.simpleMessage("Trip type"),
    "bookingDetails": MessageLookupByLibrary.simpleMessage("Details"),
    "bookingEmptyActive": MessageLookupByLibrary.simpleMessage(
      "No active bookings",
    ),
    "bookingEmptyCancelled": MessageLookupByLibrary.simpleMessage(
      "No cancelled bookings",
    ),
    "bookingEmptyDefault": MessageLookupByLibrary.simpleMessage("No bookings"),
    "bookingEmptyPast": MessageLookupByLibrary.simpleMessage("No past trips"),
    "bookingEmptyStateSubtitle": MessageLookupByLibrary.simpleMessage(
      "When you book a trip, it will appear here.",
    ),
    "bookingEmptyStateTitle": MessageLookupByLibrary.simpleMessage(
      "No trips yet",
    ),
    "bookingHotelCheckIn": MessageLookupByLibrary.simpleMessage("Check-in"),
    "bookingHotelCheckOut": MessageLookupByLibrary.simpleMessage("Check-out"),
    "bookingHotelGuests": MessageLookupByLibrary.simpleMessage("guests"),
    "bookingHotelNights": MessageLookupByLibrary.simpleMessage("nights"),
    "bookingHotelRoom": MessageLookupByLibrary.simpleMessage("room"),
    "bookingLoadError": MessageLookupByLibrary.simpleMessage(
      "Unable to load bookings",
    ),
    "bookingLoginRequired": MessageLookupByLibrary.simpleMessage(
      "Please log in to see your bookings",
    ),
    "bookingPassengers": MessageLookupByLibrary.simpleMessage("passengers"),
    "bookingPnr": MessageLookupByLibrary.simpleMessage("PNR"),
    "bookingRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "bookingSearchFlights": MessageLookupByLibrary.simpleMessage(
      "Search flights",
    ),
    "bookingTabActive": MessageLookupByLibrary.simpleMessage("Active"),
    "bookingTabCancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
    "bookingTabPast": MessageLookupByLibrary.simpleMessage("Past"),
    "bookingTitle": MessageLookupByLibrary.simpleMessage("Bookings"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cardAirline": MessageLookupByLibrary.simpleMessage("Airline"),
    "cardBaggageIncluded": MessageLookupByLibrary.simpleMessage(
      "Baggage included",
    ),
    "cardBaggageShort": MessageLookupByLibrary.simpleMessage("Baggage"),
    "cardBook": MessageLookupByLibrary.simpleMessage("Book"),
    "cardDetailsText": MessageLookupByLibrary.simpleMessage("Details"),
    "cardDirect": MessageLookupByLibrary.simpleMessage("Direct"),
    "cardDirectFlight": MessageLookupByLibrary.simpleMessage("Direct flight"),
    "cardDirectFlights": MessageLookupByLibrary.simpleMessage("Direct flights"),
    "cardFlightDetailsText": MessageLookupByLibrary.simpleMessage(
      "Flight details",
    ),
    "cardFlightInfo": MessageLookupByLibrary.simpleMessage(
      "Flight information",
    ),
    "cardFlightNumber": MessageLookupByLibrary.simpleMessage("Flight number"),
    "cardHoldBaggage": MessageLookupByLibrary.simpleMessage("Hold baggage"),
    "cardJourney": m2,
    "cardMultiDestFull": m3,
    "cardMultiDestShort": m4,
    "cardPerPerson": MessageLookupByLibrary.simpleMessage("per person"),
    "cardPerPersonShort": MessageLookupByLibrary.simpleMessage("/pers."),
    "cardRecommended": MessageLookupByLibrary.simpleMessage("Recommended"),
    "cardRefundable": MessageLookupByLibrary.simpleMessage("Refundable"),
    "cardStop": m5,
    "cardStopShort": m6,
    "cardStops": m7,
    "cardStopsTotal": m8,
    "cardStopsTotalPlural": m9,
    "cardWeightIncluded": m10,
    "changePwConfirmHint": MessageLookupByLibrary.simpleMessage(
      "Confirm your new password",
    ),
    "changePwConfirmLabel": MessageLookupByLibrary.simpleMessage(
      "Confirm new password",
    ),
    "changePwConfirmRequired": MessageLookupByLibrary.simpleMessage(
      "Please confirm your password",
    ),
    "changePwCurrentHint": MessageLookupByLibrary.simpleMessage(
      "Enter your current password",
    ),
    "changePwCurrentLabel": MessageLookupByLibrary.simpleMessage(
      "Current password",
    ),
    "changePwCurrentRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter your current password",
    ),
    "changePwFailed": MessageLookupByLibrary.simpleMessage(
      "Password update failed",
    ),
    "changePwInfoText": MessageLookupByLibrary.simpleMessage(
      "Your new password must be at least 8 characters",
    ),
    "changePwMinLength": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 8 characters",
    ),
    "changePwMismatch": MessageLookupByLibrary.simpleMessage(
      "New passwords do not match",
    ),
    "changePwNewHint": MessageLookupByLibrary.simpleMessage(
      "Enter your new password",
    ),
    "changePwNewLabel": MessageLookupByLibrary.simpleMessage("New password"),
    "changePwNewRequired": MessageLookupByLibrary.simpleMessage(
      "Please enter a new password",
    ),
    "changePwNoMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "changePwSuccess": MessageLookupByLibrary.simpleMessage(
      "Password updated successfully",
    ),
    "child": MessageLookupByLibrary.simpleMessage("Child"),
    "chipAll": MessageLookupByLibrary.simpleMessage("All"),
    "classBusiness": MessageLookupByLibrary.simpleMessage("Business"),
    "classEconomy": MessageLookupByLibrary.simpleMessage("Economy"),
    "classTitle": MessageLookupByLibrary.simpleMessage("Class"),
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "contactInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Contact Information",
    ),
    "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
    "convenienceFee": MessageLookupByLibrary.simpleMessage(
      "Convenience Fee Added",
    ),
    "createAccButton": MessageLookupByLibrary.simpleMessage(
      "Create An Account",
    ),
    "createTicketAttachments": MessageLookupByLibrary.simpleMessage(
      "Attachments",
    ),
    "createTicketCloseTicket": MessageLookupByLibrary.simpleMessage(
      "Close ticket",
    ),
    "createTicketConversation": MessageLookupByLibrary.simpleMessage(
      "Conversation",
    ),
    "createTicketCreatedBy": MessageLookupByLibrary.simpleMessage("Created by"),
    "createTicketCreatedOn": MessageLookupByLibrary.simpleMessage("Created on"),
    "createTicketDefaultSubject": MessageLookupByLibrary.simpleMessage(
      "Flight quote request",
    ),
    "createTicketDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "Ticket details",
    ),
    "createTicketMessageHint": MessageLookupByLibrary.simpleMessage(
      "Write your message here...",
    ),
    "createTicketPriority": MessageLookupByLibrary.simpleMessage("Priority"),
    "createTicketPriorityLow": MessageLookupByLibrary.simpleMessage("Low"),
    "createTicketPriorityNormal": MessageLookupByLibrary.simpleMessage(
      "Normal",
    ),
    "createTicketPriorityUrgent": MessageLookupByLibrary.simpleMessage(
      "Urgent",
    ),
    "createTicketSend": MessageLookupByLibrary.simpleMessage("Send"),
    "createTicketServices": MessageLookupByLibrary.simpleMessage("Services"),
    "createTicketStatus": MessageLookupByLibrary.simpleMessage("Status"),
    "createTicketStatusClosed": MessageLookupByLibrary.simpleMessage("Closed"),
    "createTicketStatusInProgress": MessageLookupByLibrary.simpleMessage(
      "In progress",
    ),
    "createTicketStatusOpen": MessageLookupByLibrary.simpleMessage("Open"),
    "createTicketStatusResolved": MessageLookupByLibrary.simpleMessage(
      "Resolved",
    ),
    "createTicketUpdatedOn": MessageLookupByLibrary.simpleMessage("Updated"),
    "createTicketWriteReply": MessageLookupByLibrary.simpleMessage(
      "Write a reply",
    ),
    "createTicketYou": MessageLookupByLibrary.simpleMessage("You"),
    "currencyAlgeria": MessageLookupByLibrary.simpleMessage("Algeria"),
    "currencyFrance": MessageLookupByLibrary.simpleMessage("France"),
    "currencyTitle": MessageLookupByLibrary.simpleMessage("Currency"),
    "currencyTunisia": MessageLookupByLibrary.simpleMessage("Tunisia"),
    "currentLocation": MessageLookupByLibrary.simpleMessage("Current Location"),
    "datePickerConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "datePickerDay": MessageLookupByLibrary.simpleMessage("day"),
    "datePickerDays": MessageLookupByLibrary.simpleMessage("days"),
    "datePickerFri": MessageLookupByLibrary.simpleMessage("Fri."),
    "datePickerMon": MessageLookupByLibrary.simpleMessage("Mon."),
    "datePickerSat": MessageLookupByLibrary.simpleMessage("Sat."),
    "datePickerSelectDate": MessageLookupByLibrary.simpleMessage(
      "Select a date",
    ),
    "datePickerSun": MessageLookupByLibrary.simpleMessage("Sun."),
    "datePickerThu": MessageLookupByLibrary.simpleMessage("Thu."),
    "datePickerTitleOneWay": MessageLookupByLibrary.simpleMessage(
      "Travel date",
    ),
    "datePickerTitleRoundTrip": MessageLookupByLibrary.simpleMessage(
      "Travel dates",
    ),
    "datePickerTripDuration": MessageLookupByLibrary.simpleMessage(
      "Trip duration: ",
    ),
    "datePickerTue": MessageLookupByLibrary.simpleMessage("Tue."),
    "datePickerWed": MessageLookupByLibrary.simpleMessage("Wed."),
    "dateTitle": MessageLookupByLibrary.simpleMessage("Date"),
    "departDate": MessageLookupByLibrary.simpleMessage("Departure Date"),
    "departDateTitle": MessageLookupByLibrary.simpleMessage("Departure"),
    "departure": MessageLookupByLibrary.simpleMessage("Departure"),
    "detailAirlineFare": MessageLookupByLibrary.simpleMessage(
      "Fare offered by the airline",
    ),
    "detailAvailable": MessageLookupByLibrary.simpleMessage("Available"),
    "detailBookingTitle": MessageLookupByLibrary.simpleMessage("Booking"),
    "detailCabinBaggage": MessageLookupByLibrary.simpleMessage("Cabin baggage"),
    "detailCancellation": MessageLookupByLibrary.simpleMessage("Cancellation"),
    "detailCancellationFees": m11,
    "detailCheckedBaggage": MessageLookupByLibrary.simpleMessage(
      "Checked baggage",
    ),
    "detailDateChange": MessageLookupByLibrary.simpleMessage("Date change"),
    "detailDateChangeFees": m12,
    "detailInFlight": m13,
    "detailMeals": MessageLookupByLibrary.simpleMessage("Meals"),
    "detailNonStopInfo": m14,
    "detailOvernightLayover": m15,
    "detailSeatSelection": MessageLookupByLibrary.simpleMessage(
      "Seat selection",
    ),
    "detailStopInfo": m16,
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "editAirportAll": m17,
    "editAirportSingle": m18,
    "editButton": MessageLookupByLibrary.simpleMessage("Edit"),
    "editPassengerSummary": m19,
    "editProfileAddressHint": MessageLookupByLibrary.simpleMessage(
      "123 Main Street",
    ),
    "editProfileAddressLabel": MessageLookupByLibrary.simpleMessage("Address"),
    "editProfileBirthDateHint": MessageLookupByLibrary.simpleMessage(
      "YYYY-MM-DD",
    ),
    "editProfileBirthDateLabel": MessageLookupByLibrary.simpleMessage(
      "Date of birth",
    ),
    "editProfileCityLabel": MessageLookupByLibrary.simpleMessage("City"),
    "editProfileCivility": MessageLookupByLibrary.simpleMessage("Title"),
    "editProfileCountryLabel": MessageLookupByLibrary.simpleMessage("Country"),
    "editProfileEmailHint": MessageLookupByLibrary.simpleMessage(
      "email@example.com",
    ),
    "editProfileEmailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "editProfileErrorGeneric": MessageLookupByLibrary.simpleMessage("Error"),
    "editProfileFillNameEmail": MessageLookupByLibrary.simpleMessage(
      "Please fill in name and email",
    ),
    "editProfileFullNameHint": MessageLookupByLibrary.simpleMessage(
      "First Last Name",
    ),
    "editProfileFullNameLabel": MessageLookupByLibrary.simpleMessage(
      "Full name",
    ),
    "editProfilePersonalInfo": MessageLookupByLibrary.simpleMessage(
      "Personal information",
    ),
    "editProfilePhoneLabel": MessageLookupByLibrary.simpleMessage("Phone"),
    "editProfilePostCodeLabel": MessageLookupByLibrary.simpleMessage(
      "Postal code",
    ),
    "editProfileSelectOption": MessageLookupByLibrary.simpleMessage("Select"),
    "editProfileTitle": MessageLookupByLibrary.simpleMessage("Edit profile"),
    "editProfileUpdate": MessageLookupByLibrary.simpleMessage("Update"),
    "editProfileUpdateError": MessageLookupByLibrary.simpleMessage(
      "Error updating",
    ),
    "editProfileUpdated": MessageLookupByLibrary.simpleMessage(
      "Profile updated",
    ),
    "editProfileUploadFailed": MessageLookupByLibrary.simpleMessage(
      "Image upload failed. Try again.",
    ),
    "editProfileUploadingImage": MessageLookupByLibrary.simpleMessage(
      "Uploading image...",
    ),
    "editRouteInfo": m20,
    "editSelect": MessageLookupByLibrary.simpleMessage("Select"),
    "editSelectClass": MessageLookupByLibrary.simpleMessage("Select class"),
    "editSelectDate": MessageLookupByLibrary.simpleMessage("Select a date"),
    "emailHint": MessageLookupByLibrary.simpleMessage("Enter your email"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "englishTitle": MessageLookupByLibrary.simpleMessage("English"),
    "faqA1": MessageLookupByLibrary.simpleMessage(
      "To book a flight, follow these steps:\n\n1. Search for your flight by entering your departure city, destination and dates\n2. Select the flight that suits you\n3. Choose your travel class (Classic or Flex)\n4. Fill in the passenger information\n5. Proceed to payment\n\nYou will receive your confirmation by email.",
    ),
    "faqA10": MessageLookupByLibrary.simpleMessage(
      "To cancel your booking:\n\n1. Log in to your account\n2. Go to \"My bookings\"\n3. Select the relevant booking\n4. Click \"Cancel\"\n5. Confirm the cancellation\n\nA confirmation email will be sent to you.",
    ),
    "faqA11": MessageLookupByLibrary.simpleMessage(
      "Cancellation fees vary depending on your fare:\n\n• Flex fare: Free cancellation\n• Classic fare: Fee of 5000 DZD per passenger\n\nFor cancellations less than 24h before departure, special conditions apply.",
    ),
    "faqA12": MessageLookupByLibrary.simpleMessage(
      "The refund timeframe is 7 to 14 business days after your request is validated. The amount will be credited to the same payment method used during the booking.",
    ),
    "faqA13": MessageLookupByLibrary.simpleMessage(
      "The baggage allowance depends on your class:\n\n• Economy: 1 bag of 23kg in hold + 1 cabin bag of 8kg\n• Business: 2 bags of 32kg in hold + 1 cabin bag of 12kg\n\nMaximum dimensions vary by airline.",
    ),
    "faqA14": MessageLookupByLibrary.simpleMessage(
      "If your baggage is lost:\n\n1. Report it immediately at the airport baggage counter\n2. Fill in a PIR form (Property Irregularity Report)\n3. Keep your case number\n4. Contact our support with this information\n\nWe will assist you throughout the process.",
    ),
    "faqA15": MessageLookupByLibrary.simpleMessage(
      "Some items require prior declaration:\n\n• Sports equipment (bicycle, ski, golf)\n• Musical instruments\n• Pets\n• Medical equipment\n\nContact us at least 48h before your flight to arrange transport.",
    ),
    "faqA2": MessageLookupByLibrary.simpleMessage(
      "Yes, you can book up to 9 passengers per booking (adults, children and infants combined). Each passenger\'s information will need to be provided during the booking.",
    ),
    "faqA3": MessageLookupByLibrary.simpleMessage(
      "You can add extra baggage:\n\n• During the booking, at the options step\n• After the booking, in the \"Manage my booking\" section\n\nNote: Adding baggage is cheaper during the initial booking.",
    ),
    "faqA4": MessageLookupByLibrary.simpleMessage(
      "We accept the following payment methods:\n\n• Bank cards (Visa, Mastercard)\n• CIB / EDAHABIA card\n• Bank transfer\n• Payment at the agency\n\nAll payments are secure and encrypted.",
    ),
    "faqA5": MessageLookupByLibrary.simpleMessage(
      "If your transaction failed:\n\n1. Check that your card information is correct\n2. Make sure your card is enabled for online payments\n3. Check your payment limit\n4. Try another payment method\n\nIf the problem persists, contact our support.",
    ),
    "faqA6": MessageLookupByLibrary.simpleMessage(
      "Your invoice is automatically sent by email after booking confirmation. You can also download it from the \"My bookings\" section in your personal area.",
    ),
    "faqA7": MessageLookupByLibrary.simpleMessage(
      "To modify your booking:\n\n1. Log in to your account\n2. Go to \"My bookings\"\n3. Select the booking to modify\n4. Click \"Modify\"\n\nNote: Fees may apply depending on your fare (Classic or Flex).",
    ),
    "faqA8": MessageLookupByLibrary.simpleMessage(
      "Name changes are only possible for minor corrections (typo). For a complete passenger change, you must cancel and make a new booking.",
    ),
    "faqA9": MessageLookupByLibrary.simpleMessage(
      "Fees depend on your fare:\n\n• Flex fare: Free modifications\n• Classic fare: Fee of 7000 DZD per passenger\n\n+ Possible fare difference if the new flight is more expensive.",
    ),
    "faqAllCategory": MessageLookupByLibrary.simpleMessage("All"),
    "faqAllQuestions": MessageLookupByLibrary.simpleMessage("All questions"),
    "faqCatBaggage": MessageLookupByLibrary.simpleMessage("Baggage"),
    "faqCatModification": MessageLookupByLibrary.simpleMessage("Modification"),
    "faqCatPayment": MessageLookupByLibrary.simpleMessage("Payment"),
    "faqCatRefund": MessageLookupByLibrary.simpleMessage(
      "Cancellation & Refund",
    ),
    "faqCatReservation": MessageLookupByLibrary.simpleMessage("Booking"),
    "faqContactSupport": MessageLookupByLibrary.simpleMessage(
      "Contact support",
    ),
    "faqNoResults": MessageLookupByLibrary.simpleMessage("No results"),
    "faqNoResultsDesc": MessageLookupByLibrary.simpleMessage(
      "No question matches your search.",
    ),
    "faqNotFoundAnswer": MessageLookupByLibrary.simpleMessage(
      "Didn\'t find your answer?",
    ),
    "faqQ1": MessageLookupByLibrary.simpleMessage("How do I book a flight?"),
    "faqQ10": MessageLookupByLibrary.simpleMessage(
      "How do I cancel my booking?",
    ),
    "faqQ11": MessageLookupByLibrary.simpleMessage(
      "What are the cancellation fees?",
    ),
    "faqQ12": MessageLookupByLibrary.simpleMessage(
      "When will I receive my refund?",
    ),
    "faqQ13": MessageLookupByLibrary.simpleMessage(
      "What is the included baggage allowance?",
    ),
    "faqQ14": MessageLookupByLibrary.simpleMessage(
      "What should I do if my baggage is lost?",
    ),
    "faqQ15": MessageLookupByLibrary.simpleMessage(
      "Can I transport special items?",
    ),
    "faqQ2": MessageLookupByLibrary.simpleMessage(
      "Can I book for multiple passengers?",
    ),
    "faqQ3": MessageLookupByLibrary.simpleMessage(
      "How do I add baggage to my booking?",
    ),
    "faqQ4": MessageLookupByLibrary.simpleMessage(
      "What payment methods are accepted?",
    ),
    "faqQ5": MessageLookupByLibrary.simpleMessage(
      "My transaction failed, what should I do?",
    ),
    "faqQ6": MessageLookupByLibrary.simpleMessage("How do I get an invoice?"),
    "faqQ7": MessageLookupByLibrary.simpleMessage(
      "How do I modify my booking?",
    ),
    "faqQ8": MessageLookupByLibrary.simpleMessage(
      "Can I change the name on my booking?",
    ),
    "faqQ9": MessageLookupByLibrary.simpleMessage(
      "What are the modification fees?",
    ),
    "faqQuestionCount": m21,
    "faqSearchHint": MessageLookupByLibrary.simpleMessage(
      "Search a question...",
    ),
    "faqSupportAvailable": MessageLookupByLibrary.simpleMessage(
      "Our support team is available to help you.",
    ),
    "faqTitle": MessageLookupByLibrary.simpleMessage("FAQ"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "filterArrivalAt": m22,
    "filterArrivalDefault": MessageLookupByLibrary.simpleMessage("Arrival"),
    "filterDepartureDefault": MessageLookupByLibrary.simpleMessage("Departure"),
    "filterDepartureFrom": m23,
    "filterEarlyMorning": MessageLookupByLibrary.simpleMessage("Early morning"),
    "filterEvening": MessageLookupByLibrary.simpleMessage("Evening"),
    "filterLayoversVia": MessageLookupByLibrary.simpleMessage("Layovers via"),
    "filterMax": m24,
    "filterMin": m25,
    "filterMorning": MessageLookupByLibrary.simpleMessage("Morning"),
    "filterOutbound": MessageLookupByLibrary.simpleMessage("Outbound"),
    "filterReset": MessageLookupByLibrary.simpleMessage("Reset"),
    "filterReturn": MessageLookupByLibrary.simpleMessage("Return"),
    "filterSelectPriceRange": MessageLookupByLibrary.simpleMessage(
      "Select a price range",
    ),
    "filterTitle": MessageLookupByLibrary.simpleMessage("Filter"),
    "flight": MessageLookupByLibrary.simpleMessage("Flight"),
    "flightDetails": MessageLookupByLibrary.simpleMessage("Flight Details"),
    "flightOfferTitle": MessageLookupByLibrary.simpleMessage(
      "Flight Booking Offers",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "fpAppBarTitle": MessageLookupByLibrary.simpleMessage("Forgot Password"),
    "fpDesc1": MessageLookupByLibrary.simpleMessage(
      "Please enter your phone number below to receive your OTP number.",
    ),
    "fromTitle": MessageLookupByLibrary.simpleMessage("From"),
    "fullNameLabel": MessageLookupByLibrary.simpleMessage("Full Name"),
    "hello": MessageLookupByLibrary.simpleMessage("Hello 👋 "),
    "homeAdultsAge": MessageLookupByLibrary.simpleMessage("12 years and over"),
    "homeAdvantageSubtitle1": MessageLookupByLibrary.simpleMessage(
      "every time",
    ),
    "homeAdvantageSubtitle2": MessageLookupByLibrary.simpleMessage(
      "at your service",
    ),
    "homeAdvantageTitle1": MessageLookupByLibrary.simpleMessage(
      "Get the best price",
    ),
    "homeAdvantageTitle2": MessageLookupByLibrary.simpleMessage(
      "24/7 Customer service",
    ),
    "homeAdvantagesSection": MessageLookupByLibrary.simpleMessage(
      "Our advantages",
    ),
    "homeBookFlight": MessageLookupByLibrary.simpleMessage("Book your flight"),
    "homeChildAge": MessageLookupByLibrary.simpleMessage(
      "2 to 11 years at the time of travel",
    ),
    "homeClassBusiness": MessageLookupByLibrary.simpleMessage("Business Class"),
    "homeClassBusinessShort": MessageLookupByLibrary.simpleMessage("Business"),
    "homeClassEconomy": MessageLookupByLibrary.simpleMessage("Economy"),
    "homeClassEconomyShort": MessageLookupByLibrary.simpleMessage("Economy"),
    "homeClassFirst": MessageLookupByLibrary.simpleMessage("First Class"),
    "homeClassFirstShort": MessageLookupByLibrary.simpleMessage("First"),
    "homeClassLabel": MessageLookupByLibrary.simpleMessage("Class"),
    "homeClassPremiumEconomy": MessageLookupByLibrary.simpleMessage(
      "Premium Economy",
    ),
    "homeClassPremiumEconomyShort": MessageLookupByLibrary.simpleMessage(
      "Prem. Economy",
    ),
    "homeDefaultDeparture": MessageLookupByLibrary.simpleMessage("Departure"),
    "homeDefaultDestination": MessageLookupByLibrary.simpleMessage(
      "Destination",
    ),
    "homeDeparture": MessageLookupByLibrary.simpleMessage("Departure"),
    "homeDeparturePlace": MessageLookupByLibrary.simpleMessage(
      "Departure place",
    ),
    "homeDestination": MessageLookupByLibrary.simpleMessage("Destination"),
    "homeDirectFlights": MessageLookupByLibrary.simpleMessage("Direct flights"),
    "homeDone": MessageLookupByLibrary.simpleMessage("Done"),
    "homeErrorPrefix": m26,
    "homeGreeting": m27,
    "homeInfantAge": MessageLookupByLibrary.simpleMessage(
      "Under 2 years at the time of travel",
    ),
    "homeMultiMinFlights": MessageLookupByLibrary.simpleMessage(
      "Please add at least 2 flights for multi-destination search.",
    ),
    "homeOffersSection": MessageLookupByLibrary.simpleMessage(
      "Our offers for you",
    ),
    "homePassengerClass": MessageLookupByLibrary.simpleMessage(
      "Passenger & Class",
    ),
    "homePassengerCount": m28,
    "homePassengerNote": MessageLookupByLibrary.simpleMessage(
      "Children and infants must be accompanied by an adult during the flight.",
    ),
    "homeReturn": MessageLookupByLibrary.simpleMessage("Return"),
    "homeSearchError": MessageLookupByLibrary.simpleMessage("Search error"),
    "homeSearchFlights": MessageLookupByLibrary.simpleMessage("Search flights"),
    "homeSearching": MessageLookupByLibrary.simpleMessage("Searching..."),
    "homeSelectAirport": MessageLookupByLibrary.simpleMessage(
      "Select an airport",
    ),
    "homeSelectAirportsError": MessageLookupByLibrary.simpleMessage(
      "Please select departure and arrival airports.",
    ),
    "homeSelectAirportsFlight1": MessageLookupByLibrary.simpleMessage(
      "Please select departure and arrival airports for flight 1.",
    ),
    "homeSelectAirportsFlightN": m29,
    "homeSelectDateFlight1": MessageLookupByLibrary.simpleMessage(
      "Please select a departure date for flight 1.",
    ),
    "homeSelectDateFlightN": m30,
    "homeSelectDepartureDate": MessageLookupByLibrary.simpleMessage(
      "Please select a departure date.",
    ),
    "homeSelectReturnDate": MessageLookupByLibrary.simpleMessage(
      "Please select a return date.",
    ),
    "homeSenior": MessageLookupByLibrary.simpleMessage("Senior"),
    "homeSeniorTooltip": MessageLookupByLibrary.simpleMessage(
      "Men 55+ and women 60+, AIR ALGERIE to FRANCE only",
    ),
    "homeWelcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "homeWithBaggage": MessageLookupByLibrary.simpleMessage("With baggage"),
    "homeYoung": MessageLookupByLibrary.simpleMessage("Young"),
    "homeYoungTooltip": MessageLookupByLibrary.simpleMessage(
      "Between 12 and 24 years old, domestic flights only",
    ),
    "inFlight": m31,
    "inboxEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "You will receive alerts about your trips and your account. Have you chosen your next destination yet?",
    ),
    "inboxEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No notifications yet",
    ),
    "inboxExploreButton": MessageLookupByLibrary.simpleMessage("Explore"),
    "inboxTitle": MessageLookupByLibrary.simpleMessage("Inbox"),
    "infants": MessageLookupByLibrary.simpleMessage("Infants"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lastNameHint": MessageLookupByLibrary.simpleMessage("Enter Last Name"),
    "lastNameTitle": MessageLookupByLibrary.simpleMessage("Last Name"),
    "layoverAt": m32,
    "layoverDuration": m33,
    "loadingAwaitsYou": MessageLookupByLibrary.simpleMessage(" awaits you!"),
    "loadingConnectingTo": MessageLookupByLibrary.simpleMessage(
      "CONNECTING TO",
    ),
    "loadingFlightsFound": MessageLookupByLibrary.simpleMessage(
      "flights found",
    ),
    "loadingMeanwhile": MessageLookupByLibrary.simpleMessage("Meanwhile"),
    "loadingPleaseWait": MessageLookupByLibrary.simpleMessage("Please wait..."),
    "loadingPromoAccommodation": MessageLookupByLibrary.simpleMessage(
      "accommodation",
    ),
    "loadingPromoText1": MessageLookupByLibrary.simpleMessage(
      "Don\'t forget! Save up to ",
    ),
    "loadingPromoText2": MessageLookupByLibrary.simpleMessage(" on your "),
    "loadingProviders": MessageLookupByLibrary.simpleMessage("providers"),
    "loadingResults": MessageLookupByLibrary.simpleMessage("Results"),
    "loadingResultsLabel": MessageLookupByLibrary.simpleMessage("RESULTS"),
    "loadingSearchError": m34,
    "loadingSearchingFlights": MessageLookupByLibrary.simpleMessage(
      "Searching for flights",
    ),
    "loginButton": MessageLookupByLibrary.simpleMessage("Log In"),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Log In Your Account"),
    "myBookingTitle": MessageLookupByLibrary.simpleMessage("My Booking"),
    "myProfileTitle": MessageLookupByLibrary.simpleMessage("My Profile"),
    "nameHint": MessageLookupByLibrary.simpleMessage("Enter your full name"),
    "nameLabel": MessageLookupByLibrary.simpleMessage("Full Name"),
    "nameTitle": MessageLookupByLibrary.simpleMessage("First & Middle Name"),
    "navBarTitle1": MessageLookupByLibrary.simpleMessage("Home"),
    "navBarTitle2": MessageLookupByLibrary.simpleMessage("My Booking"),
    "navBarTitle3": MessageLookupByLibrary.simpleMessage("History"),
    "navBarTitle4": MessageLookupByLibrary.simpleMessage("Profile"),
    "navBookings": MessageLookupByLibrary.simpleMessage("Bookings"),
    "navMyAccount": MessageLookupByLibrary.simpleMessage("My account"),
    "navSearch": MessageLookupByLibrary.simpleMessage("Search"),
    "navSupport": MessageLookupByLibrary.simpleMessage("Support"),
    "noAccTitle1": MessageLookupByLibrary.simpleMessage(
      "Don’t have an account? ",
    ),
    "noAccTitle2": MessageLookupByLibrary.simpleMessage("Create New Account"),
    "nonStop": m35,
    "notificationAllClear": MessageLookupByLibrary.simpleMessage("Clear All"),
    "notificationMinuteAgo": MessageLookupByLibrary.simpleMessage("1 min ago"),
    "notificationMinutesAgo": m36,
    "notificationPaymentSuccessDesc": MessageLookupByLibrary.simpleMessage(
      "Your payment has been processed successfully.",
    ),
    "notificationPaymentSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "Payment Successful!",
    ),
    "notificationTimeAgo": m37,
    "notificationTitle": MessageLookupByLibrary.simpleMessage("Notification"),
    "notificationToday": MessageLookupByLibrary.simpleMessage("Today"),
    "notificationYesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
    "onBoardSubTitle1": MessageLookupByLibrary.simpleMessage(
      "Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa",
    ),
    "onBoardSubTitle2": MessageLookupByLibrary.simpleMessage(
      "Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa",
    ),
    "onBoardSubTitle3": MessageLookupByLibrary.simpleMessage(
      "Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa",
    ),
    "onBoardTagline": MessageLookupByLibrary.simpleMessage("You set the time"),
    "onBoardTitle1": MessageLookupByLibrary.simpleMessage(
      "Book now\nand pay on arrival",
    ),
    "onBoardTitle2": MessageLookupByLibrary.simpleMessage(
      "Find the best\nflights at the best price",
    ),
    "onBoardTitle3": MessageLookupByLibrary.simpleMessage(
      "Travel with complete\npeace of mind",
    ),
    "onwardTitle": MessageLookupByLibrary.simpleMessage("Onward"),
    "orSignUpTitle": MessageLookupByLibrary.simpleMessage("Or Sign up with"),
    "otpCodeSent": m38,
    "otpCodeSentTo": MessageLookupByLibrary.simpleMessage(
      "We sent a verification code to:\n",
    ),
    "otpCodeSentToShort": MessageLookupByLibrary.simpleMessage(
      "Code sent to: ",
    ),
    "otpDesc1": MessageLookupByLibrary.simpleMessage(
      "6-digits pin has been sent to your email address, ",
    ),
    "otpDesc2": MessageLookupByLibrary.simpleMessage("riead2562@gmail.com"),
    "otpEmailFallback": MessageLookupByLibrary.simpleMessage("email address"),
    "otpEnterToContinue": MessageLookupByLibrary.simpleMessage(
      "\nPlease enter it to continue.",
    ),
    "otpRegistrationSuccess": MessageLookupByLibrary.simpleMessage(
      "Registration successful! Please sign in.",
    ),
    "otpResendError": MessageLookupByLibrary.simpleMessage(
      "Error resending code.",
    ),
    "otpResendFailed": MessageLookupByLibrary.simpleMessage(
      "Unable to resend code. Try again.",
    ),
    "otpResendTitle1": MessageLookupByLibrary.simpleMessage(
      "Didn’t receive code? ",
    ),
    "otpResendTitle2": MessageLookupByLibrary.simpleMessage("Resend Code"),
    "otpTitle": MessageLookupByLibrary.simpleMessage("OTP"),
    "otpVerifyEmail": MessageLookupByLibrary.simpleMessage(
      "Verify email address",
    ),
    "otpVerifyTitle": MessageLookupByLibrary.simpleMessage(
      "Verify your email address to sign in",
    ),
    "otpVerifyTitleShort": MessageLookupByLibrary.simpleMessage(
      "Verify your email address",
    ),
    "otpVerifying": MessageLookupByLibrary.simpleMessage("Verifying..."),
    "otpWrongCode": MessageLookupByLibrary.simpleMessage(
      "Incorrect code, please try again",
    ),
    "paid": MessageLookupByLibrary.simpleMessage("Paid"),
    "passengerMale": m39,
    "passwordHint": MessageLookupByLibrary.simpleMessage("Enter your password"),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
    "paymentCardTitle": MessageLookupByLibrary.simpleMessage(
      "Your payment cards",
    ),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("Payment Method"),
    "paymentTitle": MessageLookupByLibrary.simpleMessage("Payment"),
    "phoneHint": MessageLookupByLibrary.simpleMessage(
      "Enter your phone number",
    ),
    "phoneLabel": MessageLookupByLibrary.simpleMessage("Phone"),
    "pillFlightsAvailable": m40,
    "pillLoading": MessageLookupByLibrary.simpleMessage(
      "Getting all available flights",
    ),
    "priceAdultFallback": MessageLookupByLibrary.simpleMessage("1x Adult"),
    "priceBaseFare": MessageLookupByLibrary.simpleMessage("Base fare"),
    "priceDetailsTitle": MessageLookupByLibrary.simpleMessage("Price details"),
    "priceNonRefundable": MessageLookupByLibrary.simpleMessage(
      "Non-refundable",
    ),
    "priceTaxesPer": m41,
    "priceTaxesPerAdult": MessageLookupByLibrary.simpleMessage(
      "Taxes per adult",
    ),
    "priceTotalInclTax": MessageLookupByLibrary.simpleMessage(
      "Total incl. tax",
    ),
    "privacyContact": MessageLookupByLibrary.simpleMessage(
      "If you have any questions about this Privacy Policy, please contact us at info@h24voyages.com.",
    ),
    "privacyContactTitle": MessageLookupByLibrary.simpleMessage("Contact Us"),
    "privacyInfoCollection": MessageLookupByLibrary.simpleMessage(
      "We collect personal information when you make a booking or register on our site...",
    ),
    "privacyInfoCollectionTitle": MessageLookupByLibrary.simpleMessage(
      "Information We Collect",
    ),
    "privacyPolicyIntroduction": MessageLookupByLibrary.simpleMessage(
      "At H24 Voyages, we are committed to protecting your privacy and ensuring that your personal information is handled in a safe and responsible manner.",
    ),
    "privacyPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Privacy Policy",
    ),
    "privacySecurity": MessageLookupByLibrary.simpleMessage(
      "We implement security measures to protect your data, but no transmission over the internet can be guaranteed secure.",
    ),
    "privacySecurityTitle": MessageLookupByLibrary.simpleMessage(
      "Security of Your Data",
    ),
    "privacySharing": MessageLookupByLibrary.simpleMessage(
      "We may share data with partners such as airlines, hotels, and payment processors as necessary...",
    ),
    "privacySharingTitle": MessageLookupByLibrary.simpleMessage(
      "Sharing of Information",
    ),
    "privacyUse": MessageLookupByLibrary.simpleMessage(
      "Your data is used to process bookings, communicate updates, and provide customer support...",
    ),
    "privacyUseTitle": MessageLookupByLibrary.simpleMessage(
      "How We Use Your Information",
    ),
    "proceedToBook": MessageLookupByLibrary.simpleMessage("Proceed to Book"),
    "profileCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "profileClose": MessageLookupByLibrary.simpleMessage("Close"),
    "profileContactSupport": MessageLookupByLibrary.simpleMessage(
      "Contact customer service",
    ),
    "profileCurrencies": MessageLookupByLibrary.simpleMessage("Currencies"),
    "profileDisable": MessageLookupByLibrary.simpleMessage("Disable"),
    "profileDisableAccount": MessageLookupByLibrary.simpleMessage(
      "Disable account",
    ),
    "profileDisableConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to disable your account? This action is irreversible and you will be logged out.",
    ),
    "profileDisableFailed": MessageLookupByLibrary.simpleMessage(
      "Account deactivation failed",
    ),
    "profileDisableSuccess": MessageLookupByLibrary.simpleMessage(
      "Account disabled successfully",
    ),
    "profileError": m42,
    "profileFaq": MessageLookupByLibrary.simpleMessage("FAQ"),
    "profileHelpSection": MessageLookupByLibrary.simpleMessage("Help"),
    "profileLanguages": MessageLookupByLibrary.simpleMessage("Languages"),
    "profileLogout": MessageLookupByLibrary.simpleMessage("Log Out"),
    "profileLogoutAction": MessageLookupByLibrary.simpleMessage("Log out"),
    "profileLogoutButton": MessageLookupByLibrary.simpleMessage("Log out"),
    "profileLogoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to log out?",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Logout"),
    "profileManageAccount": MessageLookupByLibrary.simpleMessage(
      "Manage my account",
    ),
    "profileMyProfile": MessageLookupByLibrary.simpleMessage("My Profile"),
    "profileNotifications": MessageLookupByLibrary.simpleMessage(
      "Notifications",
    ),
    "profilePayments": MessageLookupByLibrary.simpleMessage("Payments"),
    "profilePersonalInfo": MessageLookupByLibrary.simpleMessage(
      "Personal details",
    ),
    "profilePrivacy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "profileReferFriend": MessageLookupByLibrary.simpleMessage(
      "Refer a friend",
    ),
    "profileReferralMessage": MessageLookupByLibrary.simpleMessage(
      "Share your referral code with your friends!",
    ),
    "profileReferralTitle": MessageLookupByLibrary.simpleMessage("Referral"),
    "profileRegisteredTravelers": MessageLookupByLibrary.simpleMessage(
      "Registered travelers",
    ),
    "profileSecuritySettings": MessageLookupByLibrary.simpleMessage(
      "Security settings",
    ),
    "profileSetting": MessageLookupByLibrary.simpleMessage("Setting"),
    "profileSettingsSection": MessageLookupByLibrary.simpleMessage("Settings"),
    "profileShare": MessageLookupByLibrary.simpleMessage("Share App"),
    "profileTerms": MessageLookupByLibrary.simpleMessage(
      "Terms and conditions",
    ),
    "profileTitle": MessageLookupByLibrary.simpleMessage("Profile"),
    "promoCodeTitle": MessageLookupByLibrary.simpleMessage("Enter Promocode"),
    "recentPlaceTitle": MessageLookupByLibrary.simpleMessage("Recent Places"),
    "recentSearch": MessageLookupByLibrary.simpleMessage("Recent Searched"),
    "refundPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Cancellation Refund Policy",
    ),
    "registerEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "registerError": MessageLookupByLibrary.simpleMessage("Registration error"),
    "registerFieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "registerFirstName": MessageLookupByLibrary.simpleMessage("First name"),
    "registerLastName": MessageLookupByLibrary.simpleMessage("Last name"),
    "registerPassword": MessageLookupByLibrary.simpleMessage("Password"),
    "registerPasswordMinLength": MessageLookupByLibrary.simpleMessage(
      "At least 6 characters",
    ),
    "registerPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Password required",
    ),
    "registerSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign up now to h24voyages\nand access our services.",
    ),
    "registerTitle": MessageLookupByLibrary.simpleMessage("Sign up"),
    "registerUnknownError": MessageLookupByLibrary.simpleMessage(
      "Unknown error",
    ),
    "returnDate": MessageLookupByLibrary.simpleMessage("Return Date"),
    "returnDateTitle": MessageLookupByLibrary.simpleMessage("Return"),
    "returnTitle": MessageLookupByLibrary.simpleMessage("Return"),
    "searchEditSearch": MessageLookupByLibrary.simpleMessage("Edit search"),
    "searchErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Access denied to the search service.\nPlease log in again.",
    ),
    "searchErrorNoFlights": MessageLookupByLibrary.simpleMessage(
      "No flights available for these criteria.\nTry other dates or destinations.",
    ),
    "searchErrorNoInternet": MessageLookupByLibrary.simpleMessage(
      "Internet connection unavailable.\nCheck your connection and try again.",
    ),
    "searchErrorNotFound": MessageLookupByLibrary.simpleMessage(
      "The search service is unavailable.\nPlease try again later.",
    ),
    "searchErrorServer": MessageLookupByLibrary.simpleMessage(
      "The search service is temporarily unavailable.\nPlease try again later.",
    ),
    "searchErrorSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Your session has expired.\nPlease log in again and retry.",
    ),
    "searchErrorTimeout": MessageLookupByLibrary.simpleMessage(
      "The server is taking too long to respond.\nPlease try again in a moment.",
    ),
    "searchErrorTooMany": MessageLookupByLibrary.simpleMessage(
      "Too many searches in a short time.\nPlease wait before trying again.",
    ),
    "searchErrorUnexpected": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred.\nPlease try again or modify your criteria.",
    ),
    "searchFlight": MessageLookupByLibrary.simpleMessage("Search Flight"),
    "searchLoadingFlights": MessageLookupByLibrary.simpleMessage(
      "Loading flights...",
    ),
    "searchNoFlightsForFilters": MessageLookupByLibrary.simpleMessage(
      "No flights match your filters",
    ),
    "searchNoFlightsFound": MessageLookupByLibrary.simpleMessage(
      "No flights found",
    ),
    "searchPageInfo": m43,
    "searchResetFilters": MessageLookupByLibrary.simpleMessage("Reset filters"),
    "searchScreenTitle": MessageLookupByLibrary.simpleMessage("Where from?"),
    "searchScrollForMore": MessageLookupByLibrary.simpleMessage(
      "Scroll to load more flights",
    ),
    "searchSheetHint": MessageLookupByLibrary.simpleMessage(
      "Country, city or airport",
    ),
    "searchSheetRecent": MessageLookupByLibrary.simpleMessage("Recent"),
    "searchSheetResults": MessageLookupByLibrary.simpleMessage(
      "Search results",
    ),
    "searchStayDuration": MessageLookupByLibrary.simpleMessage(
      "Stay duration: ",
    ),
    "searchTryModifyDates": MessageLookupByLibrary.simpleMessage(
      "Try modifying your dates or\nyour search criteria",
    ),
    "searchTryModifyFilters": MessageLookupByLibrary.simpleMessage(
      "Try modifying or resetting\nyour filters to see more results",
    ),
    "searchUnavailable": MessageLookupByLibrary.simpleMessage(
      "Search unavailable",
    ),
    "segmentAirportFallback": m44,
    "segmentBaggage": MessageLookupByLibrary.simpleMessage("Baggage"),
    "segmentCabinBag": m45,
    "segmentCheckedBag": m46,
    "segmentFlightInfo": m47,
    "segmentSeats": m48,
    "segmentTerminal": m49,
    "selectGenderTitle": MessageLookupByLibrary.simpleMessage("Select Gender"),
    "selectService": MessageLookupByLibrary.simpleMessage("Select Services"),
    "settingTitle": MessageLookupByLibrary.simpleMessage("Setting"),
    "sheetApply": MessageLookupByLibrary.simpleMessage("Apply"),
    "sheetBookFlight": MessageLookupByLibrary.simpleMessage("Book this flight"),
    "sheetFlightDetails": MessageLookupByLibrary.simpleMessage(
      "Flight details",
    ),
    "sheetOneWay": MessageLookupByLibrary.simpleMessage("One way flight"),
    "sheetPricePerPerson": m50,
    "sheetRoundTrip": MessageLookupByLibrary.simpleMessage("Round trip flight"),
    "signUpButton": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "signUpEmailEmpty": MessageLookupByLibrary.simpleMessage(
      "Please enter your email address",
    ),
    "signUpEmailHint": MessageLookupByLibrary.simpleMessage("email@email.com"),
    "signUpEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "signUpEmailLabel": MessageLookupByLibrary.simpleMessage("Email address"),
    "signUpError": MessageLookupByLibrary.simpleMessage("Error"),
    "signUpLoginError": MessageLookupByLibrary.simpleMessage("Login error"),
    "signUpRegister": MessageLookupByLibrary.simpleMessage("Sign up"),
    "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign in with your h24voyages account\nand access our services.",
    ),
    "signUpTermsShort": MessageLookupByLibrary.simpleMessage(
      "By signing in, you agree to",
    ),
    "signUpTitle": MessageLookupByLibrary.simpleMessage(
      "Sign in or create an account",
    ),
    "skipButton": MessageLookupByLibrary.simpleMessage("Skip"),
    "sortArrivalShort": MessageLookupByLibrary.simpleMessage("Arrival"),
    "sortArrivalTime": MessageLookupByLibrary.simpleMessage("Arrival time"),
    "sortBy": MessageLookupByLibrary.simpleMessage("Sort by"),
    "sortCheapest": MessageLookupByLibrary.simpleMessage("Cheapest"),
    "sortCheapestShort": MessageLookupByLibrary.simpleMessage("Price ↑"),
    "sortDefaultShort": MessageLookupByLibrary.simpleMessage("Sort"),
    "sortDepartureShort": MessageLookupByLibrary.simpleMessage("Departure"),
    "sortDepartureTime": MessageLookupByLibrary.simpleMessage("Departure time"),
    "sortDurationShort": MessageLookupByLibrary.simpleMessage("Duration"),
    "sortExpensiveShort": MessageLookupByLibrary.simpleMessage("Price ↓"),
    "sortFlightDuration": MessageLookupByLibrary.simpleMessage(
      "Flight duration",
    ),
    "sortMostExpensive": MessageLookupByLibrary.simpleMessage("Most expensive"),
    "statusCancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
    "statusCompleted": MessageLookupByLibrary.simpleMessage("Completed"),
    "statusConfirmed": MessageLookupByLibrary.simpleMessage("Confirmed"),
    "statusFailureTicket": MessageLookupByLibrary.simpleMessage(
      "Failure Ticket",
    ),
    "statusInProgress": MessageLookupByLibrary.simpleMessage("In progress"),
    "statusPending": MessageLookupByLibrary.simpleMessage("Pending"),
    "statusPnrPending": MessageLookupByLibrary.simpleMessage("PNR pending"),
    "stopCount": m51,
    "supportBanner": MessageLookupByLibrary.simpleMessage(
      "Manage and track your requests in real time",
    ),
    "supportDetails": MessageLookupByLibrary.simpleMessage("Details"),
    "supportFilter": MessageLookupByLibrary.simpleMessage("Filter"),
    "supportHelpdesk": MessageLookupByLibrary.simpleMessage("Helpdesk"),
    "supportStatusActive": MessageLookupByLibrary.simpleMessage("Active"),
    "supportStatusClosed": MessageLookupByLibrary.simpleMessage("Closed"),
    "supportStatusInProgress": MessageLookupByLibrary.simpleMessage(
      "in progress",
    ),
    "supportStatusResolved": MessageLookupByLibrary.simpleMessage("Resolved"),
    "supportTabActive": MessageLookupByLibrary.simpleMessage("Active"),
    "supportTabAll": MessageLookupByLibrary.simpleMessage("All"),
    "supportTabClosed": MessageLookupByLibrary.simpleMessage("Closed"),
    "supportTabResolved": MessageLookupByLibrary.simpleMessage("Resolved"),
    "supportTicket": MessageLookupByLibrary.simpleMessage("Ticket"),
    "supportTitle": MessageLookupByLibrary.simpleMessage("Customer support"),
    "tab1": MessageLookupByLibrary.simpleMessage("One Ways"),
    "tab2": MessageLookupByLibrary.simpleMessage("Round Trip"),
    "tab3": MessageLookupByLibrary.simpleMessage("Multicity"),
    "ticketDetailCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "ticketDetailClose": MessageLookupByLibrary.simpleMessage("Close"),
    "ticketDetailCloseDialog": MessageLookupByLibrary.simpleMessage(
      "Close the ticket?",
    ),
    "ticketDetailCloseWarning": MessageLookupByLibrary.simpleMessage(
      "You will no longer be able to send messages once the ticket is closed.",
    ),
    "ticketDetailCreatedUpdated": m52,
    "ticketDetailMessageHint": MessageLookupByLibrary.simpleMessage(
      "Write a message...",
    ),
    "ticketDetailStatusClosed": MessageLookupByLibrary.simpleMessage("Closed"),
    "ticketDetailStatusOpen": MessageLookupByLibrary.simpleMessage("Open"),
    "ticketDetailStatusPending": MessageLookupByLibrary.simpleMessage(
      "Pending",
    ),
    "ticketDetailStatusResolved": MessageLookupByLibrary.simpleMessage(
      "Resolved",
    ),
    "ticketDetailStatusUrgent": MessageLookupByLibrary.simpleMessage("Urgent"),
    "ticketDetailTicketClosed": MessageLookupByLibrary.simpleMessage(
      "This ticket is closed",
    ),
    "ticketDetailTitle": MessageLookupByLibrary.simpleMessage("Ticket detail"),
    "ticketStatusTitle": MessageLookupByLibrary.simpleMessage("Ticket Status"),
    "toTitle": MessageLookupByLibrary.simpleMessage("To"),
    "totalPrice": MessageLookupByLibrary.simpleMessage("Total Price"),
    "travellerTitle": MessageLookupByLibrary.simpleMessage("Passengers"),
    "useCurrentLocation": MessageLookupByLibrary.simpleMessage(
      "Use Current Location",
    ),
    "verification": MessageLookupByLibrary.simpleMessage("Verification"),
    "verifyButton": MessageLookupByLibrary.simpleMessage("Verify"),
    "viewAllButton": MessageLookupByLibrary.simpleMessage("View All"),
    "viewDetails": MessageLookupByLibrary.simpleMessage("View Details"),
    "wcDescription": MessageLookupByLibrary.simpleMessage(
      "Pretium, ipsum pretium aliquet mollis cond imentum magna accumsan. Odio elit \ntellus id diam sit. Massa",
    ),
    "wcSubTitle": MessageLookupByLibrary.simpleMessage("Flight Booking"),
    "wcTitle": MessageLookupByLibrary.simpleMessage("Start Your Journey with"),
    "welcomeContinueEmail": MessageLookupByLibrary.simpleMessage(
      "Continue with email",
    ),
    "welcomeContinueGoogle": MessageLookupByLibrary.simpleMessage(
      "Continue with Google",
    ),
    "welcomeCopyright": MessageLookupByLibrary.simpleMessage(
      "All rights reserved. Copyright- h24voyages",
    ),
    "welcomePrivacyPolicy": MessageLookupByLibrary.simpleMessage(
      "privacy policy",
    ),
    "welcomeSkipLogin": MessageLookupByLibrary.simpleMessage(
      "Continue without signing in",
    ),
    "welcomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign in to save at least\n10% with a free h24voyages membership",
    ),
    "welcomeTermsAnd": MessageLookupByLibrary.simpleMessage(" and our "),
    "welcomeTermsConditions": MessageLookupByLibrary.simpleMessage(
      "terms and conditions",
    ),
    "welcomeTermsIntro": MessageLookupByLibrary.simpleMessage(
      "By creating or signing in to an account, you agree to",
    ),
    "welcomeTermsOur": MessageLookupByLibrary.simpleMessage("our "),
    "welcomeTitle": MessageLookupByLibrary.simpleMessage("Sign in to save"),
  };
}
