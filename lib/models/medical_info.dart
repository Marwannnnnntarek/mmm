class MedicalInfo {
  const MedicalInfo({
    required this.hasMedicalConditions,
    this.conditionDetails,
  });

  final bool hasMedicalConditions;
  final String? conditionDetails;

  List<String> validate() {
    if (hasMedicalConditions &&
        (conditionDetails == null || conditionDetails!.trim().isEmpty)) {
      return ['medical_details_required'];
    }
    return [];
  }
}
