// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أكاديمية سبورتس فور لايف';

  @override
  String get welcomeTitle => 'مرحباً بكم في أكاديمية سبورتس فور لايف';

  @override
  String get welcomeSubtitle => 'سجّل لاعبك الآن';

  @override
  String get startRegistration => 'ابدأ التسجيل';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get registrationTitle => 'استمارة التسجيل';

  @override
  String get reviewApplicationButton => 'مراجعة الطلب';

  @override
  String get stepParentInfo => 'ولي الأمر';

  @override
  String get stepPlayerInfo => 'معلومات اللاعب';

  @override
  String get stepMedical => 'المعلومات الطبية';

  @override
  String get stepEmergency => 'جهة الاتصال للطوارئ';

  @override
  String get parentFullName => 'الاسم الكامل لولي الأمر';

  @override
  String get parentMobile => 'رقم الجوال';

  @override
  String get parentAltMobile => 'رقم جوال بديل';

  @override
  String get parentEmail => 'البريد الإلكتروني (اختياري)';

  @override
  String get playerFullName => 'الاسم الكامل للاعب';

  @override
  String get playerDob => 'تاريخ الميلاد';

  @override
  String get playerGender => 'الجنس';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get playerSchool => 'اسم المدرسة (اختياري)';

  @override
  String get trainingScheduleLabel => 'جدول التدريب';

  @override
  String get trainingScheduleHint => 'اختر أيام التدريب المفضلة لديك';

  @override
  String get scheduleSundayTuesday => 'الأحد والثلاثاء';

  @override
  String get scheduleMondayWednesday => 'الاثنين والأربعاء';

  @override
  String get scheduleFridaySaturday => 'الجمعة والسبت';

  @override
  String get medicalConditionsLabel => 'هل يعاني اللاعب من حالات طبية؟';

  @override
  String get medicalConditionsDetails => 'تفاصيل الحالة الطبية';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get emergencyContactName => 'اسم جهة الاتصال للطوارئ';

  @override
  String get emergencyContactPhone => 'رقم هاتف جهة الطوارئ';

  @override
  String get nextButton => 'التالي';

  @override
  String get backButton => 'رجوع';

  @override
  String get submitButton => 'إرسال الطلب';

  @override
  String get editButton => 'تعديل';

  @override
  String get reviewTitle => 'مراجعة الطلب';

  @override
  String get reviewParentSection => 'ولي الأمر';

  @override
  String get reviewPlayerSection => 'اللاعب';

  @override
  String get reviewTrainingSection => 'جدول التدريب';

  @override
  String get reviewMedicalSection => 'المعلومات الطبية';

  @override
  String get reviewEmergencySection => 'جهة الطوارئ';

  @override
  String get duplicateWarningTitle => 'تحذير: تسجيل محتمل مكرر';

  @override
  String get duplicateWarningMessage =>
      'يبدو أن هذا اللاعب مسجّل مسبقاً. هل تريد المتابعة؟';

  @override
  String get duplicateProceed => 'متابعة الإرسال';

  @override
  String get duplicateCancel => 'إلغاء';

  @override
  String get successTitle => 'تم التسجيل بنجاح!';

  @override
  String get successSubtitle => 'لقد استلمنا طلبك';

  @override
  String get successReferenceLabel => 'رقم المرجع';

  @override
  String get copyButton => 'نسخ';

  @override
  String get copiedMessage => 'تم النسخ!';

  @override
  String get successInstructions =>
      'سيتواصل معك فريق الأكاديمية قريباً لتأكيد تسجيلك ومشاركة الخطوات التالية.';

  @override
  String get doneButton => 'تم';

  @override
  String get errorSubmissionFailed =>
      'فشل الإرسال. يرجى التحقق من الاتصال والمحاولة مجدداً.';

  @override
  String get errorNoConnection =>
      'لا يوجد اتصال بالإنترنت. يرجى الاتصال والمحاولة مجدداً.';

  @override
  String get errorGeneric => 'حدث خطأ. يرجى المحاولة مجدداً.';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationMobileFormat =>
      'أدخل رقم جوال صحيحاً (مثال: 01012345678)';

  @override
  String get validationEmailFormat => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get validationDobFuture => 'تاريخ الميلاد لا يمكن أن يكون في المستقبل';

  @override
  String get validationDobRequired => 'يرجى اختيار تاريخ الميلاد';

  @override
  String get validationEmergencyPhoneSameAsParent =>
      'يجب أن يختلف عن رقم ولي الأمر';

  @override
  String get validationMedicalDetailsRequired => 'يرجى توضيح الحالة الطبية';

  @override
  String get validationScheduleRequired => 'يرجى اختيار جدول التدريب';

  @override
  String get childName => 'اسم الطفل';

  @override
  String get childAge => 'عمر الطفل';

  @override
  String get swimmingLevel => 'مستوى السباحة';

  @override
  String get swimBeginner => 'مبتدئ';

  @override
  String get swimIntermediate => 'متوسط';

  @override
  String get swimAdvanced => 'متقدم';

  @override
  String get preferredBranch => 'الفرع المفضل';

  @override
  String get notesOptional => 'ملاحظات (اختياري)';

  @override
  String get stepChildInfo => 'معلومات الطفل';

  @override
  String get stepRegistrationDetails => 'تفاصيل التسجيل';

  @override
  String get successMessage => 'تم تقديم طلبك بنجاح.';

  @override
  String get validationAge => 'يرجى إدخال عمر صحيح (١-٩٩)';
}
