import 'package:freezed_annotation/freezed_annotation.dart';

import '../../product/price_v_2/price_v_2.dart';

part 'cart_discount_allocation.freezed.dart';
part 'cart_discount_allocation.g.dart';

@freezed
/// The cart discount allocation
class CartDiscountAllocation with _$CartDiscountAllocation {
  const CartDiscountAllocation._();

  /// The cart discount allocation constructor
  factory CartDiscountAllocation({required PriceV2? discountedAmount}) = _CartDiscountAllocation;

  /// The cart discount allocation from json
  factory CartDiscountAllocation.fromJson(Map<String, dynamic> json) => _$CartDiscountAllocationFromJson(json);
}
