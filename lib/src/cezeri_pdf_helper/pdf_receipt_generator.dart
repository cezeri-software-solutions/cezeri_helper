import 'package:cezeri_helper/cezeri_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'models/models.dart';
import 'widgets/widgets.dart';

class CZRPdfReceiptGenerator {
  static Future<Uint8List> generate({required CZRReceiptData receiptData, pw.Font? customBaseFont, pw.Font? customBoldFont}) async {
    // Load theme with fonts using the helper method
    final myTheme = await loadThemeWithFonts(
      regularFontPath: 'assets/fonts/Roboto-Regular.ttf',
      boldFontPath: 'assets/fonts/Roboto-Bold.ttf',
      customBaseFont: customBaseFont,
      customBoldFont: customBoldFont,
    );

    final pdf = pw.Document(theme: myTheme);

    pw.MemoryImage? logoImage;

    try {
      final response = await http.get(Uri.parse(receiptData.logoUrl));
      if (response.statusCode == 200) {
        final Uint8List imageBytes = Uint8List.fromList(response.bodyBytes);
        logoImage = pw.MemoryImage(imageBytes);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    pdf.addPage(
      pw.MultiPage(
        header: (context) => _buildHeader(receiptData.receiptTitle, logoImage),
        build: (context) {
          return [
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 6,
                  child: _buildAddress(receiptData.companyAddress, receiptData.customerAddressInvoice, ReceiptAddressType.invoice),
                ),
                pw.Expanded(
                  flex: 4,
                  child: _buildAddress(receiptData.companyAddress, receiptData.customerAddressDelivery, ReceiptAddressType.delivery),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(children: [pw.Spacer(flex: 6), pw.Expanded(flex: 4, child: _buildAppointmentInformations(receiptData.receiptInformation))]),
            pw.SizedBox(height: 30),
            _buildPositions(receiptData.receiptProducts, receiptData.receiptType, receiptData.currency),
            if (receiptData.receiptType != CZRReceiptType.deliveryNote) ...[
              pw.Divider(thickness: 0.5),
              _buildTotalAmount(receiptData.receiptTotalAmountData, receiptData.isSmallBusiness, receiptData.currency),
              pw.SizedBox(height: 10),
              if (receiptData.receiptType == CZRReceiptType.invoice) ...[_buildServiceDateText(), pw.SizedBox(height: 10)],
              _buildPaymentTermText(receiptData.paymentTermText, receiptData.qrCodeData),
              if (receiptData.isSmallBusiness) ...[pw.SizedBox(height: 10), _buildSmallBusinessText()],
            ],
            pw.SizedBox(height: 10),
            if (receiptData.receiptDocumentText != null && receiptData.receiptDocumentText!.isNotEmpty) PdfText(receiptData.receiptDocumentText!),
          ];
        },
        footer: (context) => _buildFooter(receiptData.companyData),
        margin: const pw.EdgeInsets.only(left: 55, right: 55, top: 55, bottom: 20),
      ),
    );
    return pdf.save();
  }

  static pw.Widget _buildHeader(String receiptTitle, pw.MemoryImage? logoImage) => pw.Column(
    children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          PdfText(receiptTitle, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          logoImage != null ? _buildBranchLogo(logoImage) : pw.SizedBox(height: 100, width: 200),
        ],
      ),
      pw.SizedBox(height: 40),
    ],
  );

  static pw.Widget _buildBranchLogo(pw.MemoryImage url) => pw.SizedBox(height: 80, width: 160, child: pw.Image(url));

