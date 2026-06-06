class RegistrationRequest {
  const RegistrationRequest({
    required this.parentName,
    required this.parentPhone,
    required this.childName,
    required this.childAge,
    required this.childGender,
    required this.swimmingLevel,
    required this.preferredBranch,
    this.notes,
  });

  final String parentName;
  final String parentPhone;
  final String childName;
  final int childAge;
  final String childGender;
  final String swimmingLevel;
  final String preferredBranch;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'parent_name': parentName,
    'parent_phone': parentPhone,
    'child_name': childName,
    'child_age': childAge,
    'child_gender': childGender,
    'swimming_level': swimmingLevel,
    'preferred_branch': preferredBranch,
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
  };
}
