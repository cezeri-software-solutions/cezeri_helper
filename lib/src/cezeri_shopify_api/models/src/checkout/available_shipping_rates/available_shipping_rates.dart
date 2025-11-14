import 'package:freezed_annotation/freezed_annotation.dart';

import '../shipping_rates/shipping_rates.dart';

part 'available_shipping_rates.freezed.dart';
part 'available_shipping_rates.g.dart';

@freezed
/// The available shipping rates
abstract class AvailableShippingRates with _$AvailableShippingRates {
  const AvailableShippingRates._();

  /// The available shipping rates constructor
  factory AvailableShippingRates({required bool ready, required List<ShippingRates>? shippingRates}) = _AvailableShippingRates;

  /// The available shipping rates from json
  factory AvailableShippingRates.fromJson(Map<String, dynamic> json) => _$AvailableShippingRatesFromJson(json);
}
