// ignore_for_file: constant_identifier_names

/// Enum: SortKeyProductCollection
enum SortKeyProductCollection {
  /// Title
  TITLE,

  /// Price
  PRICE,

  /// Best selling
  BEST_SELLING,

  /// Created
  CREATED,

  /// ID
  ID,

  /// Manual
  MANUAL,

  /// Collection default
  COLLECTION_DEFAULT,

  /// Relevance
}

/// Extension for enum SortKeyProductCollection
extension ParseToStringProductCollection on SortKeyProductCollection {
  /// Returns the string representation of the enum
  String parseToString() {
    return toString().split('.')[1];
  }
}
