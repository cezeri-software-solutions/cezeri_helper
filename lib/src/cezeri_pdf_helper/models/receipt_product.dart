class CZRReceiptProduct {
  final String articleNumber;
  final String name;
  final double unitPriceNet;
  final double unitPriceGross;
  final int quantity;
  final int taxRate;

  const CZRReceiptProduct({
    required this.articleNumber,
    required this.name,
    required this.unitPriceNet,
    required this.unitPriceGross,
    required this.quantity,
    required this.taxRate,
  });
}
