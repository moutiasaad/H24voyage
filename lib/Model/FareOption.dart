class FareOption {
  final String title;
  final int oldPrice;
  final int price;
  final int cancellationFee;
  final int dateChangeFee;

  FareOption({
    required this.title,
    required this.oldPrice,
    required this.price,
    required this.cancellationFee,
    required this.dateChangeFee,
  });
}
