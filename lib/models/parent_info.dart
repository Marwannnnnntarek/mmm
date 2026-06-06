class ParentInfo {
  const ParentInfo({
    required this.fullName,
    required this.mobileNumber,
    required this.alternativeMobileNumber,
    this.email,
  });

  final String fullName;
  final String mobileNumber;
  final String alternativeMobileNumber;
  final String? email;

  static final RegExp _egyptianMobileRegex = RegExp(r'^01[0125]\d{8}$');

  static bool isValidEgyptianMobile(String value) =>
      _egyptianMobileRegex.hasMatch(value.trim());

  static bool isValidEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());

  List<String> validate() {
    final errors = <String>[];
    if (fullName.trim().isEmpty) errors.add('parent_full_name_required');
    if (!isValidEgyptianMobile(mobileNumber)) {
      errors.add('mobile_invalid_format');
    }
    if (!isValidEgyptianMobile(alternativeMobileNumber)) {
      errors.add('alt_mobile_invalid_format');
    }
    if (email != null && email!.isNotEmpty && !isValidEmail(email!)) {
      errors.add('email_invalid_format');
    }
    return errors;
  }
}
