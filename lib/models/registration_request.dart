class RegistrationRequest {
  const RegistrationRequest({
    required this.playerFirstName,
    required this.playerMiddleName,
    required this.playerLastName,
    required this.dateOfBirth,
    required this.gender,
    this.school,
    this.club,
    required this.fatherPhone,
    required this.motherPhone,
    required this.emergencyPhone,
    this.fatherOccupation,
    this.motherOccupation,
    this.email,
    this.referralSources = const [],
  });

  final String playerFirstName;
  final String playerMiddleName;
  final String playerLastName;
  final DateTime dateOfBirth;
  final String gender;
  final String? school;
  final String? club;
  final String fatherPhone;
  final String motherPhone;
  final String emergencyPhone;
  final String? fatherOccupation;
  final String? motherOccupation;
  final String? email;
  final List<String> referralSources;

  int _computeAge() {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toJson() {
    final dob =
        '${dateOfBirth.year.toString().padLeft(4, '0')}-'
        '${dateOfBirth.month.toString().padLeft(2, '0')}-'
        '${dateOfBirth.day.toString().padLeft(2, '0')}';
    return {
      'player_first_name': playerFirstName,
      'player_middle_name': playerMiddleName,
      'player_last_name': playerLastName,
      'player_dob': dob,
      'player_age': _computeAge(),
      'player_gender': gender,
      if (school != null && school!.isNotEmpty) 'player_school': school,
      if (club != null && club!.isNotEmpty) 'player_club': club,
      'father_phone': fatherPhone,
      'mother_phone': motherPhone,
      'emergency_phone': emergencyPhone,
      if (fatherOccupation != null && fatherOccupation!.isNotEmpty)
        'father_occupation': fatherOccupation,
      if (motherOccupation != null && motherOccupation!.isNotEmpty)
        'mother_occupation': motherOccupation,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (referralSources.isNotEmpty) 'referral_sources': referralSources,
    };
  }
}
