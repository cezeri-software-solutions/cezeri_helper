class CRZQrCodeData {
  final String bic;
  final String beneficiaryName;
  final String iban;
  final double amount;
  final String invoiceNumber;

  const CRZQrCodeData({required this.bic, required this.beneficiaryName, required this.iban, required this.amount, required this.invoiceNumber});
}
