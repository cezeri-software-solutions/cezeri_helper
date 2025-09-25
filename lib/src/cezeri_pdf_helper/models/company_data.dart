class CZRCompanyData {
  final CompanyAddressData addressData;
  final CompanyBankData bankData;
  final CompanyExtraData extraData;

  const CZRCompanyData({required this.addressData, required this.bankData, required this.extraData});
}

class CompanyAddressData {
  final String companyName;
  final String name;
  final String street;
  final String postcode;
  final String city;
  final String country;

  const CompanyAddressData({
    required this.companyName,
    required this.name,
    required this.street,
    required this.postcode,
    required this.city,
    required this.country,
  });
}

class CompanyBankData {
  final String name;
  final String bic;
  final String iban;
  final String bankAccountHolder;
  final String? paypalEmail;

  const CompanyBankData({required this.name, required this.bic, required this.iban, required this.bankAccountHolder, required this.paypalEmail});
}

class CompanyExtraData {
  final String phone;
  final String? phoneMobile;
  final String homepage;
  final String uidNumber;
  final String commercialRegisterNumber; // Firmenbuchnummer
  final String commercialRegisterCourt; // Firmenbuchgericht
  final String commercialRegisterCourtSeat; // Firmenbuchgericht Sitz

  const CompanyExtraData({
    required this.phone,
    required this.phoneMobile,
    required this.homepage,
    required this.uidNumber,
    required this.commercialRegisterNumber,
    required this.commercialRegisterCourt,
    required this.commercialRegisterCourtSeat,
  });
}
