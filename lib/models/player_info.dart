enum Gender { male, female }

class PlayerInfo {
  const PlayerInfo({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    this.schoolName,
  });

  final String fullName;
  final DateTime dateOfBirth;
  final Gender gender;
  final String? schoolName;

  static bool isDobValid(DateTime dob) =>
      dob.isBefore(DateTime.now());

  List<String> validate() {
    final errors = <String>[];
    if (fullName.trim().isEmpty) errors.add('player_full_name_required');
    if (!isDobValid(dateOfBirth)) errors.add('dob_future_not_allowed');
    return errors;
  }
}
