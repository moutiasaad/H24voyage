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
    return params;
  }
}
