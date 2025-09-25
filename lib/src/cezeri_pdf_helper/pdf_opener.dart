import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class CZRPdfOpener {
  static Future<void> openPdf({required String name, required Uint8List byteList, bool showInBrowser = true}) async {
    if (kIsWeb) {
      if (showInBrowser) {
        final blob = html.Blob([byteList], 'application/pdf');

        final url = html.Url.createObjectUrlFromBlob(blob);

        html.window.open(url, '_blank');

        html.Url.revokeObjectUrl(url);
      } else {
        final blob = html.Blob([byteList]);

        final url = html.Url.createObjectUrlFromBlob(blob);

        html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = name
          ..click();

        html.Url.revokeObjectUrl(url);
      }
    } else {
      if (Platform.isIOS) {
        final output = await getTemporaryDirectory();
        final filePath = '${output.path}/$name';
        final file = File(filePath);

        await file.writeAsBytes(byteList);
        await OpenFilex.open(filePath);
      } else {
        final output = await getExternalStorageDirectory();
        final filePath = '${output!.path}/$name';
        final file = File(filePath);

        await file.writeAsBytes(byteList);
        await OpenFilex.open(filePath);
      }
    }
  }
}
