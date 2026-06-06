// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sports For Life Academy';

  @override
  String get welcomeTitle => 'Welcome to Sports For Life Academy';

  @override
  String get welcomeSubtitle => 'Register your player now';

  @override
  String get startRegistration => 'Start Registration';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get registrationTitle => 'Registration Form';

  @override
  String get reviewApplicationButton => 'Review Application';

  @override
  String get stepParentInfo => 'Parent / Guardian';

  @override
  String get stepPlayerInfo => 'Player Information';

  @override
  String get stepMedical => 'Medical Information';

  @override
  String get stepEmergency => 'Emergency Contact';

  @override
  String get parentFullName => 'Parent Full Name';

  @override
  String get parentMobile => 'Mobile Number';

  @override
  String get parentAltMobile => 'Alternative Mobile';

  @override
  String get parentEmail => 'Email Address (optional)';

  @override
  String get playerFullName => 'Player Full Name';

  @override
  String get playerDob => 'Date of Birth';

  @override
  String get playerGender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get playerSchool => 'School Name (optional)';

  @override
  String get trainingScheduleLabel => 'Training Schedule';

  @override
  String get trainingScheduleHint => 'Choose your preferred training days';

  @override
  String get scheduleSundayTuesday => 'Sun & Tue';

  @override
  String get scheduleMondayWednesday => 'Mon & Wed';

  @override
  String get scheduleFridaySaturday => 'Fri & Sat';

  @override
  String get medicalConditionsLabel =>
      'Does the player have any medical conditions?';

  @override
  String get medicalConditionsDetails => 'Medical Condition Details';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get emergencyContactName => 'Emergency Contact Name';

  @override
  String get emergencyContactPhone => 'Emergency Contact Phone';

  @override
  String get nextButton => 'Next';

  @override
  String get backButton => 'Back';

  @override
  String get submitButton => 'Submit Application';

  @override
  String get editButton => 'Edit';

  @override
  String get reviewTitle => 'Review Application';

  @override
  String get reviewParentSection => 'Parent / Guardian';

  @override
  String get reviewPlayerSection => 'Player';

  @override
  String get reviewTrainingSection => 'Training Schedule';

  @override
  String get reviewMedicalSection => 'Medical';

  @override
  String get reviewEmergencySection => 'Emergency Contact';

  @override
  String get duplicateWarningTitle => 'Potential Duplicate Registration';

  @override
  String get duplicateWarningMessage =>
      'A registration for this player may already exist. Do you want to proceed?';

  @override
  String get duplicateProceed => 'Proceed Anyway';

  @override
  String get duplicateCancel => 'Cancel';

  @override
  String get successTitle => 'Registration Submitted!';

  @override
  String get successSubtitle => 'We\'ve received your application';

  @override
  String get successReferenceLabel => 'Reference Number';

  @override
  String get copyButton => 'Copy';

  @override
  String get copiedMessage => 'Copied!';

  @override
  String get successInstructions =>
      'The academy team will contact you soon to confirm your registration and share next steps.';

  @override
  String get doneButton => 'Done';

  @override
  String get errorSubmissionFailed =>
      'Submission failed. Please check your connection and try again.';

  @override
  String get errorNoConnection =>
      'No internet connection. Please connect and try again.';

  @override
  String get errorGeneric => 'An error occurred. Please try again.';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationMobileFormat =>
      'Enter a valid mobile number (e.g. 01012345678)';

  @override
  String get validationEmailFormat => 'Enter a valid email address';

  @override
  String get validationDobFuture => 'Date of birth cannot be in the future';

  @override
  String get validationDobRequired => 'Please select a date of birth';

  @override
  String get validationEmergencyPhoneSameAsParent =>
      'Must differ from parent mobile number';

  @override
  String get validationMedicalDetailsRequired =>
      'Please describe the medical condition';

  @override
  String get validationScheduleRequired => 'Please select a training schedule';

  @override
  String get childName => 'Child Name';

  @override
  String get childAge => 'Child Age';

  @override
  String get swimmingLevel => 'Swimming Level';

  @override
  String get swimBeginner => 'Beginner';

  @override
  String get swimIntermediate => 'Intermediate';

  @override
  String get swimAdvanced => 'Advanced';

  @override
  String get preferredBranch => 'Preferred Branch';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get stepChildInfo => 'Child Information';

  @override
  String get stepRegistrationDetails => 'Registration Details';

  @override
  String get successMessage =>
      'Your application has been submitted successfully.';

  @override
  String get validationAge => 'Please enter a valid age (1–99)';
}
