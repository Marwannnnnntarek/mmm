# Quickstart: Sports For Life Academy MVP Registration App

**Date**: 2026-06-06
**Branch**: `001-registration-app-mvp`

---

## Prerequisites

- Flutter SDK 3.x (`flutter --version` to verify)
- Android Studio (for Android emulator) or Xcode (for iOS simulator)
- AMS API key and base URL (from AMS owner)
- A connected device or emulator

---

## Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate localization files (run after any .arb changes)
flutter gen-l10n

# 3. Run on a connected device/emulator with required config
flutter run \
  --dart-define=AMS_API_KEY=<your-api-key> \
  --dart-define=AMS_BASE_URL=https://ams.sportsforlifeacademy.com/api
```

For development against a local AMS mock server:

```bash
flutter run \
  --dart-define=AMS_API_KEY=dev-key \
  --dart-define=AMS_BASE_URL=http://localhost:8080/api
```

---

## Running Tests

```bash
# All unit and widget tests
flutter test

# A single test file
flutter test test/unit/models/player_info_test.dart

# Linting (must pass before merge)
flutter analyze

# Integration tests (requires connected device/emulator)
flutter test integration_test/registration_flow_test.dart \
  --dart-define=AMS_API_KEY=dev-key \
  --dart-define=AMS_BASE_URL=http://localhost:8080/api
```

---

## End-to-End Verification Checklist

Run through each path below manually (or via integration test) to confirm the build is working.

### Arabic Journey (P1 — Must Pass)

1. Launch app → Welcome Screen appears in Arabic within 3 seconds.
2. Language toggle shows Arabic selected by default.
3. Tap "Start Registration" with no internet → connectivity error shown; form does not open.
4. Restore internet; tap "Start Registration" → Branch Selection screen opens.
5. Branch list loads from AMS; select a branch → Parent Info screen opens (step 1 of wizard).
6. Complete Parent Info with valid Egyptian mobile numbers → tap "Next" → Player Info.
7. Complete Player Info (valid DOB in past) → tap "Next" → Medical Info.
8. Toggle Medical Conditions to "Yes" → Details field appears; fill it → tap "Next".
9. Complete Emergency Contact (phone different from parent mobile) → tap "Next" → Review Screen.
10. Review Screen shows all entered data grouped by section and selected branch.
11. Tap a section on Review Screen → wizard jumps back to that step; edit; return to Review.
12. Tap "Submit" → duplicate check runs → (if match) soft warning dialog shown → tap "Proceed".
13. Success Screen appears with a copyable reference number.
14. Copy reference number to clipboard → confirm it copies correctly.
15. Verify application appears in AMS with status "Pending" under the selected branch.

### English Journey (P2 — Must Pass)

1. Launch app; tap "English" toggle on Welcome Screen → all text switches to English (LTR).
2. Complete full registration flow in English.
3. Verify all labels, validation messages, and success text are in English throughout.
4. Verify layout is LTR on all screens.

### Connectivity Error (P2 — Must Pass)

1. Disable device internet; launch app → error message shown at launch.
2. Tap "Start Registration" (if somehow reachable) → form blocked.
3. Re-enable internet → retry succeeds.

### Duplicate Warning (P3)

1. Register a player; note their name and DOB.
2. Begin a second registration with the same name, DOB, and branch.
3. On Review Screen, tap Submit → duplicate warning dialog shown.
4. Tap "Cancel" → form returns with all data intact.
5. Tap Submit again → tap "Proceed" → submission succeeds.

### Submission Failure Recovery (P3)

1. Complete form; on Review Screen disconnect internet.
2. Tap Submit → after 30 seconds, retry screen shown with all data preserved.
3. Re-enable internet; tap Retry → submission succeeds; Success Screen shown.

### Branch List Load Failure

1. Point app at invalid AMS URL; reach Branch Selection screen.
2. Inline error message and Retry button shown; branch list empty.
3. Fix URL; tap Retry → list loads; can proceed.

### Validation Rules

- Enter a future date as DOB → error shown; cannot advance.
- Enter emergency contact phone same as parent mobile → error shown; cannot advance.
- Enter invalid Egyptian mobile format → error shown; cannot advance.
- Leave required field blank, tap Next → inline error shown adjacent to field.

---

## Build for Release

```bash
# Android APK
flutter build apk --release \
  --dart-define=AMS_API_KEY=<prod-key> \
  --dart-define=AMS_BASE_URL=<prod-url>

# Android App Bundle
flutter build appbundle --release \
  --dart-define=AMS_API_KEY=<prod-key> \
  --dart-define=AMS_BASE_URL=<prod-url>

# iOS
flutter build ios --release \
  --dart-define=AMS_API_KEY=<prod-key> \
  --dart-define=AMS_BASE_URL=<prod-url>
```

**Note**: Never commit the production API key to source control. Supply it via CI/CD environment
variables at build time.
