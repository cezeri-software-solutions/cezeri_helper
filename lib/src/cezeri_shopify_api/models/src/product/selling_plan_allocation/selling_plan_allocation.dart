import 'package:freezed_annotation/freezed_annotation.dart';

import '../price_v_2/price_v_2.dart';
import 'selling_plan/selling_plan.dart';

part 'selling_plan_allocation.freezed.dart';
part 'selling_plan_allocation.g.dart';

@freezed
/// The SellingPlanAllocation class
class SellingPlanAllocation with _$SellingPlanAllocation {
  const SellingPlanAllocation._();

  /// The SellingPlanAllocation constructor
  factory SellingPlanAllocation({
    required PriceV2? checkoutChargeAmount,
    required PriceV2? remainingBalanceChargeAmount,
    required SellingPlan? sellingPlan,
  }) = _SellingPlanAllocation;

  /// The SellingPlanAllocation from json
  factory SellingPlanAllocation.fromJson(Map<String, dynamic> json) => _$SellingPlanAllocationFromJson(json);
}