  static pw.Widget _buildAddress(CZRReceiptAddress companyAddress, CZRReceiptAddress customerAddress, ReceiptAddressType addressType) {
    final address = customerAddress;

    const companyTextStyle = pw.TextStyle(fontSize: 8, color: PdfColors.grey600);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (addressType == ReceiptAddressType.invoice)
          pw.Wrap(
            children: [
              pw.Container(
                decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey600, width: 0.4))),
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    if (companyAddress.companyName.isNotEmpty) PdfText('${companyAddress.companyName} | ', style: companyTextStyle),
                    if (companyAddress.name.trim().isNotEmpty) PdfText('${companyAddress.name} | ', style: companyTextStyle),
                    if (companyAddress.street.isNotEmpty) PdfText('${companyAddress.street} | ', style: companyTextStyle),
                    if (companyAddress.postcode.isNotEmpty || companyAddress.city.isNotEmpty)
                      PdfText('${companyAddress.postcode} ${companyAddress.city}', style: companyTextStyle),
                  ],
                ),
              ),
            ],
          ),
        if (addressType == ReceiptAddressType.delivery)
          PdfText('Lieferadresse:', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600, decoration: pw.TextDecoration.underline)),
        pw.SizedBox(height: 6),
        if (address.companyName != '') PdfText(address.companyName),
        if (address.companyName != '') pw.SizedBox(height: 2),
        PdfText(address.name),
        pw.SizedBox(height: 2),
        PdfText(address.street),
        if (address.street2.isNotEmpty) ...[pw.SizedBox(height: 2), PdfText(address.street2)],
        pw.SizedBox(height: 2),
        PdfText('${address.postcode} ${address.city}'),
        pw.SizedBox(height: 2),
        PdfText(address.country),
      ],
    );
  }

  static pw.Widget _buildAppointmentInformations(CZRReceiptInformation receiptInformation) => pw.Column(
    children: [
      pw.Divider(color: PdfColors.grey400, thickness: 0.5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [PdfText('Beleg Datum:'), PdfText(DateFormat('dd.MM.yyy', 'de').format(receiptInformation.receiptDate))],
      ),
      pw.SizedBox(height: 2),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [PdfText('Beleg Nr.:'), PdfText(receiptInformation.receiptNumber)]),
      if (receiptInformation.orderNumber != null && receiptInformation.orderNumber!.isNotEmpty) ...[
        pw.SizedBox(height: 2),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [PdfText('Bestellnummer:'), PdfText(receiptInformation.orderNumber!)]),
      ],
      pw.SizedBox(height: 2),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [PdfText('Kundennummer:'), PdfText(receiptInformation.customerNumber)]),
    ],
  );

  static pw.Widget _buildPositions(List<CZRReceiptProduct> receiptProducts, CZRReceiptType receiptType, String currency) {
    final headers = switch (receiptType) {
      CZRReceiptType.deliveryNote => ['Pos.', 'Artikelnummer / Bezeichnung', 'Menge'],
      _ => ['Pos.', 'Artikelnummer / Bezeichnung', 'Steuer', 'Menge', 'Netto Stk.', 'Brutto Stk.', 'Brutto Ges.'],
    };

    final data = [[]];
    int pos = 1;
    for (int i = 0; i < receiptProducts.length; i++) {
      final entry = switch (receiptType) {
        CZRReceiptType.deliveryNote => [
          pos,
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  PdfText(receiptProducts[i].articleNumber),
                  if (receiptProducts[i].unitPriceNet == 0.0) ...[
                    pw.SizedBox(width: 10),
                    PdfText('GESCHENKARTIKEL', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                  ],
                ],
              ),
              PdfText(receiptProducts[i].name),
            ],
          ),
          PdfText('${receiptProducts[i].quantity} Stk.'),
        ],
        _ => [
          pos,
          '${receiptProducts[i].articleNumber}\n${receiptProducts[i].name}',
          '${receiptProducts[i].taxRate}%',
          '${receiptProducts[i].quantity} Stk.',
          '${receiptProducts[i].unitPriceNet.toCurrencyStringToShow()}$currency',
          '${receiptProducts[i].unitPriceGross.toCurrencyStringToShow()}$currency',
          '${(receiptProducts[i].quantity * receiptProducts[i].unitPriceGross).toCurrencyStringToShow()}$currency',
        ],
      };
      pos = pos + 1;
      data.add(entry);
    }

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      // headerAlignment: pw.Alignment.centerLeft,
      cellStyle: const pw.TextStyle(fontSize: 8),
      columnWidths: switch (receiptType) {
        CZRReceiptType.deliveryNote => {0: const pw.FlexColumnWidth(4), 1: const pw.FlexColumnWidth(54), 3: const pw.FlexColumnWidth(10)},
        _ => {
          0: const pw.FlexColumnWidth(6),
          1: const pw.FlexColumnWidth(51),
          2: const pw.FlexColumnWidth(8),
          3: const pw.FlexColumnWidth(8),
          4: const pw.FlexColumnWidth(9),
          5: const pw.FlexColumnWidth(9),
          6: const pw.FlexColumnWidth(9),
        },
      },
      headerAlignments: switch (receiptType) {
        CZRReceiptType.deliveryNote => {0: pw.Alignment.topLeft, 1: pw.Alignment.topLeft, 2: pw.Alignment.topRight},
        _ => {
          0: pw.Alignment.topLeft,
          1: pw.Alignment.topLeft,
          2: pw.Alignment.topRight,
          3: pw.Alignment.topRight,
          4: pw.Alignment.topRight,
          5: pw.Alignment.topRight,
          6: pw.Alignment.topRight,
        },
      },
      cellAlignments: switch (receiptType) {
        CZRReceiptType.deliveryNote => {0: pw.Alignment.topLeft, 1: pw.Alignment.topLeft, 2: pw.Alignment.topRight},
        _ => {
          0: pw.Alignment.topLeft,
          1: pw.Alignment.topLeft,
          2: pw.Alignment.topRight,
          3: pw.Alignment.topRight,
          4: pw.Alignment.topRight,
          5: pw.Alignment.topRight,
          6: pw.Alignment.topRight,
        },
      },
    );
  }

  static pw.Widget _buildTotalAmount(CZRReceiptTotalAmountData receiptTotalAmountData, bool isSmallBusiness, String currency) {
    final subTotalNet = receiptTotalAmountData.subTotalNet;
    final subTotalGross = receiptTotalAmountData.subTotalGross;
    final posDiscountPercentAmountGross = receiptTotalAmountData.posDiscountPercentAmountGross;
    final discountPercentAmountGross = receiptTotalAmountData.discountPercentAmountGross;
    final discountGross = receiptTotalAmountData.discountGross;
    final additionalAmountGross = receiptTotalAmountData.additionalAmountGross;
    final totalShippingGross = receiptTotalAmountData.totalShippingGross;

    final totalNet = receiptTotalAmountData.totalNet.toCurrencyStringToShow();
    final taxRate = receiptTotalAmountData.taxRate.toStringAsFixed(0);
    final totalTax = receiptTotalAmountData.totalTax.toCurrencyStringToShow();
    final totalGross = receiptTotalAmountData.totalGross.toCurrencyStringToShow();

    final isPosDiscountPercentAmountGross = posDiscountPercentAmountGross > 0;
    final isDiscountPercentAmountGross = discountPercentAmountGross > 0;
    final isDiscountGross = discountGross > 0;
    final isAdditionalAmountGross = additionalAmountGross > 0;
    final isTotalShippingGross = totalShippingGross > 0;

    final showSubAmounts =
        isPosDiscountPercentAmountGross || isDiscountPercentAmountGross || isDiscountGross || isAdditionalAmountGross || isTotalShippingGross;

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        children: [
          pw.Spacer(flex: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (showSubAmounts)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Zwischensumme Netto'),
                      pw.Row(children: [PdfText(subTotalNet.toCurrencyStringToShow()), PdfText(' $currency')]),
                    ],
                  ),
                if (showSubAmounts)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Zwischensumme Brutto'),
                      pw.Row(children: [PdfText(subTotalGross.toCurrencyStringToShow()), PdfText(' $currency')]),
                    ],
                  ),
                if (isPosDiscountPercentAmountGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Pos. % Rabatt'),
                      pw.Row(children: [PdfText(posDiscountPercentAmountGross.toCurrencyStringToShow()), PdfText(' $currency')]),
                    ],
                  ),
                if (isDiscountPercentAmountGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('% Rabatt'),
                      pw.Row(children: [PdfText(discountPercentAmountGross.toCurrencyStringToShow()), PdfText(' $currency')]),
                    ],
                  ),
                if (isDiscountGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('$currency Rabatt'),
                      pw.Row(children: [PdfText(discountGross.toCurrencyStringToShow()), PdfText(' $currency')]),
                    ],
                  ),
                if (isAdditionalAmountGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Zuschlag'),
                      pw.Row(children: [PdfText(additionalAmountGross.toCurrencyStringToShow()), PdfText(' $currency')]),
                    ],
                  ),
                if (isTotalShippingGross)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Versandkosten'),
                      pw.Row(children: [PdfText(totalShippingGross.toCurrencyStringToShow()), PdfText(' $currency')]),
                    ],
                  ),
                if (showSubAmounts) pw.Divider(color: PdfColors.grey400, thickness: 0.5, height: 3),
                if (!isSmallBusiness) ...[
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('Gesamtbetrag Netto'),
                      pw.Row(children: [PdfText(totalNet), PdfText(' $currency')]),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      PdfText('USt. $taxRate%'),
                      pw.Row(children: [PdfText(totalTax), PdfText(' $currency')]),
                    ],
                  ),
                ],
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    PdfText('Gesamtbetrag Brutto', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Row(children: [PdfText(totalGross, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)), PdfText(' $currency')]),
                  ],
                ),
                pw.Divider(thickness: 0.5, color: PdfColors.grey400, height: 2.5),
                pw.Divider(thickness: 0.5, color: PdfColors.grey400, height: 2.5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildServiceDateText() => PdfText('Leistungsdatum entspricht Rechnungsdatum.');

  static pw.Widget _buildPaymentTermText(String paymentTermText, CRZQrCodeData? qrCodeData) {
    final qrCodeDataString =
        qrCodeData != null
            ? _generateEPCQrCodeString(
              bic: qrCodeData.bic, // Replace with your BIC
              beneficiaryName: qrCodeData.beneficiaryName, // Replace with your beneficiary name
              iban: qrCodeData.iban, // Replace with your IBAN
              amount: qrCodeData.amount, // Replace with your total amount
              invoiceNumber: qrCodeData.invoiceNumber, // Replace with your invoice number
            )
            : null;

    // Add the QR code to the PDF layout

    return pw.Column(
      children: [
        pw.RichText(
          text: pw.TextSpan(
            text: 'Zahlungsziel: ',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            children: [pw.TextSpan(text: paymentTermText, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal))],
          ),
        ),
        if (qrCodeDataString != null) ...[
          pw.SizedBox(height: 12),
          pw.Container(
            width: 60, // Adjust size as needed
            height: 60,
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 1), borderRadius: pw.BorderRadius.circular(4)),
            child: pw.BarcodeWidget(data: qrCodeDataString, barcode: pw.Barcode.qrCode()),
          ),
          pw.SizedBox(height: 10),
          pw.Center(child: pw.Text('Scannen Sie diesen QR-Code mit Ihrer Banking-App', style: const pw.TextStyle(fontSize: 8))),
        ],
      ],
    );
  }

  static pw.Widget _buildSmallBusinessText() => PdfText('Hinweis: Umsatzsteuerbefreit - Kleinunternehmer gem. § 6 Abs. 1 Z 27 UStG');

  static pw.Widget _buildFooter(CZRCompanyData companyData) {
    return pw.Column(
      children: [
        pw.Divider(thickness: 0.5),
        pw.DefaultTextStyle(
          style: const pw.TextStyle(fontSize: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (companyData.addressData.companyName.isNotEmpty)
                    PdfText(companyData.addressData.companyName, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  if (companyData.addressData.name.trim().isNotEmpty) PdfText(companyData.addressData.name),
                  PdfText(companyData.addressData.street),
                  PdfText('${companyData.addressData.postcode} ${companyData.addressData.city}'),
                  PdfText(companyData.addressData.country),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  PdfText(companyData.bankData.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  PdfText('BIC: ${companyData.bankData.bic}'),
                  PdfText('IBAN: ${companyData.bankData.iban}'),
                  if (companyData.bankData.paypalEmail != null) ...[
                    PdfText('Paypal:', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    PdfText(companyData.bankData.paypalEmail!),
                  ],
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  PdfText('Tel.: ${companyData.extraData.phone}'),
                  if (companyData.extraData.phoneMobile != null &&
                      companyData.extraData.phoneMobile!.isNotEmpty &&
                      companyData.extraData.phone != companyData.extraData.phoneMobile)
                    PdfText('Tel. Mobil: ${companyData.extraData.phoneMobile}'),
                  PdfText('Homepage:'),
                  PdfText(companyData.extraData.homepage),
                  PdfText('USt. -IdNr.: ${companyData.extraData.uidNumber}'),
                  PdfText('Firmenbuchnummer: ${companyData.extraData.commercialRegisterNumber}'),
                  PdfText('Firmenbuchgericht: ${companyData.extraData.commercialRegisterCourt}'),
                  PdfText('Sitz: ${companyData.extraData.commercialRegisterCourtSeat}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper method to load fonts from assets with fallback options
  static Future<pw.ThemeData> loadThemeWithFonts({
    String? regularFontPath,
    String? boldFontPath,
    pw.Font? customBaseFont,
    pw.Font? customBoldFont,
  }) async {
    // If custom fonts are provided, use them
    if (customBaseFont != null && customBoldFont != null) {
      return pw.ThemeData.withFont(base: customBaseFont, bold: customBoldFont);
    }

    // Try to load fonts from provided paths
    if (regularFontPath != null && boldFontPath != null) {
      try {
        return pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle.load(regularFontPath)),
          bold: pw.Font.ttf(await rootBundle.load(boldFontPath)),
        );
      } catch (e) {
        debugPrint('Failed to load fonts from provided paths: $e');
      }
    }

    // Try to load package fonts first
    try {
      return pw.ThemeData.withFont(
        base: pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf')),
        bold: pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf')),
      );
    } catch (e) {
      debugPrint('Package fonts not found, trying Google Fonts Roboto: $e');
      try {
        // Fallback to Google Fonts Roboto via HTTP
        final regularFontBytes = await _loadGoogleFont('Roboto', FontWeight.normal);
        final boldFontBytes = await _loadGoogleFont('Roboto', FontWeight.bold);

        return pw.ThemeData.withFont(base: pw.Font.ttf(regularFontBytes), bold: pw.Font.ttf(boldFontBytes));
      } catch (googleFontsError) {
        debugPrint('Google Fonts Roboto not available, using default fonts: $googleFontsError');
        return pw.ThemeData();
      }
    }
  }

  /// Helper method to load Google Fonts via HTTP
  static Future<ByteData> _loadGoogleFont(String fontFamily, FontWeight fontWeight) async {
    final weight = fontWeight == FontWeight.bold ? '700' : '400';

    // Use Google Fonts API to get the font URL
    final fontUrl = 'https://fonts.googleapis.com/css2?family=Roboto:wght@$weight&display=swap';

    try {
      // First, get the CSS file to extract the font URL
      final cssResponse = await http.get(Uri.parse(fontUrl));
      if (cssResponse.statusCode != 200) {
        throw Exception('Failed to load font CSS: ${cssResponse.statusCode}');
      }

      final cssContent = cssResponse.body;
      // Extract the font URL from the CSS (simplified approach)
      final fontUrlMatch = RegExp(r'url\((https://fonts\.gstatic\.com/[^)]+)\)').firstMatch(cssContent);

      if (fontUrlMatch == null) {
        throw Exception('Could not extract font URL from CSS');
      }

      final actualFontUrl = fontUrlMatch.group(1)!;

      // Download the actual font file
      final fontResponse = await http.get(Uri.parse(actualFontUrl));
      if (fontResponse.statusCode == 200) {
        return ByteData.sublistView(fontResponse.bodyBytes);
      } else {
        throw Exception('Failed to load font file: ${fontResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load Google Font: $e');
    }
  }
}

String _generateEPCQrCodeString({
  required String bic,
  required String beneficiaryName,
  required String iban,
  required double amount,
  required String invoiceNumber,
}) {
  // Stellen Sie sicher, dass der Betrag mit Punkt als Dezimaltrennzeichen formatiert ist.
  // NumberFormat('0.00', 'en_US') stellt sicher, dass immer zwei Nachkommastellen und Punkt als Dezimaltrennzeichen verwendet werden.
  final amountFormatted = NumberFormat('0.00', 'en_US').format(amount);

  // Unstrukturierte Referenz (Zahlungszweck)
  final unstructuredRemittanceInformation = invoiceNumber;
  print('unstructuredRemittanceInformation: $unstructuredRemittanceInformation');

  // Optionale Nachricht für den Kunden
  final additionalMessage = 'Vielen Dank fuer Ihre Zahlung der Rechnung $invoiceNumber'; // Umlaute vermeiden

  // Aufbau des EPC QR-Code Strings
  return [
    'BCD', // Service Tag
    '002', // Version (empfohlen)
    '1', // Character Set (UTF-8)
    'SCT', // Identification (SEPA Credit Transfer)
    bic, // BIC des Zahlungsempfängers
    beneficiaryName, // Name des Zahlungsempfängers
    iban, // IBAN des Zahlungsempfängers
    'EUR$amountFormatted', // Währung und Betrag
    'TRF', // Purpose Code
    '', // Referenz (Strukturiert) - "///" wenn nicht genutzt
    unstructuredRemittanceInformation, // Verwendungszweck (Unstrukturiert)
    additionalMessage, // Zusätzliche Nachricht
  ].join('\n'); // Zeilenumbrüche sind wichtig!
}
