import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';

class CezeriFile {
  final Uint8List fileBytes;
  final String name;
  final String? mimeType;
  final int? size;
  final String? mimeExtension; // statt z.B. image/png = .png

  CezeriFile({required this.fileBytes, required this.name, this.mimeType, this.size}) : mimeExtension = _convertMimeTypeToExtension(mimeType);

  static String? _convertMimeTypeToExtension(String? mimeType) {
    if (mimeType == null) return null;
    // Findet den letzten Index von '/' und schneidet bis dahin ab
    int slashIndex = mimeType.lastIndexOf('/');
    if (slashIndex != -1 && slashIndex < mimeType.length - 1) {
      // Schneidet den Teil vor dem '/' ab und fügt einen Punkt davor
      return '.${mimeType.substring(slashIndex + 1)}';
    }
    // Rückgabe eines leeren Strings, wenn kein '/' gefunden wurde oder der String leer ist
    return null;
  }

  factory CezeriFile.empty() {
    return CezeriFile(fileBytes: Uint8List(0), name: '', mimeType: null, size: null);
  }

  CezeriFile copyWith({Uint8List? fileBytes, String? name, String? mimeType, int? size}) {
    return CezeriFile(fileBytes: fileBytes ?? this.fileBytes, name: name ?? this.name, mimeType: mimeType ?? this.mimeType, size: size ?? this.size);
  }

  @override
  String toString() {
    return 'CezeriFile(fileBytes: $fileBytes, name: $name, mimeType: $mimeType, size: $size)';
  }
}

Future<CezeriFile> convertPlatfomFileToCezeriFile(PlatformFile platformFile) async {
  final name = platformFile.name;
  Uint8List? fileBytes;

  if (platformFile.bytes != null) {
    // Für Web oder wenn Bytes verfügbar sind
    fileBytes = platformFile.bytes;
  } else if (platformFile.path != null) {
    // Für mobile Plattformen
    final file = File(platformFile.path!);
    fileBytes = await file.readAsBytes();
  } else {
    Logger().e('Konnte die Datei für ${platformFile.name} nicht lesen');
  }

  final mime = lookupMimeType('', headerBytes: fileBytes);

  return CezeriFile(name: name, fileBytes: fileBytes!, mimeType: mime);
}

Future<List<CezeriFile>> convertPlatfomFilesToCezeriFiles(List<PlatformFile> platformFiles) async {
  final List<CezeriFile> cezeriFiles = [];

  for (final platformFile in platformFiles) {
    final cezeriFile = await convertPlatfomFileToCezeriFile(platformFile);

    cezeriFiles.add(cezeriFile);
  }

  return cezeriFiles;
}

Future<CezeriFile> convertIoFileToCezeriFile(File file) async {
  final name = file.path;
  final fileBytes = await file.readAsBytes();

  return CezeriFile(name: name, fileBytes: fileBytes);
}

Future<List<CezeriFile>> convertIoFilesToCezeriFiles(List<File> files) async {
  final List<CezeriFile> cezeriFiles = [];

  for (final file in files) {
    final cezeriFile = await convertIoFileToCezeriFile(file);

    cezeriFiles.add(cezeriFile);
  }

  return cezeriFiles;
}

Future<CezeriFile> convertXFileToCezeriFile(XFile platformFile) async {
  final name = platformFile.name;
  final Uint8List fileBytes = await platformFile.readAsBytes();

  final mime = lookupMimeType('', headerBytes: fileBytes);

  return CezeriFile(name: name, fileBytes: fileBytes, mimeType: mime);
}

Future<List<CezeriFile>> convertXFilesToCezeriFiles(List<XFile> platformFiles) async {
  final List<CezeriFile> cezeriFiles = [];

  for (final platformFile in platformFiles) {
    final cezeriFile = await convertXFileToCezeriFile(platformFile);

    cezeriFiles.add(cezeriFile);
  }

  return cezeriFiles;
}
