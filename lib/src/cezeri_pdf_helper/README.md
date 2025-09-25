# CZR PDF Receipt Generator

Dieses Package bietet eine robuste Lösung für die Generierung von PDF-Rechnungen
mit automatischem Font-Fallback.

## Font-Handling

Das Package unterstützt mehrere Font-Quellen mit automatischem Fallback:

1. **Package-Fonts** (assets/fonts/Roboto-Regular.ttf,
   assets/fonts/Roboto-Bold.ttf)
2. **Google Fonts Roboto** (automatischer Fallback wenn Package-Fonts nicht
   verfügbar)
3. **Benutzerdefinierte Fonts** (über Parameter)
4. **System-Fonts** (Standard-Fonts als letzter Fallback)

## Verwendung

### Standard-Verwendung (empfohlen)

```dart
final pdfBytes = await CZRPdfReceiptGenerator.generate(
  receiptData: receiptData,
);
```

### Mit benutzerdefinierten Fonts

```dart
// Fonts aus Ihrem eigenen Projekt laden
final regularFont = pw.Font.ttf(await rootBundle.load('assets/fonts/MyFont-Regular.ttf'));
final boldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/MyFont-Bold.ttf'));

final pdfBytes = await CZRPdfReceiptGenerator.generate(
  receiptData: receiptData,
  customBaseFont: regularFont,
  customBoldFont: boldFont,
);
```

### Font-Theme direkt laden

```dart
final theme = await CZRPdfReceiptGenerator.loadThemeWithFonts(
  regularFontPath: 'assets/fonts/MyFont-Regular.ttf',
  boldFontPath: 'assets/fonts/MyFont-Bold.ttf',
);
```

## Installation in Ihrem Projekt

### Option 1: Package-Fonts verwenden (empfohlen)

Fügen Sie die Fonts zu Ihrem Projekt hinzu:

1. Kopieren Sie die Font-Dateien in Ihr Projekt:
   ```
   assets/fonts/Roboto-Regular.ttf
   assets/fonts/Roboto-Bold.ttf
   ```

2. Aktualisieren Sie Ihre `pubspec.yaml`:
   ```yaml
   flutter:
       assets:
           - assets/fonts/
   ```

### Option 2: Google Fonts verwenden (automatisch)

Das Package lädt automatisch Roboto über die Google Fonts API (HTTP), wenn die
Package-Fonts nicht verfügbar sind. Keine zusätzlichen Dependencies
erforderlich.

### Option 3: Eigene Fonts verwenden

Laden Sie Ihre eigenen Fonts und übergeben Sie sie als Parameter.

## Fehlerbehandlung

Das Package behandelt Font-Fehler automatisch:

- Wenn Package-Fonts nicht gefunden werden → Google Fonts Roboto
- Wenn Google Fonts nicht verfügbar sind → System-Fonts
- Debug-Meldungen werden ausgegeben, um Probleme zu identifizieren

## Troubleshooting

**Fehler: "Unable to load asset: assets/fonts/Roboto-Regular.ttf"**

Lösungen:

1. Kopieren Sie die Font-Dateien in Ihr Projekt (siehe Option 1)
2. Das Package lädt automatisch Roboto über Google Fonts (siehe Option 2)
3. Übergeben Sie eigene Fonts als Parameter (siehe Option 3)
4. Das Package fällt automatisch auf System-Fonts zurück
