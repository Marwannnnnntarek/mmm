# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter run              # Run on connected device/emulator
flutter test             # Run all tests
flutter test test/path/to/test.dart  # Run a single test
flutter analyze          # Lint (uses flutter_lints)
flutter build apk --release      # Android release APK
flutter build appbundle --release # Android App Bundle
flutter build ios --release      # iOS release
```

## Architecture

This is a Flutter (Dart) mobile app targeting Android and iOS. The project is in early development — `lib/main.dart` still contains the default counter template. The full specification lives in [plan.md](plan.md).

### Screen Flow

```
Welcome Screen (language select, Arabic default)
  → Connectivity Check (blocks on no internet)
    → Branch Selection (fetched from AMS)
      → Registration Form (multi-section, single flow)
        → Review Screen (editable, shows all data)
          → Duplicate Check (soft warning via AMS API)
            → Submission (POST to AMS)
              → Success Screen (reference number, copyable)
```

Language can only be switched on the Welcome Screen — not mid-form — to avoid data loss.

### Registration Form Sections

1. **Parent** — Full name, mobile (Egyptian format `01X-XXXX-XXXX`), alt mobile (required), email (optional)
2. **Player** — Full name, DOB (validated: not future, within eligible age range TBC with management), gender, school (optional)
3. **Medical** — Yes/No toggle; detail field appears only when Yes
4. **Emergency Contact** — Name + phone; phone must differ from parent mobile

### AMS Integration

Integration method is **not yet decided** — REST API (preferred), direct DB write, or message queue. All communication must use HTTPS. On submission the app:
- POSTs all form data + selected branch + language to AMS
- Receives a system-generated reference number back
- Sets application status to "Pending"

Duplicate detection is a **soft warning** before submission (player name + DOB match against selected branch). Final deduplication authority is the Branch Manager in AMS.

### Localization

Arabic and English are both required. Arabic is RTL, English is LTR. All labels, validation messages, and success/error strings must be translated. Player/parent names are entered as-is. The `intl` package (not yet added) is the standard Flutter approach.

### Key Constraints

- **No local data retention** after successful submission (security requirement).
- Connectivity must be checked at launch and again on "Start Registration" tap.
- Submission must preserve entered data on failure so the parent can retry.
- Out of scope for MVP: document/photo uploads, parent login, offline mode, payments, push notifications, multi-child sessions.

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->
