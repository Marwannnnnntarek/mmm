# Data Model: Sports For Life Academy MVP Registration App

**Date**: 2026-06-06
**Branch**: `001-registration-app-mvp`

All models are in-memory only. No local persistence. Cleared from device memory after successful
submission (constitution Principle III).

---

## Entities

### Branch

Fetched from AMS at the start of the Branch Selection screen.

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| id | String | Yes | AMS-assigned identifier; sent back in submission payload |
| name | String | Yes | Display name; shown in branch list and Review Screen |

---

### ParentInfo

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| fullName | String | Yes | Non-empty after trim |
| mobileNumber | String | Yes | Egyptian format: `^01[0-9]\d{8}$` (11 digits) |
| alternativeMobileNumber | String | Yes | Egyptian format; MAY equal mobileNumber |
| email | String? | No | Valid email format if provided; null if omitted |

---

### PlayerInfo

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| fullName | String | Yes | Non-empty after trim |
| dateOfBirth | DateTime | Yes | Must be in the past. Must fall within eligible age range once confirmed (TODO). |
| gender | Gender (enum) | Yes | `Gender.male` or `Gender.female` |
| schoolName | String? | No | No format constraint; null if omitted |

```dart
enum Gender { male, female }
```

---

### MedicalInfo

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| hasMedicalConditions | bool | Yes | Yes / No toggle |
| conditionDetails | String? | Conditional | Required (non-empty) when `hasMedicalConditions == true`; null otherwise |

---

### EmergencyContact

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| name | String | Yes | Non-empty after trim |
| phoneNumber | String | Yes | Egyptian format: `^01[0-9]\d{8}$`; MUST differ from `ParentInfo.mobileNumber` |

---

### RegistrationApplication (session object)

The root in-memory object that the Riverpod `RegistrationNotifier` holds. All sub-entities are
nested within this object. Never written to disk.

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| branch | Branch | Yes | Set on Branch Selection screen |
| parent | ParentInfo | Yes | Set after Parent Info step |
| player | PlayerInfo | Yes | Set after Player Info step |
| medicalInfo | MedicalInfo | Yes | Set after Medical Info step |
| emergencyContact | EmergencyContact | Yes | Set after Emergency Contact step |
| submissionLanguage | Language (enum) | Yes | Set on Welcome Screen; `Language.arabic` (default) or `Language.english` |
| status | RegistrationStatus (enum) | Yes | See state machine below |
| referenceNumber | String? | No | Populated on successful AMS response |
| submissionTimestamp | DateTime? | No | Populated on successful AMS response |

```dart
enum Language { arabic, english }

enum RegistrationStatus {
  draft,        // form is being filled
  submitting,   // POST in flight
  submitted,    // AMS returned 201 with reference number
  failed,       // timeout, connectivity error, or server error
}
```

---

## Validation Rules Summary

| Rule | Applied At |
|------|-----------|
| Required field non-empty (after trim) | Each wizard step's "Next" tap |
| Egyptian mobile format `^01[0-9]\d{8}$` | Parent Info "Next" tap; Emergency Contact "Next" tap |
| Date of birth not in future | Player Info "Next" tap |
| Date of birth within eligible age range (TBD) | Player Info "Next" tap (deferred) |
| Emergency contact phone ≠ parent primary mobile | Emergency Contact "Next" tap |
| Medical condition details non-empty if hasMedicalConditions | Medical Info "Next" tap |
| All sections complete before submission | Review Screen "Submit" tap (full re-validation) |

---

## State Machine: RegistrationApplication

```
           [App launch / language selected]
                        │
                        ▼
                    draft ◄──────────────── (section edited from Review Screen)
                        │
              [Submit tapped on Review Screen]
              [Duplicate check passed or skipped]
                        │
                        ▼
                   submitting
                  /          \
         [AMS 201]        [Error / 30s timeout]
              │                    │
              ▼                    ▼
          submitted            failed
              │                    │
    [notifier.reset()]      [Retry tapped]
              │                    │
      [State cleared]         submitting (loop)
```

**Clearing state**: `notifier.reset()` sets all fields to null and status to `draft`. Called
from the Success Screen after the reference number is displayed. This satisfies FR-020 (no data
retained after successful submission).

---

## Relationships

```
RegistrationApplication
  ├── branch: Branch (1:1)
  ├── parent: ParentInfo (1:1)
  ├── player: PlayerInfo (1:1)
  ├── medicalInfo: MedicalInfo (1:1)
  └── emergencyContact: EmergencyContact (1:1)
```

Cross-entity constraints:
- `emergencyContact.phoneNumber` ≠ `parent.mobileNumber` (validated at Emergency Contact step)
- `branch.id` is sent to AMS with the submission payload and duplicate-check query

---

## AMS Submission Payload Mapping

The `RegistrationApplication` maps to the AMS POST body as follows (see `contracts/ams-api.md`
for full contract):

| App field | AMS JSON field |
|-----------|----------------|
| branch.id | `branchId` |
| submissionLanguage | `language` (`"ar"` / `"en"`) |
| parent.fullName | `parent.fullName` |
| parent.mobileNumber | `parent.mobileNumber` |
| parent.alternativeMobileNumber | `parent.alternativeMobileNumber` |
| parent.email | `parent.email` (omitted if null) |
| player.fullName | `player.fullName` |
| player.dateOfBirth | `player.dateOfBirth` (ISO 8601: `YYYY-MM-DD`) |
| player.gender | `player.gender` (`"male"` / `"female"`) |
| player.schoolName | `player.schoolName` (omitted if null) |
| medicalInfo.hasMedicalConditions | `medicalInfo.hasMedicalConditions` |
| medicalInfo.conditionDetails | `medicalInfo.conditionDetails` (omitted if null) |
| emergencyContact.name | `emergencyContact.name` |
| emergencyContact.phoneNumber | `emergencyContact.phoneNumber` |
