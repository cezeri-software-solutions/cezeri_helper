import 'package:freezed_annotation/freezed_annotation.dart';

import '../../product/price_v_2/price_v_2.dart';

part 'cart_cost.freezed.dart';
part 'cart_cost.g.dart';

@freezed
/// The cart cost
abstract class CartCost with _$CartCost {
  const CartCost._();

  /// cart cost factory
  factory CartCost({
    required PriceV2 checkoutChargeAmount,
    required PriceV2 subtotalAmount,
    required bool subtotalAmountEstimated,
    required PriceV2 totalAmount,
    required bool totalAmountEstimated,
    PriceV2? totalDutyAmount,
    required bool totalDutyAmountEstimated,
    PriceV2? totalTaxAmount,
    required bool totalTaxAmountEstimated,
  }) = _CartCost;

  /// cart cost from json
  factory CartCost.fromJson(Map<String, dynamic> json) => _$CartCostFromJson(json);
}
