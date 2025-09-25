import 'models.dart';

enum CZRReceiptType { offer, appointment, deliveryNote, invoice, credit }

class CZRReceiptData {
  final CZRReceiptType receiptType;
  final String receiptTitle;
  final String logoUrl;
  final CZRReceiptAddress companyAddress;
  final CZRReceiptAddress customerAddressInvoice;
  final CZRReceiptAddress customerAddressDelivery;
  final CZRReceiptInformation receiptInformation;
  final String paymentTermText;
  final CRZQrCodeData? qrCodeData;
  final bool isSmallBusiness;
  final String? receiptDocumentText;
  final CZRCompanyData companyData;
  final CZRReceiptTotalAmountData receiptTotalAmountData;
  final String currency;
  final List<CZRReceiptProduct> receiptProducts;

  const CZRReceiptData({
    required this.receiptType,
    required this.receiptTitle,
    required this.logoUrl,
    required this.companyAddress,
    required this.customerAddressInvoice,
    required this.customerAddressDelivery,
    required this.receiptInformation,
    required this.paymentTermText,
    required this.qrCodeData,
    required this.isSmallBusiness,
    required this.receiptDocumentText,
    required this.companyData,
    required this.receiptTotalAmountData,
    required this.currency,
    required this.receiptProducts,
  });
}
