import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../classes/cezeri_file.dart';

class CezeriDropzoneWeb extends StatefulWidget {
  final Widget? title;
  final Icon? icon;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? highlightColor;
  final List<String>? mime;
  final void Function(List<CezeriFile>) getCezeriFiles;

  const CezeriDropzoneWeb({
    super.key,
    this.title,
    this.icon,
    this.height = 150,
    this.width = 300,
    this.borderRadius = 10.0,
    this.backgroundColor = Colors.green,
    this.highlightColor = const Color(0xFF64A0C8),
    this.mime = const [],
    required this.getCezeriFiles,
  });

  @override
  State<CezeriDropzoneWeb> createState() => _CezeriDropzoneWebState();
}

class _CezeriDropzoneWebState extends State<CezeriDropzoneWeb> {
  late DropzoneViewController _controller;
  bool _isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    return MaterialButton(
      onPressed: () async {
        final events = await _controller.pickFiles(multiple: true, mime: widget.mime!);
        if (events.isEmpty) return;

        final myFiles = await incomingInvoiceDropFiles(events, _controller);

        widget.getCezeriFiles(myFiles);
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.all(widget.borderRadius!),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
          color: _isHighlighted ? widget.highlightColor : widget.backgroundColor,
        ),
        child: DottedBorder(
          options: RectDottedBorderOptions(
            color: Colors.white,
            strokeWidth: 3,
            padding: EdgeInsets.zero,
            dashPattern: const [8, 4],
            // radius: Radius.circular(widget.borderRadius!),
          ),
          child: Stack(
            children: [
              DropzoneView(
                onCreated: (controller) => _controller = controller,
                onDropFile: (event) async {
                  debugPrint('onDropFile wird ausgeführt: ${event.runtimeType}');
                  final myFiles = await incomingInvoiceDropFile(event, _controller);

                  setState(() => _isHighlighted = false);

                  widget.getCezeriFiles([myFiles]);
                },
                // onDropFiles: (events) async {
                //   debugPrint('onDropFiles wird ausgeführt: ${events.runtimeType}');
                //   final myFiles = await incomingInvoiceDropFile(events, _controller);

                //   setState(() => _isHighlighted = false);

                //   widget.getMyFiles([myFiles]);
                // },
                onHover: () => setState(() => _isHighlighted = true),
                onLeave: () => setState(() => _isHighlighted = false),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.icon ?? const Icon(Icons.cloud_upload, size: 50, color: Colors.white),
                    widget.title ?? Text('Dokument/e hochladen', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<CezeriFile> incomingInvoiceDropFile(dynamic event, DropzoneViewController controller) async {
    debugPrint('Event Typ: ${event.runtimeType}');

    final name = await controller.getFilename(event);
    final mime = await controller.getFileMIME(event);
    final size = await controller.getFileSize(event);
    final bytes = await controller.getFileData(event);
    // final url = await controller.createFileUrl(event);

    debugPrint('Name: $name');

    final myFile = CezeriFile(fileBytes: bytes, name: name, mimeType: mime, size: size);

    return myFile;
  }

  Future<List<CezeriFile>> incomingInvoiceDropFiles(List<DropzoneFileInterface> events, DropzoneViewController controller) async {
    final myFiles = <CezeriFile>[];

    for (final event in events) {
      final myFile = await incomingInvoiceDropFile(event, controller);
      myFiles.add(myFile);
    }

    return myFiles;
  }
}
