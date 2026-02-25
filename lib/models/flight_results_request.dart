// Flight Results Request (Query Params)
class FlightResultsRequest {
  final String searchCode;
  final int page;
  final double? minPrice;
  final double? maxPrice;
  final bool? isRefundable;
  final String? sort; // e.g., "P:asc" or "P:desc" for price
  final bool? includedBaggageOnly;
  final bool? noCodeshare;
  final String? airline;
  final String? stops; // e.g., "B1:S0" (Aller direct), "B2:S1" (Retour 1 stop)
  final String? depAirport; // e.g., "B1:ALG" or "B1:ALG,B2:ORN"
  final String? arrAirport; // e.g., "B1:CDG" or "B1:CDG,B2:ALG"
  final String? depTime; // e.g., "B1:S1" or "B1:S1,B2:S2"
  final String? arrTime; // e.g., "B1:S1" or "B1:S1,B2:S3"
  final String? supplier;

  FlightResultsRequest({
    required this.searchCode,
    this.page = 1,
    this.minPrice,
    this.maxPrice,
    this.isRefundable,
    this.sort,
    this.includedBaggageOnly,
    this.noCodeshare,
    this.airline,
    this.stops,
    this.depAirport,
    this.arrAirport,
    this.depTime,
    this.arrTime,
    this.supplier,
  });

  Map<String, String> toQueryParams() {
    final params = <String, String>{
      'searchCode': searchCode,
      'page': page.toString(),
    };
    if (minPrice != null) params['minP'] = minPrice!.round().toString();
    if (maxPrice != null) params['maxP'] = maxPrice!.round().toString();
    if (isRefundable != null) params['isRefundable'] = isRefundable.toString();
    if (sort != null) params['sort'] = sort!;
    if (includedBaggageOnly != null) {
      params['includedBaggageOnly'] = includedBaggageOnly.toString();
    }
    if (noCodeshare != null) params['noCodeshare'] = noCodeshare.toString();
    if (airline != null) params['airline'] = airline!;
    if (stops != null) params['stops'] = stops!;
    if (depAirport != null) params['depAirport'] = depAirport!;
    if (arrAirport != null) params['arrAirport'] = arrAirport!;
    if (depTime != null) params['depTime'] = depTime!;
    if (arrTime != null) params['arrTime'] = arrTime!;
    if (supplier != null) params['supplier'] = supplier!;
    return params;
  }
}
