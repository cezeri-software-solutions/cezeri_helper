// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../json_helper.dart';
import 'attribute/attribute.dart';
import 'cart_model.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
/// The cart
class Cart with _$Cart {
  const Cart._();

  /// The cart constructor
  factory Cart({
    required String id,
    required String? checkoutUrl,
    required CartCost? cost,
    required int? totalQuantity,
    required List<CartDiscountAllocation?>? discountAllocations,
    required List<CartDiscountCode?>? discountCodes,
    required String? createdAt,
    List<Attribute?>? attributes,
    CartBuyerIdentity? buyerIdentity,
    String? note,
    String? updatedAt,
    @JsonKey(fromJson: JsonHelper.lines) required List<Line> lines,
  }) = _Cart;

  /// The cart from json
  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}
