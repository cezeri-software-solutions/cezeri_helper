class CZRReceiptTotalAmountData {
  final double subTotalNet;
  final double subTotalGross;
  final double posDiscountPercentAmountGross;
  final double discountPercentAmountGross;
  final double discountGross;
  final double additionalAmountGross;
  final double totalShippingGross;
  final double totalNet;
  final int taxRate;
  final double totalTax;
  final double totalGross;

  const CZRReceiptTotalAmountData({
    required this.subTotalNet,
    required this.subTotalGross,
    required this.posDiscountPercentAmountGross,
    required this.discountPercentAmountGross,
    required this.discountGross,
    required this.additionalAmountGross,
    required this.totalShippingGross,
    required this.totalNet,
    required this.taxRate,
    required this.totalTax,
    required this.totalGross,
  });
}
