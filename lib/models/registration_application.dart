import 'package:intl/intl.dart';

import 'emergency_contact.dart';
import 'medical_info.dart';
import 'parent_info.dart';
import 'player_info.dart';
import 'training_schedule.dart';

enum Language { arabic, english }

enum RegistrationStatus { draft, submitting, submitted, failed }

class RegistrationApplication {
  const RegistrationApplication({
    required this.parent,
    required this.player,
    required this.medicalInfo,
    required this.emergencyContact,
    required this.submissionLanguage,
    this.trainingSchedule,
    this.status = RegistrationStatus.draft,
    this.referenceNumber,
    this.submissionTimestamp,
  });

  final ParentInfo parent;
  final PlayerInfo player;
  final MedicalInfo medicalInfo;
  final EmergencyContact emergencyContact;
  final Language submissionLanguage;
  final TrainingSchedule? trainingSchedule;
  final RegistrationStatus status;
  final String? referenceNumber;
  final DateTime? submissionTimestamp;

  RegistrationApplication copyWith({
    ParentInfo? parent,
    PlayerInfo? player,
    MedicalInfo? medicalInfo,
    EmergencyContact? emergencyContact,
    Language? submissionLanguage,
    TrainingSchedule? trainingSchedule,
    RegistrationStatus? status,
    String? referenceNumber,
    DateTime? submissionTimestamp,
  }) =>
      RegistrationApplication(
        parent: parent ?? this.parent,
        player: player ?? this.player,
        medicalInfo: medicalInfo ?? this.medicalInfo,
        emergencyContact: emergencyContact ?? this.emergencyContact,
        submissionLanguage: submissionLanguage ?? this.submissionLanguage,
        trainingSchedule: trainingSchedule ?? this.trainingSchedule,
        status: status ?? this.status,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        submissionTimestamp: submissionTimestamp ?? this.submissionTimestamp,
      );

  Map<String, dynamic> toSubmissionJson() {
    final dobStr = DateFormat('yyyy-MM-dd').format(player.dateOfBirth);
    return {
      'branchId': 'main',
      'language': submissionLanguage == Language.arabic ? 'ar' : 'en',
      'trainingSchedule': trainingSchedule?.toApiValue() ?? '',
      'parent': {
        'fullName': parent.fullName,
        'mobileNumber': parent.mobileNumber,
        'alternativeMobileNumber': parent.alternativeMobileNumber,
        if (parent.email != null && parent.email!.isNotEmpty)
          'email': parent.email,
      },
      'player': {
        'fullName': player.fullName,
        'dateOfBirth': dobStr,
        'gender': player.gender == Gender.male ? 'male' : 'female',
        if (player.schoolName != null && player.schoolName!.isNotEmpty)
          'schoolName': player.schoolName,
      },
      'medicalInfo': {
        'hasMedicalConditions': medicalInfo.hasMedicalConditions,
        if (medicalInfo.conditionDetails != null &&
            medicalInfo.conditionDetails!.isNotEmpty)
          'conditionDetails': medicalInfo.conditionDetails,
      },
      'emergencyContact': {
        'name': emergencyContact.name,
        'phoneNumber': emergencyContact.phoneNumber,
      },
    };
  }
}
