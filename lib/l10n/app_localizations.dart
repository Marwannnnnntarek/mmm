import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Sports For Life Academy'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Sports For Life Academy'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register your player now'**
  String get welcomeSubtitle;

  /// No description provided for @startRegistration.
  ///
  /// In en, this message translates to:
  /// **'Start Registration'**
  String get startRegistration;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Form'**
  String get registrationTitle;

  /// No description provided for @reviewApplicationButton.
  ///
  /// In en, this message translates to:
  /// **'Review Application'**
  String get reviewApplicationButton;

  /// No description provided for @stepParentInfo.
  ///
  /// In en, this message translates to:
  /// **'Parent / Guardian'**
  String get stepParentInfo;

  /// No description provided for @stepPlayerInfo.
  ///
  /// In en, this message translates to:
  /// **'Player Information'**
  String get stepPlayerInfo;

  /// No description provided for @stepMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical Information'**
  String get stepMedical;

  /// No description provided for @stepEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get stepEmergency;

  /// No description provided for @parentFullName.
  ///
  /// In en, this message translates to:
  /// **'Parent Full Name'**
  String get parentFullName;

  /// No description provided for @parentMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get parentMobile;

  /// No description provided for @parentAltMobile.
  ///
  /// In en, this message translates to:
  /// **'Alternative Mobile'**
  String get parentAltMobile;

  /// No description provided for @parentEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address (optional)'**
  String get parentEmail;

  /// No description provided for @playerFullName.
  ///
  /// In en, this message translates to:
  /// **'Player Full Name'**
  String get playerFullName;

  /// No description provided for @playerDob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get playerDob;

  /// No description provided for @playerGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get playerGender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @playerSchool.
  ///
  /// In en, this message translates to:
  /// **'School Name (optional)'**
  String get playerSchool;

  /// No description provided for @trainingScheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Training Schedule'**
  String get trainingScheduleLabel;

  /// No description provided for @trainingScheduleHint.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred training days'**
  String get trainingScheduleHint;

  /// No description provided for @scheduleSundayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Sun & Tue'**
  String get scheduleSundayTuesday;

  /// No description provided for @scheduleMondayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Mon & Wed'**
  String get scheduleMondayWednesday;

  /// No description provided for @scheduleFridaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Fri & Sat'**
  String get scheduleFridaySaturday;

  /// No description provided for @medicalConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Does the player have any medical conditions?'**
  String get medicalConditionsLabel;

  /// No description provided for @medicalConditionsDetails.
  ///
  /// In en, this message translates to:
  /// **'Medical Condition Details'**
  String get medicalConditionsDetails;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @emergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Name'**
  String get emergencyContactName;

  /// No description provided for @emergencyContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Phone'**
  String get emergencyContactPhone;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submitButton;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Application'**
  String get reviewTitle;

  /// No description provided for @reviewParentSection.
  ///
  /// In en, this message translates to:
  /// **'Parent / Guardian'**
  String get reviewParentSection;

  /// No description provided for @reviewPlayerSection.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get reviewPlayerSection;

  /// No description provided for @reviewTrainingSection.
  ///
  /// In en, this message translates to:
  /// **'Training Schedule'**
  String get reviewTrainingSection;

  /// No description provided for @reviewMedicalSection.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get reviewMedicalSection;

  /// No description provided for @reviewEmergencySection.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get reviewEmergencySection;

  /// No description provided for @duplicateWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Potential Duplicate Registration'**
  String get duplicateWarningTitle;

  /// No description provided for @duplicateWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'A registration for this player may already exist. Do you want to proceed?'**
  String get duplicateWarningMessage;

  /// No description provided for @duplicateProceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed Anyway'**
  String get duplicateProceed;

  /// No description provided for @duplicateCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get duplicateCancel;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Submitted!'**
  String get successTitle;

  /// No description provided for @successSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ve received your application'**
  String get successSubtitle;

  /// No description provided for @successReferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get successReferenceLabel;

  /// No description provided for @copyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyButton;

  /// No description provided for @copiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copiedMessage;

  /// No description provided for @successInstructions.
  ///
  /// In en, this message translates to:
  /// **'The academy team will contact you soon to confirm your registration and share next steps.'**
  String get successInstructions;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @errorSubmissionFailed.
  ///
  /// In en, this message translates to:
  /// **'Submission failed. Please check your connection and try again.'**
  String get errorSubmissionFailed;

  /// No description provided for @errorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please connect and try again.'**
  String get errorNoConnection;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneric;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationMobileFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number (e.g. 01012345678)'**
  String get validationMobileFormat;

  /// No description provided for @validationEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEmailFormat;

  /// No description provided for @validationDobFuture.
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be in the future'**
  String get validationDobFuture;

  /// No description provided for @validationDobRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a date of birth'**
  String get validationDobRequired;

  /// No description provided for @validationEmergencyPhoneSameAsParent.
  ///
  /// In en, this message translates to:
  /// **'Must differ from parent mobile number'**
  String get validationEmergencyPhoneSameAsParent;

  /// No description provided for @validationMedicalDetailsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please describe the medical condition'**
  String get validationMedicalDetailsRequired;

  /// No description provided for @validationScheduleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a training schedule'**
  String get validationScheduleRequired;

  /// No description provided for @childName.
  ///
  /// In en, this message translates to:
  /// **'Child Name'**
  String get childName;

  /// No description provided for @childAge.
  ///
  /// In en, this message translates to:
  /// **'Child Age'**
  String get childAge;

  /// No description provided for @swimmingLevel.
  ///
  /// In en, this message translates to:
  /// **'Swimming Level'**
  String get swimmingLevel;

  /// No description provided for @swimBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get swimBeginner;

  /// No description provided for @swimIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get swimIntermediate;

  /// No description provided for @swimAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get swimAdvanced;

  /// No description provided for @preferredBranch.
  ///
  /// In en, this message translates to:
  /// **'Preferred Branch'**
  String get preferredBranch;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @stepChildInfo.
  ///
  /// In en, this message translates to:
  /// **'Child Information'**
  String get stepChildInfo;

  /// No description provided for @stepRegistrationDetails.
  ///
  /// In en, this message translates to:
  /// **'Registration Details'**
  String get stepRegistrationDetails;

  /// No description provided for @successMessage.
  ///
  /// In en, this message translates to:
  /// **'Your application has been submitted successfully.'**
  String get successMessage;

  /// No description provided for @validationAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age (1–99)'**
  String get validationAge;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
