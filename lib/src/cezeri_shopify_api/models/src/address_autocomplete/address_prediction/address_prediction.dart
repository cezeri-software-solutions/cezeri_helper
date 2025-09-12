import 'package:freezed_annotation/freezed_annotation.dart';

import '../matched_substring/matched_substring.dart';

part 'address_prediction.freezed.dart';
part 'address_prediction.g.dart';

@freezed
/// The address prediction
class AddressPrediction with _$AddressPrediction {
  /// The address prediction constructor
  const factory AddressPrediction({String? addressId, String? description, List<MatchedSubstring>? matchedSubstrings}) = _AddressPrediction;

  /// The address prediction from json
  factory AddressPrediction.fromJson(Map<String, dynamic> json) => _$AddressPredictionFromJson(json);
}
