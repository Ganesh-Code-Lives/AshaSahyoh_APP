class PersonalDetailsData {
  final String fullName;
  final String email;
  final DateTime? dateOfBirth;
  final String gender;
  final String address;

  PersonalDetailsData({
    required this.fullName,
    required this.email,
    this.dateOfBirth,
    required this.gender,
    required this.address,
  });
}

class DisabilityDetailsData {
  final bool hasDisability;
  final String disabilityType;
  final String? percentage;
  final String? certificateNumber;
  final List<String> assistiveDevices;

  DisabilityDetailsData({
    required this.hasDisability,
    required this.disabilityType,
    this.percentage,
    this.certificateNumber,
    required this.assistiveDevices,
  });
}
