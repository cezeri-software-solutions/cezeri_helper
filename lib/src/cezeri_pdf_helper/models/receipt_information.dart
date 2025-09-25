class CZRReceiptInformation {
  final DateTime receiptDate;
  final String receiptNumber;
  final String? orderNumber;
  final String customerNumber;

  const CZRReceiptInformation({required this.receiptDate, required this.receiptNumber, required this.orderNumber, required this.customerNumber});
}
