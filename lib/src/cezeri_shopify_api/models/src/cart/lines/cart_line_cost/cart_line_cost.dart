import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../product/price_v_2/price_v_2.dart';

part 'cart_line_cost.freezed.dart';
part 'cart_line_cost.g.dart';

@freezed
/// The cart line cost
abstract class CartLineCost with _$CartLineCost {
  const CartLineCost._();

  /// The cart line cost constructor
  factory CartLineCost({
    required PriceV2 amountPerQuantity,
    required PriceV2 subtotalAmount,
    required PriceV2 totalAmount,
    PriceV2? compareAtAmountPerQuantity,
  }) = _CartLineCost;

  /// the cart line cost from json
  factory CartLineCost.fromJson(Map<String, dynamic> json) => _$CartLineCostFromJson(json);
}
