// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(count) => "${count} pièce";

  static String m1(count) => "${count} pièces";

  static String m2(number) => "Trajet ${number}";

  static String m3(count) => "Multi-destination (${count} trajets)";

  static String m4(count) => "Multi-dest. (${count})";

  static String m5(count) => "${count} escale";

  static String m6(count) => "${count} esc.";

  static String m7(count) => "${count} escales";

  static String m8(count) => "${count} escale au total";

  static String m9(count) => "${count} escales au total";

  static String m10(weight) => "${weight} inclus";

  static String m11(amount, currency) =>
      "Frais d\'annulation à partir de ${amount} ${currency}";

  static String m12(amount, currency) =>
      "Frais de changement de date à partir de ${amount} ${currency}";

  static String m13(duration) => "${duration} en vol";

  static String m14(duration, flightClass) =>
      "Sans escale | ${duration} | ${flightClass}";

  static String m15(city) => "Escale d\'une nuit à ${city}";

  static String m16(stops, duration, flightClass) =>
      "${stops} escale | ${duration} | ${flightClass}";

  static String m17(city, code) => "${city} (${code} - tous les aéroports)";

  static String m18(city, code) => "${city} (${code} - aéroport ..)";

  static String m19(count, className) => "${count} Passager(s), ${className}";

  static String m20(from, to) => "${from} à ${to}";

  static String m21(count) => "${count} questions";

  static String m22(city) => "Arrivée à ${city}";

  static String m23(city) => "Départ de ${city}";

  static String m24(value, currency) => "Max: ${value} ${currency}";

  static String m25(value, currency) => "Min: ${value} ${currency}";

  static String m26(error) => "Erreur: ${error}";

  static String m27(name) => "Bonjour, ${name}";

  static String m28(count) => "${count} Passager(s)";

  static String m29(n) =>
      "Veuillez sélectionner les aéroports pour le vol ${n}.";

  static String m30(n) => "Veuillez sélectionner une date pour le vol ${n}.";

  static String m31(hours) => "${hours} en vol";

  static String m32(airport, code) => "Escale à ${airport} (${code})";

  static String m33(time) => "Durée: ${time}";

  static String m34(error) => "Erreur de recherche: ${error}";

  static String m35(hours) => "Sans escale";

  static String m36(count) => "${count} min";

  static String m37(date, timeAgo) => "${date}, il y a ${timeAgo}";

  static String m38(email) => "Un nouveau code a été envoyé à ${email}";

  static String m39(name) => "${name} (Homme)";

  static String m40(count) => "${count} vols disponibles";

  static String m41(type) => "Taxes par ${type}";

  static String m42(error) => "Erreur: ${error}";

  static String m43(current, total) =>
      "Page ${current} / ${total} - Faites défiler pour plus";

  static String m44(code) => "Aéroport ${code}";

  static String m45(bag) => "Bagage cabine: ${bag}";

  static String m46(bag) => "Bagage en soute: ${bag}";

  static String m47(code, number) => "Vol ${code} ${number}";

  static String m48(count) => "${count} places";

  static String m49(terminal) => "Terminal ${terminal}";

  static String m50(price, currency) => "${price} ${currency}/ pers";

  static String m51(count) => "${count} escale";

  static String m52(created, updated) =>
      "Créé le ${created} · Mis à jour ${updated}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "DoneButton": MessageLookupByLibrary.simpleMessage("Terminé"),
    "SendOtpTitle": MessageLookupByLibrary.simpleMessage("Envoyer OTP"),
    "addFightButton": MessageLookupByLibrary.simpleMessage("Ajouter un vol"),
    "addNewCardTitle": MessageLookupByLibrary.simpleMessage(
      "Ajouter une nouvelle carte",
    ),
    "adults": MessageLookupByLibrary.simpleMessage("Adultes"),
    "alreadyHaveAcc": MessageLookupByLibrary.simpleMessage(
      "Vous avez déjà un compte ? ",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Réservation de vols"),
    "applyButton": MessageLookupByLibrary.simpleMessage("Appliquer"),
    "arrival": MessageLookupByLibrary.simpleMessage("Arrivée"),
    "bagPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Politique des bagages",
    ),
    "baggageCabinLabel": MessageLookupByLibrary.simpleMessage(
      "Bagages à main:",
    ),
    "baggageCheckedLabel": MessageLookupByLibrary.simpleMessage(
      "Bagages en soute:",
    ),
    "baggageDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "Détails bagages",
    ),
    "baggageNotIncluded": MessageLookupByLibrary.simpleMessage("Non inclus"),
    "baggagePiece": m0,
    "baggagePieces": m1,
    "bookFlightTitle": MessageLookupByLibrary.simpleMessage(
      "Réservez votre vol en toute confiance",
    ),
    "bookingBalance": MessageLookupByLibrary.simpleMessage("Solde"),
    "bookingBusSeat": MessageLookupByLibrary.simpleMessage("Siège"),
    "bookingCarDays": MessageLookupByLibrary.simpleMessage("jours"),
    "bookingCarPickup": MessageLookupByLibrary.simpleMessage("Prise en charge"),
    "bookingCarReturn": MessageLookupByLibrary.simpleMessage("Retour"),
    "bookingCategoryBus": MessageLookupByLibrary.simpleMessage("Bus"),
    "bookingCategoryCars": MessageLookupByLibrary.simpleMessage("Voitures"),
    "bookingCategoryFlights": MessageLookupByLibrary.simpleMessage("Vols"),
    "bookingCategoryHotels": MessageLookupByLibrary.simpleMessage("Hôtels"),
    "bookingDetailAdults": MessageLookupByLibrary.simpleMessage("Adultes"),
    "bookingDetailArrival": MessageLookupByLibrary.simpleMessage("Arrivée"),
    "bookingDetailBookingDate": MessageLookupByLibrary.simpleMessage(
      "Date de réservation",
    ),
    "bookingDetailBookingId": MessageLookupByLibrary.simpleMessage(
      "N° réservation",
    ),
    "bookingDetailChildren": MessageLookupByLibrary.simpleMessage("Enfants"),
    "bookingDetailClass": MessageLookupByLibrary.simpleMessage("Classe"),
    "bookingDetailDeparture": MessageLookupByLibrary.simpleMessage("Départ"),
    "bookingDetailInfants": MessageLookupByLibrary.simpleMessage("Bébés"),
    "bookingDetailLastTicketDate": MessageLookupByLibrary.simpleMessage(
      "Date limite d\'émission",
    ),
    "bookingDetailMulti": MessageLookupByLibrary.simpleMessage(
      "Multi-destination",
    ),
    "bookingDetailOneway": MessageLookupByLibrary.simpleMessage("Aller simple"),
    "bookingDetailPassenger": MessageLookupByLibrary.simpleMessage("Passager"),
    "bookingDetailRoundtrip": MessageLookupByLibrary.simpleMessage(
      "Aller-retour",
    ),
    "bookingDetailSegment": MessageLookupByLibrary.simpleMessage("Segment"),
    "bookingDetailSegments": MessageLookupByLibrary.simpleMessage(
      "Segments de vol",
    ),
    "bookingDetailStatus": MessageLookupByLibrary.simpleMessage("Statut"),
    "bookingDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Détails de la réservation",
    ),
    "bookingDetailTotalPrice": MessageLookupByLibrary.simpleMessage(
      "Prix total",
    ),
    "bookingDetailTripType": MessageLookupByLibrary.simpleMessage(
      "Type de voyage",
    ),
    "bookingDetails": MessageLookupByLibrary.simpleMessage("Détails"),
    "bookingEmptyActive": MessageLookupByLibrary.simpleMessage(
      "Aucune réservation active",
    ),
    "bookingEmptyCancelled": MessageLookupByLibrary.simpleMessage(
      "Aucune réservation annulée",
    ),
    "bookingEmptyDefault": MessageLookupByLibrary.simpleMessage(
      "Aucune réservation",
    ),
    "bookingEmptyPast": MessageLookupByLibrary.simpleMessage(
      "Aucun voyage passé",
    ),
    "bookingEmptyStateSubtitle": MessageLookupByLibrary.simpleMessage(
      "Lorsque vous réservez un voyage, il apparaîtra ici.",
    ),
    "bookingEmptyStateTitle": MessageLookupByLibrary.simpleMessage(
      "Aucun voyage pour l\'instant",
    ),
    "bookingHotelCheckIn": MessageLookupByLibrary.simpleMessage("Arrivée"),
    "bookingHotelCheckOut": MessageLookupByLibrary.simpleMessage("Départ"),
    "bookingHotelGuests": MessageLookupByLibrary.simpleMessage("voyageurs"),
    "bookingHotelNights": MessageLookupByLibrary.simpleMessage("nuits"),
    "bookingHotelRoom": MessageLookupByLibrary.simpleMessage("chambre"),
    "bookingLoadError": MessageLookupByLibrary.simpleMessage(
      "Impossible de charger les réservations",
    ),
    "bookingLoginRequired": MessageLookupByLibrary.simpleMessage(
      "Veuillez vous connecter pour voir vos réservations",
    ),
    "bookingPassengers": MessageLookupByLibrary.simpleMessage("passagers"),
    "bookingPnr": MessageLookupByLibrary.simpleMessage("PNR"),
    "bookingRetry": MessageLookupByLibrary.simpleMessage("Réessayer"),
    "bookingSearchFlights": MessageLookupByLibrary.simpleMessage(
      "Rechercher des vols",
    ),
    "bookingTabActive": MessageLookupByLibrary.simpleMessage("Actifs"),
    "bookingTabCancelled": MessageLookupByLibrary.simpleMessage("Annulés"),
    "bookingTabPast": MessageLookupByLibrary.simpleMessage("Passés"),
    "bookingTitle": MessageLookupByLibrary.simpleMessage("Réservations"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Annuler"),
    "cardAirline": MessageLookupByLibrary.simpleMessage("Compagnie"),
    "cardBaggageIncluded": MessageLookupByLibrary.simpleMessage(
      "Bagages inclus",
    ),
    "cardBaggageShort": MessageLookupByLibrary.simpleMessage("Bagages"),
    "cardBook": MessageLookupByLibrary.simpleMessage("Réservez"),
    "cardDetailsText": MessageLookupByLibrary.simpleMessage("Détails"),
    "cardDirect": MessageLookupByLibrary.simpleMessage("Direct"),
    "cardDirectFlight": MessageLookupByLibrary.simpleMessage("Vol direct"),
    "cardDirectFlights": MessageLookupByLibrary.simpleMessage("Vols directs"),
    "cardFlightDetailsText": MessageLookupByLibrary.simpleMessage(
      "Détails vol",
    ),
    "cardFlightInfo": MessageLookupByLibrary.simpleMessage(
      "Informations du vol",
    ),
    "cardFlightNumber": MessageLookupByLibrary.simpleMessage("Numéro de vol"),
    "cardHoldBaggage": MessageLookupByLibrary.simpleMessage("Bagage soute"),
    "cardJourney": m2,
    "cardMultiDestFull": m3,
    "cardMultiDestShort": m4,
    "cardPerPerson": MessageLookupByLibrary.simpleMessage("par personne"),
    "cardPerPersonShort": MessageLookupByLibrary.simpleMessage("/pers."),
    "cardRecommended": MessageLookupByLibrary.simpleMessage("Recommandé"),
    "cardRefundable": MessageLookupByLibrary.simpleMessage("Remboursable"),
    "cardStop": m5,
    "cardStopShort": m6,
    "cardStops": m7,
    "cardStopsTotal": m8,
    "cardStopsTotalPlural": m9,
    "cardWeightIncluded": m10,
    "changePwConfirmHint": MessageLookupByLibrary.simpleMessage(
      "Confirmez votre nouveau mot de passe",
    ),
    "changePwConfirmLabel": MessageLookupByLibrary.simpleMessage(
      "Confirmer le nouveau mot de passe",
    ),
    "changePwConfirmRequired": MessageLookupByLibrary.simpleMessage(
      "Veuillez confirmer votre mot de passe",
    ),
    "changePwCurrentHint": MessageLookupByLibrary.simpleMessage(
      "Entrez votre mot de passe actuel",
    ),
    "changePwCurrentLabel": MessageLookupByLibrary.simpleMessage(
      "Mot de passe actuel",
    ),
    "changePwCurrentRequired": MessageLookupByLibrary.simpleMessage(
      "Veuillez entrer votre mot de passe actuel",
    ),
    "changePwFailed": MessageLookupByLibrary.simpleMessage(
      "Échec de la mise à jour du mot de passe",
    ),
    "changePwInfoText": MessageLookupByLibrary.simpleMessage(
      "Votre nouveau mot de passe doit comporter au moins 8 caractères",
    ),
    "changePwMinLength": MessageLookupByLibrary.simpleMessage(
      "Le mot de passe doit comporter au moins 8 caractères",
    ),
    "changePwMismatch": MessageLookupByLibrary.simpleMessage(
      "Les nouveaux mots de passe ne correspondent pas",
    ),
    "changePwNewHint": MessageLookupByLibrary.simpleMessage(
      "Entrez votre nouveau mot de passe",
    ),
    "changePwNewLabel": MessageLookupByLibrary.simpleMessage(
      "Nouveau mot de passe",
    ),
    "changePwNewRequired": MessageLookupByLibrary.simpleMessage(
      "Veuillez entrer un nouveau mot de passe",
    ),
    "changePwNoMatch": MessageLookupByLibrary.simpleMessage(
      "Les mots de passe ne correspondent pas",
    ),
    "changePwSuccess": MessageLookupByLibrary.simpleMessage(
      "Mot de passe mis à jour avec succès",
    ),
    "child": MessageLookupByLibrary.simpleMessage("Enfants"),
    "chipAll": MessageLookupByLibrary.simpleMessage("Tous"),
    "classBusiness": MessageLookupByLibrary.simpleMessage("Affaires"),
    "classEconomy": MessageLookupByLibrary.simpleMessage("Économie"),
    "classTitle": MessageLookupByLibrary.simpleMessage("Classe"),
    "completed": MessageLookupByLibrary.simpleMessage("Terminé"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
    "contactInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Informations de contact",
    ),
    "continueButton": MessageLookupByLibrary.simpleMessage("Continuer"),
    "convenienceFee": MessageLookupByLibrary.simpleMessage(
      "Frais de service ajoutés",
    ),
    "createAccButton": MessageLookupByLibrary.simpleMessage("Créer un compte"),
    "createTicketAttachments": MessageLookupByLibrary.simpleMessage(
      "Pièces jointes",
    ),
    "createTicketCloseTicket": MessageLookupByLibrary.simpleMessage(
      "Fermer le ticket",
    ),
    "createTicketConversation": MessageLookupByLibrary.simpleMessage(
      "Conversation",
    ),
    "createTicketCreatedBy": MessageLookupByLibrary.simpleMessage("Crée par"),
    "createTicketCreatedOn": MessageLookupByLibrary.simpleMessage("Créé le"),
    "createTicketDefaultSubject": MessageLookupByLibrary.simpleMessage(
      "Demande de devis vol",
    ),
    "createTicketDetailsTitle": MessageLookupByLibrary.simpleMessage(
      "Détails du ticket",
    ),
    "createTicketMessageHint": MessageLookupByLibrary.simpleMessage(
      "Écrivez votre message ici...",
    ),
    "createTicketPriority": MessageLookupByLibrary.simpleMessage("Priorité"),
    "createTicketPriorityLow": MessageLookupByLibrary.simpleMessage("Faible"),
    "createTicketPriorityNormal": MessageLookupByLibrary.simpleMessage(
      "Normale",
    ),
    "createTicketPriorityUrgent": MessageLookupByLibrary.simpleMessage(
      "Urgent",
    ),
    "createTicketSend": MessageLookupByLibrary.simpleMessage("Envoyer"),
    "createTicketServices": MessageLookupByLibrary.simpleMessage("Services"),
    "createTicketStatus": MessageLookupByLibrary.simpleMessage("Statut"),
    "createTicketStatusClosed": MessageLookupByLibrary.simpleMessage("Fermé"),
    "createTicketStatusInProgress": MessageLookupByLibrary.simpleMessage(
      "En cours",
    ),
    "createTicketStatusOpen": MessageLookupByLibrary.simpleMessage("Ouvert"),
    "createTicketStatusResolved": MessageLookupByLibrary.simpleMessage(
      "Résolu",
    ),
    "createTicketUpdatedOn": MessageLookupByLibrary.simpleMessage(
      "Mise à jour",
    ),
    "createTicketWriteReply": MessageLookupByLibrary.simpleMessage(
      "Rédiger une réponse",
    ),
    "createTicketYou": MessageLookupByLibrary.simpleMessage("Vous"),
    "currencyAlgeria": MessageLookupByLibrary.simpleMessage("Algérie"),
    "currencyFrance": MessageLookupByLibrary.simpleMessage("France"),
    "currencyTitle": MessageLookupByLibrary.simpleMessage("Devise"),
    "currencyTunisia": MessageLookupByLibrary.simpleMessage("Tunisie"),
    "currentLocation": MessageLookupByLibrary.simpleMessage(
      "Position actuelle",
    ),
    "datePickerConfirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
    "datePickerDay": MessageLookupByLibrary.simpleMessage("jour"),
    "datePickerDays": MessageLookupByLibrary.simpleMessage("jours"),
    "datePickerFri": MessageLookupByLibrary.simpleMessage("Ven."),
    "datePickerMon": MessageLookupByLibrary.simpleMessage("Lun."),
    "datePickerSat": MessageLookupByLibrary.simpleMessage("Sam."),
    "datePickerSelectDate": MessageLookupByLibrary.simpleMessage(
      "Sélectionner une date",
    ),
    "datePickerSun": MessageLookupByLibrary.simpleMessage("Dim."),
    "datePickerThu": MessageLookupByLibrary.simpleMessage("Jeu."),
    "datePickerTitleOneWay": MessageLookupByLibrary.simpleMessage(
      "Date de voyage",
    ),
    "datePickerTitleRoundTrip": MessageLookupByLibrary.simpleMessage(
      "Dates de voyage",
    ),
    "datePickerTripDuration": MessageLookupByLibrary.simpleMessage(
      "Durée du voyage : ",
    ),
    "datePickerTue": MessageLookupByLibrary.simpleMessage("Mar."),
    "datePickerWed": MessageLookupByLibrary.simpleMessage("Mer."),
    "dateTitle": MessageLookupByLibrary.simpleMessage("Date"),
    "departDate": MessageLookupByLibrary.simpleMessage("Date de départ"),
    "departDateTitle": MessageLookupByLibrary.simpleMessage("Départ"),
    "departure": MessageLookupByLibrary.simpleMessage("Départ"),
    "detailAirlineFare": MessageLookupByLibrary.simpleMessage(
      "Tarif proposé par la compagnie aérienne",
    ),
    "detailAvailable": MessageLookupByLibrary.simpleMessage("Disponible"),
    "detailBookingTitle": MessageLookupByLibrary.simpleMessage("Réservation"),
    "detailCabinBaggage": MessageLookupByLibrary.simpleMessage("Bagage cabine"),
    "detailCancellation": MessageLookupByLibrary.simpleMessage("Annulation"),
    "detailCancellationFees": m11,
    "detailCheckedBaggage": MessageLookupByLibrary.simpleMessage(
      "Bagages enregistrés",
    ),
    "detailDateChange": MessageLookupByLibrary.simpleMessage(
      "Changement de date",
    ),
    "detailDateChangeFees": m12,
    "detailInFlight": m13,
    "detailMeals": MessageLookupByLibrary.simpleMessage("Repas"),
    "detailNonStopInfo": m14,
    "detailOvernightLayover": m15,
    "detailSeatSelection": MessageLookupByLibrary.simpleMessage(
      "Sélection des sièges",
    ),
    "detailStopInfo": m16,
    "done": MessageLookupByLibrary.simpleMessage("Terminé"),
    "editAirportAll": m17,
    "editAirportSingle": m18,
    "editButton": MessageLookupByLibrary.simpleMessage("Modifier"),
    "editPassengerSummary": m19,
    "editProfileAddressHint": MessageLookupByLibrary.simpleMessage(
      "123 rue Principale",
    ),
    "editProfileAddressLabel": MessageLookupByLibrary.simpleMessage("Adresse"),
    "editProfileBirthDateHint": MessageLookupByLibrary.simpleMessage(
      "AAAA-MM-JJ",
    ),
    "editProfileBirthDateLabel": MessageLookupByLibrary.simpleMessage(
      "Date de naissance",
    ),
    "editProfileCityLabel": MessageLookupByLibrary.simpleMessage("Ville"),
    "editProfileCivility": MessageLookupByLibrary.simpleMessage("Civilité"),
    "editProfileCountryLabel": MessageLookupByLibrary.simpleMessage("Pays"),
    "editProfileEmailHint": MessageLookupByLibrary.simpleMessage(
      "exemple@domaine.com",
    ),
    "editProfileEmailLabel": MessageLookupByLibrary.simpleMessage("E-mail"),
    "editProfileErrorGeneric": MessageLookupByLibrary.simpleMessage("Erreur"),
    "editProfileFillNameEmail": MessageLookupByLibrary.simpleMessage(
      "Veuillez remplir le nom et l\'email",
    ),
    "editProfileFullNameHint": MessageLookupByLibrary.simpleMessage(
      "Nom Prénom",
    ),
    "editProfileFullNameLabel": MessageLookupByLibrary.simpleMessage(
      "Nom complet",
    ),
    "editProfilePersonalInfo": MessageLookupByLibrary.simpleMessage(
      "Informations personnelles",
    ),
    "editProfilePhoneLabel": MessageLookupByLibrary.simpleMessage("Téléphone"),
    "editProfilePostCodeLabel": MessageLookupByLibrary.simpleMessage(
      "Code postal",
    ),
    "editProfileSelectOption": MessageLookupByLibrary.simpleMessage(
      "Sélectionnez",
    ),
    "editProfileTitle": MessageLookupByLibrary.simpleMessage(
      "Modifier le profil",
    ),
    "editProfileUpdate": MessageLookupByLibrary.simpleMessage("Mettre à jour"),
    "editProfileUpdateError": MessageLookupByLibrary.simpleMessage(
      "Erreur lors de la mise à jour",
    ),
    "editProfileUpdated": MessageLookupByLibrary.simpleMessage(
      "Profil mis à jour",
    ),
    "editProfileUploadFailed": MessageLookupByLibrary.simpleMessage(
      "Échec du téléchargement de l\'image. Réessayez.",
    ),
    "editProfileUploadingImage": MessageLookupByLibrary.simpleMessage(
      "Téléchargement de l\'image...",
    ),
    "editRouteInfo": m20,
    "editSelect": MessageLookupByLibrary.simpleMessage("Sélectionner"),
    "editSelectClass": MessageLookupByLibrary.simpleMessage(
      "Sélectionnez la classe",
    ),
    "editSelectDate": MessageLookupByLibrary.simpleMessage(
      "Sélectionner une date",
    ),
    "emailHint": MessageLookupByLibrary.simpleMessage("Entrez votre e-mail"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "englishTitle": MessageLookupByLibrary.simpleMessage("Anglais"),
    "faqA1": MessageLookupByLibrary.simpleMessage(
      "Pour réserver un vol, suivez ces étapes :\n\n1. Recherchez votre vol en entrant votre ville de départ, destination et dates\n2. Sélectionnez le vol qui vous convient\n3. Choisissez votre classe de voyage (Classic ou Flex)\n4. Remplissez les informations des passagers\n5. Procédez au paiement\n\nVous recevrez votre confirmation par email.",
    ),
    "faqA10": MessageLookupByLibrary.simpleMessage(
      "Pour annuler votre réservation :\n\n1. Connectez-vous à votre compte\n2. Allez dans \"Mes réservations\"\n3. Sélectionnez la réservation concernée\n4. Cliquez sur \"Annuler\"\n5. Confirmez l\'annulation\n\nUn email de confirmation vous sera envoyé.",
    ),
    "faqA11": MessageLookupByLibrary.simpleMessage(
      "Les frais d\'annulation varient selon votre tarif :\n\n• Tarif Flex : Annulation gratuite\n• Tarif Classic : Frais de 5000 DZD par passager\n\nPour les annulations moins de 24h avant le départ, des conditions spéciales s\'appliquent.",
    ),
    "faqA12": MessageLookupByLibrary.simpleMessage(
      "Le délai de remboursement est de 7 à 14 jours ouvrables après validation de votre demande. Le montant sera crédité sur le même mode de paiement utilisé lors de la réservation.",
    ),
    "faqA13": MessageLookupByLibrary.simpleMessage(
      "La franchise bagages dépend de votre classe :\n\n• Économique : 1 bagage de 23kg en soute + 1 bagage cabine de 8kg\n• Business : 2 bagages de 32kg en soute + 1 bagage cabine de 12kg\n\nLes dimensions maximales varient selon les compagnies.",
    ),
    "faqA14": MessageLookupByLibrary.simpleMessage(
      "Si votre bagage est perdu :\n\n1. Signalez-le immédiatement au comptoir bagages de l\'aéroport\n2. Remplissez un formulaire PIR (Property Irregularity Report)\n3. Conservez votre numéro de dossier\n4. Contactez notre support avec ces informations\n\nNous vous accompagnerons dans vos démarches.",
    ),
    "faqA15": MessageLookupByLibrary.simpleMessage(
      "Certains objets nécessitent une déclaration préalable :\n\n• Équipements sportifs (vélo, ski, golf)\n• Instruments de musique\n• Animaux de compagnie\n• Équipements médicaux\n\nContactez-nous au moins 48h avant votre vol pour organiser le transport.",
    ),
    "faqA2": MessageLookupByLibrary.simpleMessage(
      "Oui, vous pouvez réserver jusqu\'à 9 passagers par réservation (adultes, enfants et bébés combinés). Les informations de chaque passager devront être renseignées lors de la réservation.",
    ),
    "faqA3": MessageLookupByLibrary.simpleMessage(
      "Vous pouvez ajouter des bagages supplémentaires :\n\n• Lors de la réservation, à l\'étape des options\n• Après la réservation, dans la section \"Gérer ma réservation\"\n\nNote : L\'ajout de bagages est moins cher lors de la réservation initiale.",
    ),
    "faqA4": MessageLookupByLibrary.simpleMessage(
      "Nous acceptons les modes de paiement suivants :\n\n• Cartes bancaires (Visa, Mastercard)\n• Carte CIB / EDAHABIA\n• Virement bancaire\n• Paiement en agence\n\nTous les paiements sont sécurisés et cryptés.",
    ),
    "faqA5": MessageLookupByLibrary.simpleMessage(
      "Si votre transaction a échoué :\n\n1. Vérifiez que les informations de votre carte sont correctes\n2. Assurez-vous que votre carte est activée pour les paiements en ligne\n3. Vérifiez votre plafond de paiement\n4. Essayez un autre mode de paiement\n\nSi le problème persiste, contactez notre support.",
    ),
    "faqA6": MessageLookupByLibrary.simpleMessage(
      "Votre facture est automatiquement envoyée par email après confirmation de la réservation. Vous pouvez également la télécharger depuis la section \"Mes réservations\" dans votre espace personnel.",
    ),
    "faqA7": MessageLookupByLibrary.simpleMessage(
      "Pour modifier votre réservation :\n\n1. Connectez-vous à votre compte\n2. Allez dans \"Mes réservations\"\n3. Sélectionnez la réservation à modifier\n4. Cliquez sur \"Modifier\"\n\nNote : Des frais peuvent s\'appliquer selon votre tarif (Classic ou Flex).",
    ),
    "faqA8": MessageLookupByLibrary.simpleMessage(
      "Le changement de nom n\'est possible que pour les corrections mineures (erreur de frappe). Pour un changement complet de passager, vous devez annuler et refaire une nouvelle réservation.",
    ),
    "faqA9": MessageLookupByLibrary.simpleMessage(
      "Les frais dépendent de votre tarif :\n\n• Tarif Flex : Modifications gratuites\n• Tarif Classic : Frais de 7000 DZD par passager\n\n+ Différence tarifaire éventuelle si le nouveau vol est plus cher.",
    ),
    "faqAllCategory": MessageLookupByLibrary.simpleMessage("Tout"),
    "faqAllQuestions": MessageLookupByLibrary.simpleMessage(
      "Toutes les questions",
    ),
    "faqCatBaggage": MessageLookupByLibrary.simpleMessage("Bagages"),
    "faqCatModification": MessageLookupByLibrary.simpleMessage("Modification"),
    "faqCatPayment": MessageLookupByLibrary.simpleMessage("Paiement"),
    "faqCatRefund": MessageLookupByLibrary.simpleMessage(
      "Annulation & Remboursement",
    ),
    "faqCatReservation": MessageLookupByLibrary.simpleMessage("Réservation"),
    "faqContactSupport": MessageLookupByLibrary.simpleMessage(
      "Contacter le support",
    ),
    "faqNoResults": MessageLookupByLibrary.simpleMessage("Aucun résultat"),
    "faqNoResultsDesc": MessageLookupByLibrary.simpleMessage(
      "Aucune question ne correspond à votre recherche.",
    ),
    "faqNotFoundAnswer": MessageLookupByLibrary.simpleMessage(
      "Vous n\'avez pas trouvé votre réponse ?",
    ),
    "faqQ1": MessageLookupByLibrary.simpleMessage("Comment réserver un vol ?"),
    "faqQ10": MessageLookupByLibrary.simpleMessage(
      "Comment annuler ma réservation ?",
    ),
    "faqQ11": MessageLookupByLibrary.simpleMessage(
      "Quels sont les frais d\'annulation ?",
    ),
    "faqQ12": MessageLookupByLibrary.simpleMessage(
      "Quand vais-je recevoir mon remboursement ?",
    ),
    "faqQ13": MessageLookupByLibrary.simpleMessage(
      "Quelle est la franchise bagages incluse ?",
    ),
    "faqQ14": MessageLookupByLibrary.simpleMessage(
      "Que faire si mon bagage est perdu ?",
    ),
    "faqQ15": MessageLookupByLibrary.simpleMessage(
      "Puis-je transporter des objets spéciaux ?",
    ),
    "faqQ2": MessageLookupByLibrary.simpleMessage(
      "Puis-je réserver pour plusieurs passagers ?",
    ),
    "faqQ3": MessageLookupByLibrary.simpleMessage(
      "Comment ajouter des bagages à ma réservation ?",
    ),
    "faqQ4": MessageLookupByLibrary.simpleMessage(
      "Quels modes de paiement sont acceptés ?",
    ),
    "faqQ5": MessageLookupByLibrary.simpleMessage(
      "Ma transaction a échoué, que faire ?",
    ),
    "faqQ6": MessageLookupByLibrary.simpleMessage(
      "Comment obtenir une facture ?",
    ),
    "faqQ7": MessageLookupByLibrary.simpleMessage(
      "Comment modifier ma réservation ?",
    ),
    "faqQ8": MessageLookupByLibrary.simpleMessage(
      "Puis-je changer le nom sur ma réservation ?",
    ),
    "faqQ9": MessageLookupByLibrary.simpleMessage(
      "Quels sont les frais de modification ?",
    ),
    "faqQuestionCount": m21,
    "faqSearchHint": MessageLookupByLibrary.simpleMessage(
      "Rechercher une question...",
    ),
    "faqSupportAvailable": MessageLookupByLibrary.simpleMessage(
      "Notre équipe support est disponible pour vous aider.",
    ),
    "faqTitle": MessageLookupByLibrary.simpleMessage("FAQ"),
    "filter": MessageLookupByLibrary.simpleMessage("Filtrer"),
    "filterArrivalAt": m22,
    "filterArrivalDefault": MessageLookupByLibrary.simpleMessage("Arrivée"),
    "filterDepartureDefault": MessageLookupByLibrary.simpleMessage("Départ"),
    "filterDepartureFrom": m23,
    "filterEarlyMorning": MessageLookupByLibrary.simpleMessage("Tôt le matin"),
    "filterEvening": MessageLookupByLibrary.simpleMessage("Soir"),
    "filterLayoversVia": MessageLookupByLibrary.simpleMessage("Escales via"),
    "filterMax": m24,
    "filterMin": m25,
    "filterMorning": MessageLookupByLibrary.simpleMessage("Matin"),
    "filterOutbound": MessageLookupByLibrary.simpleMessage("Aller"),
    "filterReset": MessageLookupByLibrary.simpleMessage("Réinitialiser"),
    "filterReturn": MessageLookupByLibrary.simpleMessage("Retour"),
    "filterSelectPriceRange": MessageLookupByLibrary.simpleMessage(
      "Sélectionner une plage de prix",
    ),
    "filterTitle": MessageLookupByLibrary.simpleMessage("Filtrer"),
    "flight": MessageLookupByLibrary.simpleMessage("Vol"),
    "flightDetails": MessageLookupByLibrary.simpleMessage("Détails du vol"),
    "flightOfferTitle": MessageLookupByLibrary.simpleMessage("Offres de vols"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "Mot de passe oublié ?",
    ),
    "fpAppBarTitle": MessageLookupByLibrary.simpleMessage(
      "Mot de passe oublié",
    ),
    "fpDesc1": MessageLookupByLibrary.simpleMessage(
      "Veuillez entrer votre numéro de téléphone ci-dessous pour recevoir votre code OTP.",
    ),
    "fromTitle": MessageLookupByLibrary.simpleMessage("De"),
    "fullNameLabel": MessageLookupByLibrary.simpleMessage("Nom complet"),
    "hello": MessageLookupByLibrary.simpleMessage("Bonjour 👋 "),
    "homeAdultsAge": MessageLookupByLibrary.simpleMessage("12 ans et plus"),
    "homeAdvantageSubtitle1": MessageLookupByLibrary.simpleMessage(
      "à chaque fois",
    ),
    "homeAdvantageSubtitle2": MessageLookupByLibrary.simpleMessage(
      "à votre écoute",
    ),
    "homeAdvantageTitle1": MessageLookupByLibrary.simpleMessage(
      "Obtenez le meilleur prix",
    ),
    "homeAdvantageTitle2": MessageLookupByLibrary.simpleMessage(
      "Service client 24/7",
    ),
    "homeAdvantagesSection": MessageLookupByLibrary.simpleMessage(
      "Nos avantages",
    ),
    "homeBookFlight": MessageLookupByLibrary.simpleMessage(
      "Réserver votre vol",
    ),
    "homeChildAge": MessageLookupByLibrary.simpleMessage(
      "De 2 à 11 ans au moment du voyage",
    ),
    "homeClassBusiness": MessageLookupByLibrary.simpleMessage(
      "Classe Affaires",
    ),
    "homeClassBusinessShort": MessageLookupByLibrary.simpleMessage("Affaires"),
    "homeClassEconomy": MessageLookupByLibrary.simpleMessage("Économique"),
    "homeClassEconomyShort": MessageLookupByLibrary.simpleMessage("Économique"),
    "homeClassFirst": MessageLookupByLibrary.simpleMessage("Première classe"),
    "homeClassFirstShort": MessageLookupByLibrary.simpleMessage("Première"),
    "homeClassLabel": MessageLookupByLibrary.simpleMessage("Classe"),
    "homeClassPremiumEconomy": MessageLookupByLibrary.simpleMessage(
      "Économie Premium",
    ),
    "homeClassPremiumEconomyShort": MessageLookupByLibrary.simpleMessage(
      "Éco Premium",
    ),
    "homeDefaultDeparture": MessageLookupByLibrary.simpleMessage("Départ"),
    "homeDefaultDestination": MessageLookupByLibrary.simpleMessage(
      "Destination",
    ),
    "homeDeparture": MessageLookupByLibrary.simpleMessage("Départ"),
    "homeDeparturePlace": MessageLookupByLibrary.simpleMessage(
      "Lieu de départ",
    ),
    "homeDestination": MessageLookupByLibrary.simpleMessage("Destination"),
    "homeDirectFlights": MessageLookupByLibrary.simpleMessage("Vols directs"),
    "homeDone": MessageLookupByLibrary.simpleMessage("Terminé"),
    "homeErrorPrefix": m26,
    "homeGreeting": m27,
    "homeInfantAge": MessageLookupByLibrary.simpleMessage(
      "Moins de 2 ans au moment du voyage",
    ),
    "homeMultiMinFlights": MessageLookupByLibrary.simpleMessage(
      "Veuillez ajouter au moins 2 vols pour une recherche multi-destination.",
    ),
    "homeOffersSection": MessageLookupByLibrary.simpleMessage(
      "Nos offres pour vous",
    ),
    "homePassengerClass": MessageLookupByLibrary.simpleMessage(
      "Passager & Classe",
    ),
    "homePassengerCount": m28,
    "homePassengerNote": MessageLookupByLibrary.simpleMessage(
      "Les enfants et les nourrissons doivent être accompagnés par un adulte pendant le vol.",
    ),
    "homeReturn": MessageLookupByLibrary.simpleMessage("Retour"),
    "homeSearchError": MessageLookupByLibrary.simpleMessage(
      "Erreur lors de la recherche",
    ),
    "homeSearchFlights": MessageLookupByLibrary.simpleMessage(
      "Rechercher vols",
    ),
    "homeSearching": MessageLookupByLibrary.simpleMessage(
      "Recherche en cours...",
    ),
    "homeSelectAirport": MessageLookupByLibrary.simpleMessage(
      "Sélectionner un aéroport",
    ),
    "homeSelectAirportsError": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner les aéroports de départ et d\'arrivée.",
    ),
    "homeSelectAirportsFlight1": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner les aéroports de départ et d\'arrivée pour le vol 1.",
    ),
    "homeSelectAirportsFlightN": m29,
    "homeSelectDateFlight1": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner une date de départ pour le vol 1.",
    ),
    "homeSelectDateFlightN": m30,
    "homeSelectDepartureDate": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner une date de départ.",
    ),
    "homeSelectReturnDate": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner une date de retour.",
    ),
    "homeSenior": MessageLookupByLibrary.simpleMessage("Senior"),
    "homeSeniorTooltip": MessageLookupByLibrary.simpleMessage(
      "Pour les hommes +55 ans et pour les femmes +60 ans seulement AIR ALGERIE vers la FRANCE",
    ),
    "homeWelcome": MessageLookupByLibrary.simpleMessage("Bienvenue"),
    "homeWithBaggage": MessageLookupByLibrary.simpleMessage("Avec bagages"),
    "homeYoung": MessageLookupByLibrary.simpleMessage("Jeune(s)"),
    "homeYoungTooltip": MessageLookupByLibrary.simpleMessage(
      "Entre 12 ans et 24 ans seulement en vol domestique",
    ),
    "inFlight": m31,
    "inboxEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Vous recevrez des alertes concernant vos voyages et votre compte. Avez-vous déjà choisi votre prochaine destination ?",
    ),
    "inboxEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Pas encore de notifications",
    ),
    "inboxExploreButton": MessageLookupByLibrary.simpleMessage("Explorer"),
    "inboxTitle": MessageLookupByLibrary.simpleMessage("Boîte de réception"),
    "infants": MessageLookupByLibrary.simpleMessage("Bébés"),
    "language": MessageLookupByLibrary.simpleMessage("Langue"),
    "lastNameHint": MessageLookupByLibrary.simpleMessage(
      "Entrez le nom de famille",
    ),
    "lastNameTitle": MessageLookupByLibrary.simpleMessage("Nom de famille"),
    "layoverAt": m32,
    "layoverDuration": m33,
    "loadingAwaitsYou": MessageLookupByLibrary.simpleMessage(" vous attend!"),
    "loadingConnectingTo": MessageLookupByLibrary.simpleMessage("CONNEXION À"),
    "loadingFlightsFound": MessageLookupByLibrary.simpleMessage("vols trouvés"),
    "loadingMeanwhile": MessageLookupByLibrary.simpleMessage("En attendant"),
    "loadingPleaseWait": MessageLookupByLibrary.simpleMessage(
      "Veuillez patienter...",
    ),
    "loadingPromoAccommodation": MessageLookupByLibrary.simpleMessage(
      "hébergement",
    ),
    "loadingPromoText1": MessageLookupByLibrary.simpleMessage(
      "N\'oubliez pas! Économisez jusqu\'à ",
    ),
    "loadingPromoText2": MessageLookupByLibrary.simpleMessage(" sur votre "),
    "loadingProviders": MessageLookupByLibrary.simpleMessage("fournisseurs"),
    "loadingResults": MessageLookupByLibrary.simpleMessage("Résultats"),
    "loadingResultsLabel": MessageLookupByLibrary.simpleMessage("RÉSULTATS"),
    "loadingSearchError": m34,
    "loadingSearchingFlights": MessageLookupByLibrary.simpleMessage(
      "Recherche de vols",
    ),
    "loginButton": MessageLookupByLibrary.simpleMessage("Se connecter"),
    "loginTitle": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous à votre compte",
    ),
    "myBookingTitle": MessageLookupByLibrary.simpleMessage("Mes réservations"),
    "myProfileTitle": MessageLookupByLibrary.simpleMessage("Mon Profil"),
    "nameHint": MessageLookupByLibrary.simpleMessage(
      "Entrez votre nom complet",
    ),
    "nameLabel": MessageLookupByLibrary.simpleMessage("Nom complet"),
    "nameTitle": MessageLookupByLibrary.simpleMessage(
      "Prénom et deuxième prénom",
    ),
    "navBarTitle1": MessageLookupByLibrary.simpleMessage("Accueil"),
    "navBarTitle2": MessageLookupByLibrary.simpleMessage("Mes réservations"),
    "navBarTitle3": MessageLookupByLibrary.simpleMessage("Historique"),
    "navBarTitle4": MessageLookupByLibrary.simpleMessage("Profil"),
    "navBookings": MessageLookupByLibrary.simpleMessage("Réservations"),
    "navMyAccount": MessageLookupByLibrary.simpleMessage("Mon compte"),
    "navSearch": MessageLookupByLibrary.simpleMessage("Rechercher"),
    "navSupport": MessageLookupByLibrary.simpleMessage("Support"),
    "noAccTitle1": MessageLookupByLibrary.simpleMessage(
      "Vous n’avez pas de compte ? ",
    ),
    "noAccTitle2": MessageLookupByLibrary.simpleMessage(
      "Créer un nouveau compte",
    ),
    "nonStop": m35,
    "notificationAllClear": MessageLookupByLibrary.simpleMessage(
      "Tout effacer",
    ),
    "notificationMinuteAgo": MessageLookupByLibrary.simpleMessage("1 min"),
    "notificationMinutesAgo": m36,
    "notificationPaymentSuccessDesc": MessageLookupByLibrary.simpleMessage(
      "Votre paiement a été effectué avec succès.",
    ),
    "notificationPaymentSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "Paiement réussi !",
    ),
    "notificationTimeAgo": m37,
    "notificationTitle": MessageLookupByLibrary.simpleMessage("Notifications"),
    "notificationToday": MessageLookupByLibrary.simpleMessage("Aujourd’hui"),
    "notificationYesterday": MessageLookupByLibrary.simpleMessage("Hier"),
    "onBoardSubTitle1": MessageLookupByLibrary.simpleMessage(
      "Un service simple et efficace pour organiser vos voyages en toute tranquillité.",
    ),
    "onBoardSubTitle2": MessageLookupByLibrary.simpleMessage(
      "Un service simple et efficace pour organiser vos voyages en toute tranquillité.",
    ),
    "onBoardSubTitle3": MessageLookupByLibrary.simpleMessage(
      "Un service simple et efficace pour organiser vos voyages en toute tranquillité.",
    ),
    "onBoardTagline": MessageLookupByLibrary.simpleMessage(
      "À vous de fixer l\'heure",
    ),
    "onBoardTitle1": MessageLookupByLibrary.simpleMessage(
      "Réservez maintenant\net payez sur place",
    ),
    "onBoardTitle2": MessageLookupByLibrary.simpleMessage(
      "Trouvez les meilleurs\nvols au meilleur prix",
    ),
    "onBoardTitle3": MessageLookupByLibrary.simpleMessage(
      "Voyagez en toute\nsérénité",
    ),
    "onwardTitle": MessageLookupByLibrary.simpleMessage("Aller"),
    "orSignUpTitle": MessageLookupByLibrary.simpleMessage("Ou s’inscrire avec"),
    "otpCodeSent": m38,
    "otpCodeSentTo": MessageLookupByLibrary.simpleMessage(
      "Nous avons envoyé un code de vérification à :\n",
    ),
    "otpCodeSentToShort": MessageLookupByLibrary.simpleMessage(
      "Code envoyé à : ",
    ),
    "otpDesc1": MessageLookupByLibrary.simpleMessage(
      "Un code à 6 chiffres a été envoyé à votre adresse e-mail, ",
    ),
    "otpDesc2": MessageLookupByLibrary.simpleMessage("riead2562@gmail.com"),
    "otpEmailFallback": MessageLookupByLibrary.simpleMessage("adresse e-mail"),
    "otpEnterToContinue": MessageLookupByLibrary.simpleMessage(
      "\nVeuillez le saisir pour continuer.",
    ),
    "otpRegistrationSuccess": MessageLookupByLibrary.simpleMessage(
      "Inscription réussie! Veuillez vous connecter.",
    ),
    "otpResendError": MessageLookupByLibrary.simpleMessage(
      "Erreur lors du renvoi du code.",
    ),
    "otpResendFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible de renvoyer le code. Réessayez.",
    ),
    "otpResendTitle1": MessageLookupByLibrary.simpleMessage(
      "Vous n’avez pas reçu le code ? ",
    ),
    "otpResendTitle2": MessageLookupByLibrary.simpleMessage("Renvoyer le code"),
    "otpTitle": MessageLookupByLibrary.simpleMessage("OTP"),
    "otpVerifyEmail": MessageLookupByLibrary.simpleMessage(
      "Vérifier l\'adresse e-mail",
    ),
    "otpVerifyTitle": MessageLookupByLibrary.simpleMessage(
      "Vérifiez votre adresse e-mail pour vous connecter",
    ),
    "otpVerifyTitleShort": MessageLookupByLibrary.simpleMessage(
      "Vérifiez votre adresse e-mail",
    ),
    "otpVerifying": MessageLookupByLibrary.simpleMessage(
      "Vérification en cours...",
    ),
    "otpWrongCode": MessageLookupByLibrary.simpleMessage(
      "Code incorrect, veuillez réessayer",
    ),
    "paid": MessageLookupByLibrary.simpleMessage("Payé"),
    "passengerMale": m39,
    "passwordHint": MessageLookupByLibrary.simpleMessage(
      "Entrez votre mot de passe",
    ),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "paymentCardTitle": MessageLookupByLibrary.simpleMessage(
      "Vos cartes de paiement",
    ),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("Moyen de paiement"),
    "paymentTitle": MessageLookupByLibrary.simpleMessage("Paiement"),
    "phoneHint": MessageLookupByLibrary.simpleMessage(
      "Entrez votre numéro de téléphone",
    ),
    "phoneLabel": MessageLookupByLibrary.simpleMessage("Téléphone"),
    "pillFlightsAvailable": m40,
    "pillLoading": MessageLookupByLibrary.simpleMessage(
      "Recherche de tous les vols disponibles",
    ),
    "priceAdultFallback": MessageLookupByLibrary.simpleMessage("1x Adulte"),
    "priceBaseFare": MessageLookupByLibrary.simpleMessage("Frais de base"),
    "priceDetailsTitle": MessageLookupByLibrary.simpleMessage("Détails prix"),
    "priceNonRefundable": MessageLookupByLibrary.simpleMessage(
      "Non remboursable",
    ),
    "priceTaxesPer": m41,
    "priceTaxesPerAdult": MessageLookupByLibrary.simpleMessage(
      "Taxes par adulte",
    ),
    "priceTotalInclTax": MessageLookupByLibrary.simpleMessage("Total TTC"),
    "privacyContact": MessageLookupByLibrary.simpleMessage(
      "Si vous avez des questions concernant cette Politique de confidentialité, vous pouvez nous contacter à l’adresse suivante : info@h24voyages.com.",
    ),
    "privacyContactTitle": MessageLookupByLibrary.simpleMessage(
      "Nous contacter",
    ),
    "privacyInfoCollection": MessageLookupByLibrary.simpleMessage(
      "Nous collectons des informations personnelles lorsque vous effectuez une réservation, créez un compte ou utilisez nos services. Cela peut inclure votre nom, adresse e-mail, numéro de téléphone, informations de paiement et détails de voyage.",
    ),
    "privacyInfoCollectionTitle": MessageLookupByLibrary.simpleMessage(
      "Informations que nous collectons",
    ),
    "privacyPolicyIntroduction": MessageLookupByLibrary.simpleMessage(
      "Chez H24 Voyages, nous nous engageons à protéger votre vie privée et à garantir que vos informations personnelles sont traitées de manière sûre et responsable.",
    ),
    "privacyPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Politique de confidentialité",
    ),
    "privacySecurity": MessageLookupByLibrary.simpleMessage(
      "Nous mettons en œuvre des mesures de sécurité appropriées pour protéger vos informations personnelles. Toutefois, aucune méthode de transmission sur Internet n’est totalement sécurisée.",
    ),
    "privacySecurityTitle": MessageLookupByLibrary.simpleMessage(
      "Sécurité de vos données",
    ),
    "privacySharing": MessageLookupByLibrary.simpleMessage(
      "Nous pouvons partager vos informations avec nos partenaires tels que les compagnies aériennes, hôtels et prestataires de paiement uniquement lorsque cela est nécessaire pour fournir nos services ou lorsque la loi l’exige.",
    ),
    "privacySharingTitle": MessageLookupByLibrary.simpleMessage(
      "Partage des informations",
    ),
    "privacyUse": MessageLookupByLibrary.simpleMessage(
      "Vos informations sont utilisées pour traiter vos réservations, vous contacter concernant vos voyages, fournir un support client et améliorer nos services.",
    ),
    "privacyUseTitle": MessageLookupByLibrary.simpleMessage(
      "Utilisation de vos informations",
    ),
    "proceedToBook": MessageLookupByLibrary.simpleMessage("Réserver ce vole"),
    "profileCancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "profileClose": MessageLookupByLibrary.simpleMessage("Fermer"),
    "profileContactSupport": MessageLookupByLibrary.simpleMessage(
      "Contacter le service client",
    ),
    "profileCurrencies": MessageLookupByLibrary.simpleMessage("Devises"),
    "profileDisable": MessageLookupByLibrary.simpleMessage("Désactiver"),
    "profileDisableAccount": MessageLookupByLibrary.simpleMessage(
      "Désactiver le compte",
    ),
    "profileDisableConfirm": MessageLookupByLibrary.simpleMessage(
      "Êtes-vous sûr de vouloir désactiver votre compte ? Cette action est irréversible et vous serez déconnecté.",
    ),
    "profileDisableFailed": MessageLookupByLibrary.simpleMessage(
      "Échec de la désactivation du compte",
    ),
    "profileDisableSuccess": MessageLookupByLibrary.simpleMessage(
      "Compte désactivé avec succès",
    ),
    "profileError": m42,
    "profileFaq": MessageLookupByLibrary.simpleMessage("FAQ"),
    "profileHelpSection": MessageLookupByLibrary.simpleMessage("Aide"),
    "profileLanguages": MessageLookupByLibrary.simpleMessage("Langues"),
    "profileLogout": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "profileLogoutAction": MessageLookupByLibrary.simpleMessage("Déconnecter"),
    "profileLogoutButton": MessageLookupByLibrary.simpleMessage(
      "Se déconnecter",
    ),
    "profileLogoutConfirm": MessageLookupByLibrary.simpleMessage(
      "Êtes-vous sûr de vouloir vous déconnecter ?",
    ),
    "profileLogoutTitle": MessageLookupByLibrary.simpleMessage("Déconnexion"),
    "profileManageAccount": MessageLookupByLibrary.simpleMessage(
      "Gérer mon compte",
    ),
    "profileMyProfile": MessageLookupByLibrary.simpleMessage("Mon profil"),
    "profileNotifications": MessageLookupByLibrary.simpleMessage(
      "Notifications",
    ),
    "profilePayments": MessageLookupByLibrary.simpleMessage("Paiements"),
    "profilePersonalInfo": MessageLookupByLibrary.simpleMessage(
      "Coordonnées personnelles",
    ),
    "profilePrivacy": MessageLookupByLibrary.simpleMessage(
      "Politique de confidentialité",
    ),
    "profileReferFriend": MessageLookupByLibrary.simpleMessage(
      "Parrainez un(e) ami(e)",
    ),
    "profileReferralMessage": MessageLookupByLibrary.simpleMessage(
      "Partagez votre code de parrainage avec vos amis !",
    ),
    "profileReferralTitle": MessageLookupByLibrary.simpleMessage("Parrainage"),
    "profileRegisteredTravelers": MessageLookupByLibrary.simpleMessage(
      "Voyageurs enregistrés",
    ),
    "profileSecuritySettings": MessageLookupByLibrary.simpleMessage(
      "Paramètre de sécurité",
    ),
    "profileSetting": MessageLookupByLibrary.simpleMessage("Paramètres"),
    "profileSettingsSection": MessageLookupByLibrary.simpleMessage("Paramètre"),
    "profileShare": MessageLookupByLibrary.simpleMessage(
      "Partager l’application",
    ),
    "profileTerms": MessageLookupByLibrary.simpleMessage(
      "Conditions générales",
    ),
    "profileTitle": MessageLookupByLibrary.simpleMessage("Profil"),
    "promoCodeTitle": MessageLookupByLibrary.simpleMessage(
      "Entrer un code promo",
    ),
    "recentPlaceTitle": MessageLookupByLibrary.simpleMessage("Lieux récents"),
    "recentSearch": MessageLookupByLibrary.simpleMessage("Recherches récentes"),
    "refundPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Politique de remboursement en cas d’annulation",
    ),
    "registerEmail": MessageLookupByLibrary.simpleMessage("E-mail"),
    "registerError": MessageLookupByLibrary.simpleMessage(
      "Erreur lors de l\'inscription",
    ),
    "registerFieldRequired": MessageLookupByLibrary.simpleMessage(
      "Ce champ est requis",
    ),
    "registerFirstName": MessageLookupByLibrary.simpleMessage("Prénom"),
    "registerLastName": MessageLookupByLibrary.simpleMessage("Nom"),
    "registerPassword": MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "registerPasswordMinLength": MessageLookupByLibrary.simpleMessage(
      "Au moins 6 caractères",
    ),
    "registerPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Mot de passe requis",
    ),
    "registerSubtitle": MessageLookupByLibrary.simpleMessage(
      "Inscrivez-vous dès maintenant à h24voyages\net accédez à nos services.",
    ),
    "registerTitle": MessageLookupByLibrary.simpleMessage("S\'inscrire"),
    "registerUnknownError": MessageLookupByLibrary.simpleMessage(
      "Erreur inconnue",
    ),
    "returnDate": MessageLookupByLibrary.simpleMessage("Date de retour"),
    "returnDateTitle": MessageLookupByLibrary.simpleMessage("Retour"),
    "returnTitle": MessageLookupByLibrary.simpleMessage("Retour"),
    "searchEditSearch": MessageLookupByLibrary.simpleMessage(
      "Modifier la recherche",
    ),
    "searchErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Accès refusé au service de recherche.\nVeuillez vous reconnecter.",
    ),
    "searchErrorNoFlights": MessageLookupByLibrary.simpleMessage(
      "Aucun vol disponible pour ces critères.\nEssayez d\'autres dates ou destinations.",
    ),
    "searchErrorNoInternet": MessageLookupByLibrary.simpleMessage(
      "Connexion internet indisponible.\nVérifiez votre connexion et réessayez.",
    ),
    "searchErrorNotFound": MessageLookupByLibrary.simpleMessage(
      "Le service de recherche est introuvable.\nVeuillez réessayer plus tard.",
    ),
    "searchErrorServer": MessageLookupByLibrary.simpleMessage(
      "Le service de recherche est temporairement indisponible.\nVeuillez réessayer plus tard.",
    ),
    "searchErrorSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Votre session a expiré.\nVeuillez vous reconnecter et réessayer.",
    ),
    "searchErrorTimeout": MessageLookupByLibrary.simpleMessage(
      "Le serveur met trop de temps à répondre.\nVeuillez réessayer dans quelques instants.",
    ),
    "searchErrorTooMany": MessageLookupByLibrary.simpleMessage(
      "Trop de recherches en peu de temps.\nVeuillez patienter avant de réessayer.",
    ),
    "searchErrorUnexpected": MessageLookupByLibrary.simpleMessage(
      "Une erreur inattendue est survenue.\nVeuillez réessayer ou modifier vos critères.",
    ),
    "searchFlight": MessageLookupByLibrary.simpleMessage("Rechercher un vol"),
    "searchLoadingFlights": MessageLookupByLibrary.simpleMessage(
      "Chargement des vols...",
    ),
    "searchNoFlightsForFilters": MessageLookupByLibrary.simpleMessage(
      "Aucun vol ne correspond à vos filtres",
    ),
    "searchNoFlightsFound": MessageLookupByLibrary.simpleMessage(
      "Aucun vol trouvé",
    ),
    "searchPageInfo": m43,
    "searchResetFilters": MessageLookupByLibrary.simpleMessage(
      "Réinitialiser les filtres",
    ),
    "searchScreenTitle": MessageLookupByLibrary.simpleMessage(
      "D’où partez-vous ?",
    ),
    "searchScrollForMore": MessageLookupByLibrary.simpleMessage(
      "Faites défiler pour charger plus de vols",
    ),
    "searchSheetHint": MessageLookupByLibrary.simpleMessage(
      "Pays, ville ou aéroport",
    ),
    "searchSheetRecent": MessageLookupByLibrary.simpleMessage("Récents"),
    "searchSheetResults": MessageLookupByLibrary.simpleMessage(
      "Résultats de recherche",
    ),
    "searchStayDuration": MessageLookupByLibrary.simpleMessage(
      "Durée du séjour : ",
    ),
    "searchTryModifyDates": MessageLookupByLibrary.simpleMessage(
      "Essayez de modifier vos dates ou\nvos critères de recherche",
    ),
    "searchTryModifyFilters": MessageLookupByLibrary.simpleMessage(
      "Essayez de modifier ou réinitialiser\nvos filtres pour voir plus de résultats",
    ),
    "searchUnavailable": MessageLookupByLibrary.simpleMessage(
      "Recherche indisponible",
    ),
    "segmentAirportFallback": m44,
    "segmentBaggage": MessageLookupByLibrary.simpleMessage("Bagages"),
    "segmentCabinBag": m45,
    "segmentCheckedBag": m46,
    "segmentFlightInfo": m47,
    "segmentSeats": m48,
    "segmentTerminal": m49,
    "selectGenderTitle": MessageLookupByLibrary.simpleMessage(
      "Sélectionner le sexe",
    ),
    "selectService": MessageLookupByLibrary.simpleMessage(
      "Sélectionner les services",
    ),
    "settingTitle": MessageLookupByLibrary.simpleMessage("Paramètres"),
    "sheetApply": MessageLookupByLibrary.simpleMessage("Appliquer"),
    "sheetBookFlight": MessageLookupByLibrary.simpleMessage("Réserver ce vol"),
    "sheetFlightDetails": MessageLookupByLibrary.simpleMessage(
      "Détails du vol",
    ),
    "sheetOneWay": MessageLookupByLibrary.simpleMessage("Vol aller simple"),
    "sheetPricePerPerson": m50,
    "sheetRoundTrip": MessageLookupByLibrary.simpleMessage("Vol aller-retour"),
    "signUpButton": MessageLookupByLibrary.simpleMessage("S’inscrire"),
    "signUpEmailEmpty": MessageLookupByLibrary.simpleMessage(
      "Veuillez saisir votre adresse e-mail",
    ),
    "signUpEmailHint": MessageLookupByLibrary.simpleMessage("email@email.com"),
    "signUpEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Veuillez saisir une adresse e-mail valide",
    ),
    "signUpEmailLabel": MessageLookupByLibrary.simpleMessage("Adresse e-mail"),
    "signUpError": MessageLookupByLibrary.simpleMessage("Erreur"),
    "signUpLoginError": MessageLookupByLibrary.simpleMessage(
      "Erreur lors de la connexion",
    ),
    "signUpRegister": MessageLookupByLibrary.simpleMessage("Inscrivez vous"),
    "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous à l\'aide de votre compte h24voyages\net accédez à nos services.",
    ),
    "signUpTermsShort": MessageLookupByLibrary.simpleMessage(
      "En vous connectant, vous acceptez",
    ),
    "signUpTitle": MessageLookupByLibrary.simpleMessage(
      "Se connecter ou créer un compte",
    ),
    "skipButton": MessageLookupByLibrary.simpleMessage("Passer"),
    "sortArrivalShort": MessageLookupByLibrary.simpleMessage("Arrivée"),
    "sortArrivalTime": MessageLookupByLibrary.simpleMessage("Heure d\'arrivée"),
    "sortBy": MessageLookupByLibrary.simpleMessage("Trier par"),
    "sortCheapest": MessageLookupByLibrary.simpleMessage("Le moins cher"),
    "sortCheapestShort": MessageLookupByLibrary.simpleMessage("Prix ↑"),
    "sortDefaultShort": MessageLookupByLibrary.simpleMessage("Trier"),
    "sortDepartureShort": MessageLookupByLibrary.simpleMessage("Départ"),
    "sortDepartureTime": MessageLookupByLibrary.simpleMessage(
      "Heure de départ",
    ),
    "sortDurationShort": MessageLookupByLibrary.simpleMessage("Durée"),
    "sortExpensiveShort": MessageLookupByLibrary.simpleMessage("Prix ↓"),
    "sortFlightDuration": MessageLookupByLibrary.simpleMessage("Durée du vol"),
    "sortMostExpensive": MessageLookupByLibrary.simpleMessage("Le plus cher"),
    "statusCancelled": MessageLookupByLibrary.simpleMessage("Annulé"),
    "statusCompleted": MessageLookupByLibrary.simpleMessage("Terminé"),
    "statusConfirmed": MessageLookupByLibrary.simpleMessage("Confirmé"),
    "statusFailureTicket": MessageLookupByLibrary.simpleMessage(
      "Échec d\'émission",
    ),
    "statusInProgress": MessageLookupByLibrary.simpleMessage("En cours"),
    "statusPending": MessageLookupByLibrary.simpleMessage("En attente"),
    "statusPnrPending": MessageLookupByLibrary.simpleMessage("PNR en attente"),
    "stopCount": m51,
    "supportBanner": MessageLookupByLibrary.simpleMessage(
      "Gérez et suivez vos demandes en temps réel",
    ),
    "supportDetails": MessageLookupByLibrary.simpleMessage("Détails"),
    "supportFilter": MessageLookupByLibrary.simpleMessage("Filtrer"),
    "supportHelpdesk": MessageLookupByLibrary.simpleMessage("Helpdesk"),
    "supportStatusActive": MessageLookupByLibrary.simpleMessage("Actif"),
    "supportStatusClosed": MessageLookupByLibrary.simpleMessage("Fermé"),
    "supportStatusInProgress": MessageLookupByLibrary.simpleMessage("en cours"),
    "supportStatusResolved": MessageLookupByLibrary.simpleMessage("Résolu"),
    "supportTabActive": MessageLookupByLibrary.simpleMessage("Actifs"),
    "supportTabAll": MessageLookupByLibrary.simpleMessage("Toutes"),
    "supportTabClosed": MessageLookupByLibrary.simpleMessage("Fermés"),
    "supportTabResolved": MessageLookupByLibrary.simpleMessage("Résolus"),
    "supportTicket": MessageLookupByLibrary.simpleMessage("Ticket"),
    "supportTitle": MessageLookupByLibrary.simpleMessage("Support client"),
    "tab1": MessageLookupByLibrary.simpleMessage("Aller simple"),
    "tab2": MessageLookupByLibrary.simpleMessage("Aller-retour"),
    "tab3": MessageLookupByLibrary.simpleMessage("Multi-destinations"),
    "ticketDetailCancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "ticketDetailClose": MessageLookupByLibrary.simpleMessage("Fermer"),
    "ticketDetailCloseDialog": MessageLookupByLibrary.simpleMessage(
      "Fermer le ticket ?",
    ),
    "ticketDetailCloseWarning": MessageLookupByLibrary.simpleMessage(
      "Vous ne pourrez plus envoyer de messages une fois le ticket fermé.",
    ),
    "ticketDetailCreatedUpdated": m52,
    "ticketDetailMessageHint": MessageLookupByLibrary.simpleMessage(
      "Écrire un message...",
    ),
    "ticketDetailStatusClosed": MessageLookupByLibrary.simpleMessage("Fermé"),
    "ticketDetailStatusOpen": MessageLookupByLibrary.simpleMessage("Ouvert"),
    "ticketDetailStatusPending": MessageLookupByLibrary.simpleMessage(
      "En attente",
    ),
    "ticketDetailStatusResolved": MessageLookupByLibrary.simpleMessage(
      "Résolu",
    ),
    "ticketDetailStatusUrgent": MessageLookupByLibrary.simpleMessage("Urgent"),
    "ticketDetailTicketClosed": MessageLookupByLibrary.simpleMessage(
      "Ce ticket est fermé",
    ),
    "ticketDetailTitle": MessageLookupByLibrary.simpleMessage(
      "Détail du ticket",
    ),
    "ticketStatusTitle": MessageLookupByLibrary.simpleMessage(
      "Statut du billet",
    ),
    "toTitle": MessageLookupByLibrary.simpleMessage("À"),
    "totalPrice": MessageLookupByLibrary.simpleMessage("Prix total"),
    "travellerTitle": MessageLookupByLibrary.simpleMessage("Passagers"),
    "useCurrentLocation": MessageLookupByLibrary.simpleMessage(
      "Utiliser la position actuelle",
    ),
    "verification": MessageLookupByLibrary.simpleMessage("Vérification"),
    "verifyButton": MessageLookupByLibrary.simpleMessage("Vérifier"),
    "viewAllButton": MessageLookupByLibrary.simpleMessage("Voir tout"),
    "viewDetails": MessageLookupByLibrary.simpleMessage("Voir les détails"),
    "wcDescription": MessageLookupByLibrary.simpleMessage(
      "Planifiez vos vols rapidement et facilement grâce à notre application intuitive.",
    ),
    "wcSubTitle": MessageLookupByLibrary.simpleMessage("Réservation de vols"),
    "wcTitle": MessageLookupByLibrary.simpleMessage(
      "Commencez votre voyage avec",
    ),
    "welcomeContinueEmail": MessageLookupByLibrary.simpleMessage(
      "Continuer via l\'adresse e-mail",
    ),
    "welcomeContinueGoogle": MessageLookupByLibrary.simpleMessage(
      "Continuer avec Google",
    ),
    "welcomeCopyright": MessageLookupByLibrary.simpleMessage(
      "Tous droits réservés. Copyright- h24voyages",
    ),
    "welcomePrivacyPolicy": MessageLookupByLibrary.simpleMessage(
      "charte de confidentialité",
    ),
    "welcomeSkipLogin": MessageLookupByLibrary.simpleMessage(
      "Continuer sans connexion",
    ),
    "welcomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous pour économiser au moins\n10 % grâce à une adhésion gratuite à h24voyages",
    ),
    "welcomeTermsAnd": MessageLookupByLibrary.simpleMessage(" et notre "),
    "welcomeTermsConditions": MessageLookupByLibrary.simpleMessage(
      "conditions générales",
    ),
    "welcomeTermsIntro": MessageLookupByLibrary.simpleMessage(
      "En créant ou en vous connectant à un compte, vous acceptez",
    ),
    "welcomeTermsOur": MessageLookupByLibrary.simpleMessage("nos "),
    "welcomeTitle": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous pour économiser",
    ),
  };
}
