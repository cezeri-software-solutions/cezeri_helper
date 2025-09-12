# Cezeri Helper

Ein Flutter Package mit gemeinsamen Widgets, Konstanten und Utilities für Flutter Projekte. Enthält UI Components, Shopify API Integration und nützliche Erweiterungen.

## Features

- 🎨 **UI Components**: Vorgefertigte Widgets für konsistente Benutzeroberflächen
- 🛒 **Shopify API Integration**: Vollständige Shopify Storefront und Admin API Unterstützung
- 🌍 **Internationalisierung**: Länder- und Währungsunterstützung
- 📱 **Responsive Design**: Anpassbare Komponenten für verschiedene Bildschirmgrößen
- 🎯 **Formulare**: Spezialisierte Input-Felder und Validierung
- 🎭 **Themes**: Vordefinierte Text-Styles und Design-System

## Getting started

### Installation

Füge `cezeri_helper` zu deiner `pubspec.yaml` hinzu:

```yaml
dependencies:
  cezeri_helper:
    git:
      url: https://github.com/aliince/cezeri_helper.git
      ref: main
```

Oder falls auf pub.dev veröffentlicht:

```yaml
dependencies:
  cezeri_helper: ^0.0.1
```

### Import

```dart
import 'package:cezeri_helper/cezeri_helper.dart';
```

## Usage

### UI Components

```dart
// Cezeri Pressable Card
CezeriPressableCard(
  onTap: () => print('Card tapped'),
  child: Text('Tappable Card'),
)

// Cezeri Avatar
CezeriAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  size: 50,
)

// Cezeri Country Flag
CezeriCountryFlag(
  countryCode: 'DE',
  size: 32,
)
```

### Shopify API

```dart
// Shopify Storefront API
final shopify = ShopifyStorefront(
  shopDomain: 'your-shop.myshopify.com',
  storefrontAccessToken: 'your-token',
);

// Produkte abrufen
final products = await shopify.getProducts();
```

### Formulare

```dart
// Cezeri Text Form Field
CezeriTextFormField(
  title: 'E-Mail',
  validator: (value) => value?.isEmpty == true ? 'Bitte E-Mail eingeben' : null,
)

// Autocomplete Text Field
CezeriAutocompleteTextField(
  suggestions: ['Option 1', 'Option 2'],
  onChanged: (value) => print(value),
)
```

## Dependencies

Dieses Package verwendet folgende Hauptdependencies:

- `freezed` - Für immutable Klassen
- `graphql_flutter` - Für Shopify GraphQL API
- `auto_route` - Für Navigation
- `cached_network_image` - Für Bild-Caching
- `responsive_framework` - Für responsive Design

## Additional information

- **Repository**: [GitHub](https://github.com/aliince/cezeri_helper)
- **Issues**: [GitHub Issues](https://github.com/aliince/cezeri_helper/issues)
- **License**: Siehe [LICENSE](LICENSE) Datei

## Contributing

Beiträge sind willkommen! Bitte erstelle einen Pull Request oder öffne ein Issue für Bugs und Feature-Requests.
