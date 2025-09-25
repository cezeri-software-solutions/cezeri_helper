enum ReceiptAddressType { invoice, delivery }

class CZRReceiptAddress {
  final String companyName;
  final String firstName;
  final String lastName;
  final String name;
  final String street;
  final String street2;
  final String postcode;
  final String city;
  final String country;
  final String phone;
  final String phoneMobile;
  final ReceiptAddressType addressType;

  const CZRReceiptAddress({
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.street2,
    required this.postcode,
    required this.city,
    required this.country,
    required this.phone,
    required this.phoneMobile,
    required this.addressType,
  }) : name = '$firstName $lastName';
}
