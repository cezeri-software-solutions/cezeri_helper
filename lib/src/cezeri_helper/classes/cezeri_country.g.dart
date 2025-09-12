// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cezeri_country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CezeriCountry _$CezeriCountryFromJson(Map<String, dynamic> json) =>
    CezeriCountry(
      id: json['id'] as String,
      isoCode: json['isoCode'] as String,
      name: json['name'] as String,
      nameEnglish: json['nameEnglish'] as String,
      dialCode: json['dialCode'] as String,
    );

Map<String, dynamic> _$CezeriCountryToJson(CezeriCountry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isoCode': instance.isoCode,
      'name': instance.name,
      'nameEnglish': instance.nameEnglish,
      'dialCode': instance.dialCode,
    };
