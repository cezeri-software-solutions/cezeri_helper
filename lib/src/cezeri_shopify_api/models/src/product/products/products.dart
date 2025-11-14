import 'package:freezed_annotation/freezed_annotation.dart';

import '../product.dart';

part 'products.freezed.dart';
part 'products.g.dart';

@freezed
/// The products
abstract class Products with _$Products {
  const Products._();

  /// The products constructor
  factory Products({required List<Product> productList, required bool hasNextPage}) = _Products;

  /// The products from graphjson factory
  factory Products.fromGraphJson(Map<String, dynamic> json) =>
      Products(productList: _getProductList(json), hasNextPage: (json['pageInfo'] ?? const {})['hasNextPage'] ?? false);

  static List<Product> _getProductList(Map<String, dynamic> json) {
    return (json['edges'] as List?)?.map((e) => Product.fromGraphJson(e ?? const {})).toList() ?? const <Product>[];
  }

  /// The products from json factory
  factory Products.fromJson(Map<String, dynamic> json) => _$ProductsFromJson(json);
}
