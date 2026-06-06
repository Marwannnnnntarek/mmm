import 'parent_info.dart';

class EmergencyContact {
  const EmergencyContact({
    required this.name,
    required this.phoneNumber,
  });

  final String name;
  final String phoneNumber;

  String? validateUniqueness(String parentMobile) {
    if (phoneNumber.trim() == parentMobile.trim()) {
      return 'emergency_phone_same_as_parent';
    }
    return null;
  }

  List<String> validate({String? parentMobile}) {
    final errors = <String>[];
    if (name.trim().isEmpty) errors.add('emergency_name_required');
    if (!ParentInfo.isValidEgyptianMobile(phoneNumber)) {
      errors.add('emergency_phone_invalid_format');
    }
    if (parentMobile != null) {
      final uniqueError = validateUniqueness(parentMobile);
      if (uniqueError != null) errors.add(uniqueError);
    }
    return errors;
  }
}
