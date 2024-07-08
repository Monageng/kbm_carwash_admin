class Franchise {
  int id;
  DateTime? createAt;
  String name;
  String? description;
  String? contactPerson;
  String? contactNumber;
  String? email;
  double? latitude;
  double? longitude;
  String? effectiveFromDate;
  String? effectiveToDate;
  String? modifiedBy;
  bool? active;

  //String? operatingHours; // Assuming operating_hours can be of any type
  String? streetAddress;
  String? city;
  String? province;
  String? postalCode;
  String? country;

  Franchise({
    required this.id,
    required this.name,
    this.description,
    this.contactPerson,
    this.contactNumber,
    this.email,
    this.streetAddress,
    this.city,
    this.province,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
    this.active,
    this.modifiedBy,
    this.effectiveFromDate,
    this.effectiveToDate,
  });

  // Convert Branches object to a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      "description": description,
      'contact_person': contactPerson,
      'contact_number': contactNumber,
      "email_address": email,
      'street_address': streetAddress,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'active': active,
      'modified_by': modifiedBy,
      'effective_from_date': effectiveFromDate,
      'effective_to_date': effectiveToDate,
    };
  }

  factory Franchise.fromJson(Map<String, dynamic> json) {
    return Franchise(
      id: json['id'],
      name: json['name'] as String,
      description: json['description'] as String,
      contactPerson: json['contact_person'] as String?,
      contactNumber: json['contact_number'] as String?,
      email: json['email_address'] as String?,
      streetAddress: json['street_address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      postalCode: json['postal_code'],
      country: json['country'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      active: json['active'],
      modifiedBy: json['modified_by'] as String?,
      effectiveFromDate: json['effective_from_date'] as String?,
      effectiveToDate: json['effective_to_date'] as String?,
    );
  }
}
