---

description: "Task list for Sports For Life Academy MVP Registration App"
---

# Tasks: Sports For Life Academy MVP Registration App

**Input**: Design documents from `specs/001-registration-app-mvp/`

**Prerequisites**: plan.md ✅ | spec.md ✅ | research.md ✅ | data-model.md ✅ | contracts/ams-api.md ✅

**Tests**: Unit tests included for the four constitution-mandated validation rules.
Widget/integration tests included in Polish phase for end-to-end verification.

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US5)

---

## Phase 1: Setup

**Purpose**: Initialize the Flutter project with required dependencies and directory structure.

- [x] T001 Add dependencies to pubspec.yaml: `dio`, `flutter_riverpod`, `riverpod_annotation`, `connectivity_plus`, `intl`, `go_router`; add `flutter_lints` to dev_dependencies; enable `flutter: generate: true` for l10n
- [x] T002 Create `l10n.yaml` at repo root (arb-dir: lib/l10n, template-arb-file: app_en.arb, output-localization-file: app_localizations.dart); create empty `lib/l10n/app_ar.arb` and `lib/l10n/app_en.arb` with `@@locale` keys only
- [x] T003 [P] Configure `analysis_options.yaml` to include `package:flutter_lints/flutter.yaml`
- [x] T004 Create all empty placeholder files establishing the directory structure: `lib/models/`, `lib/services/`, `lib/providers/`, `lib/screens/welcome/`, `lib/screens/branch_selection/`, `lib/screens/registration/`, `lib/screens/review/`, `lib/screens/success/`, `lib/widgets/`, `test/unit/models/`, `test/widget/screens/`, `integration_test/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core models, services, state, and shell that MUST be complete before any user story screen can be built.

**⚠️ CRITICAL**: No user story screen work can begin until this phase is complete.

### Models

- [x] T005 [P] Create `Branch` model (fields: `id`, `name`; `fromJson` factory) in `lib/models/branch.dart`
- [x] T006 [P] Create `ParentInfo` model (fields: `fullName`, `mobileNumber`, `alternativeMobileNumber`, `email?`; static `isValidEgyptianMobile(String)` using regex `^01[0-9]\d{8}$`; `validate()` returning list of error keys) in `lib/models/parent_info.dart`
- [x] T007 [P] Create `PlayerInfo` model (fields: `fullName`, `dateOfBirth`, `gender` enum `{male, female}`, `schoolName?`; static `isDobValid(DateTime)` rejecting future dates; `validate()` returning list of error keys) in `lib/models/player_info.dart`
- [x] T008 [P] Create `MedicalInfo` model (fields: `hasMedicalConditions`, `conditionDetails?`; `validate()` returning error key when `hasMedicalConditions==true` and `conditionDetails` is null/empty) in `lib/models/medical_info.dart`
- [x] T009 [P] Create `EmergencyContact` model (fields: `name`, `phoneNumber`; `validateUniqueness(String parentMobile)` returning error key when `phoneNumber == parentMobile`; `validate()` for required fields + Egyptian format) in `lib/models/emergency_contact.dart`
- [x] T010 Create `RegistrationApplication` model with `Language` enum `{arabic, english}`, `RegistrationStatus` enum `{draft, submitting, submitted, failed}`, all sub-entity fields, and `toSubmissionJson()` mapping to AMS POST body per `contracts/ams-api.md` in `lib/models/registration_application.dart`

### Constitution-Mandated Validation Tests

> Per constitution Development Quality Standards: validation rules MUST be covered by unit tests.

- [x] T011 [P] Write unit tests for `ParentInfo.isValidEgyptianMobile()`: valid prefixes (010/011/012/015), invalid prefix (013), too short, too long, non-digits; assert validation messages in `test/unit/models/parent_info_test.dart`
- [x] T012 [P] Write unit tests for `PlayerInfo.isDobValid()`: today's date fails, past date passes, far-future date fails; assert correct error key returned in `test/unit/models/player_info_test.dart`
- [x] T013 [P] Write unit tests for `EmergencyContact.validateUniqueness()`: same number as parent mobile returns error key; different number returns null; empty phone returns required error in `test/unit/models/emergency_contact_test.dart`

### Services

- [x] T014 [P] Create `ConnectivityService` wrapping `connectivity_plus` with a single async `isConnected() → Future<bool>` method in `lib/services/connectivity_service.dart`
- [x] T015 Create `AmsService` with: `Dio` instance configured with `connectTimeout: 30s`, `receiveTimeout: 30s`, `InterceptorsWrapper` that injects `X-API-Key` header from `String.fromEnvironment('AMS_API_KEY')`; methods: `fetchBranches() → Future<List<Branch>>`, `checkDuplicate({playerFullName, dateOfBirth, branchId}) → Future<bool>`, `submitRegistration(RegistrationApplication) → Future<String>` (returns referenceNumber); all methods throw typed errors on 4xx/5xx/timeout in `lib/services/ams_service.dart`

### State

- [x] T016 Create `RegistrationNotifier extends StateNotifier<RegistrationApplication?>` with methods: `setBranch(Branch)`, `setLanguage(Language)`, `setParent(ParentInfo)`, `setPlayer(PlayerInfo)`, `setMedical(MedicalInfo)`, `setEmergencyContact(EmergencyContact)`, `setStatus(RegistrationStatus)`, `setReferenceNumber(String)`, `reset()` (clears state to null) in `lib/providers/registration_provider.dart`; expose via `registrationProvider` and `registrationNotifierProvider`

### Shared Widgets

- [x] T017 [P] Create `ValidatedTextField` stateless widget: wraps `TextFormField`, accepts `label`, `validator`, `onChanged`, `keyboardType`, `isRequired` params; shows `*` indicator for required fields in `lib/widgets/validated_text_field.dart`
- [x] T018 [P] Create `ConnectivityErrorWidget` stateless widget: shows localized error message and a "Retry" `ElevatedButton`; accepts `onRetry` callback and `message` string in `lib/widgets/connectivity_error_widget.dart`
- [x] T019 [P] Create `LoadingOverlay` widget: semi-transparent barrier with centered `CircularProgressIndicator`; accepts `isLoading` bool to show/hide in `lib/widgets/loading_overlay.dart`

### App Shell

- [x] T020 Create `lib/app.dart`: `RegistrationApp` widget containing `ProviderScope`, `MaterialApp.router` with `localizationsDelegates` (AppLocalizations + GlobalMaterialLocalizations + GlobalCupertinoLocalizations + GlobalWidgetsLocalizations), `supportedLocales` (ar, en), initial locale `const Locale('ar')`; `GoRouter` with named routes for Welcome, BranchSelection, RegistrationWizard, Review, and Success screens (screens stubbed with `Scaffold(body: Placeholder())`)
- [x] T021 Update `lib/main.dart`: read `AMS_BASE_URL` and `AMS_API_KEY` via `String.fromEnvironment()`; call `runApp(const RegistrationApp())`; remove default counter template

**Checkpoint**: Run `flutter analyze` and `flutter test test/unit/` — zero errors required before user story work begins.

---

## Phase 3: User Story 1 — Arabic Registration Journey (Priority: P1) 🎯 MVP

**Goal**: A parent can complete the full registration journey end-to-end in Arabic with RTL layout and receive a reference number.

**Independent Test**: Launch app → defaults to Arabic → select branch → complete 4 wizard steps → Review → Submit → Success Screen shows reference number. Verify AMS has a Pending record.

### Translations

- [x] T022 [US1] Populate `lib/l10n/app_ar.arb` with all Arabic strings: welcome screen (title, subtitle, startButton), branch selection (title, loadError, retryButton), all 4 form section labels and field hints, all inline validation error messages, review screen labels, success screen (title, referenceLabel, copyButton, instructions), duplicate warning dialog (title, message, proceedButton, cancelButton), generic error and retry messages

### Screens

- [x] T023 [US1] Implement `WelcomeScreen` in `lib/screens/welcome/welcome_screen.dart`: academy logo (asset placeholder), academy name, welcome message, `SegmentedButton` for language selection (Arabic selected by default), "Start Registration" `ElevatedButton`; reads language from `registrationProvider`; on button tap calls `registrationNotifier.setLanguage()` and navigates to BranchSelection (connectivity check wired in US3)
- [x] T024 [US1] Implement `BranchSelectionScreen` in `lib/screens/branch_selection/branch_selection_screen.dart`: calls `AmsService.fetchBranches()` in `initState`; shows `CircularProgressIndicator` while loading; shows scrollable `ListView` of branch names on success; shows `ConnectivityErrorWidget` with retry on failure; tapping a branch calls `registrationNotifier.setBranch()` and navigates to RegistrationWizard
- [x] T025 [US1] Implement `RegistrationWizard` in `lib/screens/registration/registration_wizard.dart`: `PageView` with `physics: NeverScrollableScrollPhysics()`; 4 pages: ParentInfoScreen, PlayerInfoScreen, MedicalInfoScreen, EmergencyContactScreen; exposes `next()` and `back()` via `PageController`; Back on page 0 pops to BranchSelection; shows current step indicator (e.g. "1 / 4")
- [x] T026 [P] [US1] Implement `ParentInfoScreen` in `lib/screens/registration/parent_info_screen.dart`: `ValidatedTextField` for fullName, mobileNumber, alternativeMobileNumber (required), email (optional); on Next tap validates via `ParentInfo.validate()` and Egyptian mobile rule; shows inline errors adjacent to fields; on valid input calls `registrationNotifier.setParent()` and advances PageView
- [x] T027 [P] [US1] Implement `PlayerInfoScreen` in `lib/screens/registration/player_info_screen.dart`: `ValidatedTextField` for fullName; `showDatePicker` for dateOfBirth (max: today); `RadioListTile` for gender (male/female); optional `ValidatedTextField` for schoolName; on Next validates via `PlayerInfo.validate()`; calls `registrationNotifier.setPlayer()` and advances PageView
- [x] T028 [P] [US1] Implement `MedicalInfoScreen` in `lib/screens/registration/medical_info_screen.dart`: `SwitchListTile` for `hasMedicalConditions`; conditional `ValidatedTextField` for `conditionDetails` (visible and required only when switch is on); on Next validates via `MedicalInfo.validate()`; calls `registrationNotifier.setMedical()` and advances PageView
- [x] T029 [P] [US1] Implement `EmergencyContactScreen` in `lib/screens/registration/emergency_contact_screen.dart`: `ValidatedTextField` for name and phoneNumber; on Next validates: Egyptian mobile format + phone ≠ parent mobile (read from provider); shows inline error if phone matches parent; calls `registrationNotifier.setEmergencyContact()` and navigates to ReviewScreen
- [x] T030 [US1] Implement `ReviewScreen` in `lib/screens/review/review_screen.dart`: reads `RegistrationApplication` from provider; displays all sections grouped (Branch, Parent, Player, Medical, Emergency Contact); each section header has an Edit `IconButton` that navigates back to the relevant wizard step with a return-to-review flag; "Submit" `ElevatedButton` calls `registrationNotifier.setStatus(submitting)` and invokes `AmsService.submitRegistration()` via provider; shows `LoadingOverlay` while submitting; on success navigates to SuccessScreen (duplicate check and failure handling added in US4/US5)
- [x] T031 [US1] Implement `SuccessScreen` in `lib/screens/success/success_screen.dart`: displays success message, reference number in a styled container, `IconButton` for copy-to-clipboard (`Clipboard.setData`), thank-you message, "Done" button; on widget mount calls `registrationNotifier.reset()` to clear all form data from memory
- [x] T032 [US1] Complete `GoRouter` navigation in `lib/app.dart`: register all routes with correct path params; wire Back-from-wizard-step-0 to BranchSelection; wire ReviewScreen Edit taps to specific wizard pages with a `returnToReview` query param; test all transitions compile without error

**Checkpoint**: Full Arabic end-to-end journey works from launch to Success Screen. `flutter analyze` passes.

---

## Phase 4: User Story 2 — English Registration Journey (Priority: P2)

**Goal**: Tapping "English" on the Welcome Screen switches the entire app to English with LTR layout.

**Independent Test**: Select English on Welcome Screen; complete the full journey; verify every screen shows English text and LTR layout with no Arabic strings visible.

- [x] T033 [P] [US2] Populate `lib/l10n/app_en.arb` with English translations for all keys defined in `app_ar.arb` in `lib/l10n/app_en.arb`
- [x] T034 [US2] Update language toggle in `WelcomeScreen` (`lib/screens/welcome/welcome_screen.dart`) to update a `localeProvider` (or `registrationNotifier.setLanguage()`); the app must observe this change and rebuild with the new locale
- [x] T035 [US2] Update `lib/app.dart`: watch `localeProvider` (or `registrationProvider.language`) and pass the corresponding `Locale` to `MaterialApp.router`'s `locale` parameter so RTL (Arabic) and LTR (English) directionality propagate to all child widgets

**Checkpoint**: English journey completes without any Arabic strings or RTL layout.

---

## Phase 5: User Story 3 — Connectivity-Blocked Start (Priority: P2)

**Goal**: App blocks progress and shows a clear message when internet is unavailable at launch or at "Start Registration" tap.

**Independent Test**: Disable internet → launch app → see connectivity error. Enable internet → restart → see Welcome Screen normally.

- [x] T036 [US3] Add app-launch connectivity check in `lib/app.dart`: in the `GoRouter` redirect or initial route builder, call `ConnectivityService.isConnected()`; if false, render `ConnectivityErrorWidget` as a full-screen blocking route with a Retry button that re-checks and proceeds to WelcomeScreen on success
- [x] T037 [US3] Add "Start Registration" tap connectivity check in `WelcomeScreen` (`lib/screens/welcome/welcome_screen.dart`): before navigating to BranchSelection, call `ConnectivityService.isConnected()`; if false, show inline `ConnectivityErrorWidget` beneath the Start button in the selected language; hide the error when the parent taps Retry and connectivity is restored

**Checkpoint**: Start Registration is blocked with a clear message when offline; proceeds normally when online.

---

## Phase 6: User Story 4 — Duplicate Player Warning (Priority: P3)

**Goal**: Before submission, if a matching player exists in AMS for the same branch, a soft warning dialog is shown. The parent chooses to proceed or cancel.

**Independent Test**: Register a player; attempt to register the same name + DOB + branch again; verify warning dialog; test both Proceed and Cancel paths.

- [x] T038 [US4] Add duplicate check to ReviewScreen Submit flow in `lib/screens/review/review_screen.dart`: before calling `submitRegistration()`, call `AmsService.checkDuplicate()`; if `isDuplicate == true`, show `AlertDialog` with warning message, Proceed button (submits), and Cancel button (dismisses dialog and returns to Review)
- [x] T039 [US4] Handle duplicate check errors silently in ReviewScreen (`lib/screens/review/review_screen.dart`): wrap `checkDuplicate()` call in try/catch; on any exception, skip the warning and proceed directly to `submitRegistration()`

**Checkpoint**: Duplicate warning appears for matching players; Cancel preserves form data; Proceed submits successfully.

---

## Phase 7: User Story 5 — Submission Failure Recovery (Priority: P3)

**Goal**: Submission failures (server error, connectivity loss, 30-second timeout) preserve all form data and offer a retry action.

**Independent Test**: Simulate server error at submission; verify all form fields still populated; tap Retry; submission succeeds; Success Screen shown.

- [x] T040 [US5] Implement submission error state in ReviewScreen (`lib/screens/review/review_screen.dart`): catch `DioException` from `submitRegistration()`; call `registrationNotifier.setStatus(failed)`; display error banner with localized message and Retry `ElevatedButton`; all form data remains intact in provider state
- [x] T041 [US5] Implement Retry action in ReviewScreen (`lib/screens/review/review_screen.dart`): Retry button tap sets status back to `submitting`, clears error banner, re-runs duplicate check (US4) and `submitRegistration()` without touching form data in provider
- [ ] T042 [US5] Verify 30-second timeout handling in ReviewScreen (`lib/screens/review/review_screen.dart`): confirm `DioExceptionType.connectionTimeout` and `receiveTimeout` are caught by the same handler as server errors; manual test: use a mock or network throttle to trigger timeout and verify error banner appears with form data intact

**Checkpoint**: All submission failure modes show a retry option. Form data survives all retry attempts.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Quality gates, manual verification, and final integration test.

- [x] T043 Run `flutter analyze` across `lib/` and `test/`; resolve all warnings and errors; confirm zero issues
- [ ] T044 [P] Manual verification — Arabic (RTL): launch app in Arabic; check every screen (Welcome, BranchSelection, all 4 wizard steps, Review, Success, error states) for correct RTL text direction, no LTR layout artifacts, and all strings translated
- [ ] T045 [P] Manual verification — English (LTR): repeat T044 verification in English; check every screen for LTR layout, no Arabic strings, correct English copy
- [ ] T046 Create `integration_test/registration_flow_test.dart`: write an integration test that drives the full Arabic journey from Welcome Screen through to Success Screen using `IntegrationTestWidgetsFlutterBinding`; use a mock AMS server or stub `AmsService` for CI; assert reference number is displayed and `registrationProvider` state is null after reset

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Requires Setup; BLOCKS all user story phases
- **US1 (Phase 3)**: Requires Foundational — start immediately after
- **US2 (Phase 4)**: Requires US1 screens to exist (modifies WelcomeScreen and app.dart)
- **US3 (Phase 5)**: Requires US1 Welcome Screen to exist (adds error state to it)
- **US4 (Phase 6)**: Requires US1 ReviewScreen to exist (adds dialog to Submit flow)
- **US5 (Phase 7)**: Requires US1 ReviewScreen to exist (adds error handling to Submit flow)
- **Polish (Phase 8)**: Requires all user story phases to be complete

### Within User Story 1

- T022 (translations) can run in parallel with T023–T029 (screens)
- T026–T029 (wizard step screens) can all run in parallel
- T025 (wizard PageView) before T030 (ReviewScreen needs wizard context)
- T030 (ReviewScreen) before T031 (SuccessScreen needs review wiring)
- T032 (router) after all screens exist

### Parallel Opportunities Within US1

```
# Launch all wizard step screens together:
T026  ParentInfoScreen     lib/screens/registration/parent_info_screen.dart
T027  PlayerInfoScreen     lib/screens/registration/player_info_screen.dart
T028  MedicalInfoScreen    lib/screens/registration/medical_info_screen.dart
T029  EmergencyContactScreen lib/screens/registration/emergency_contact_screen.dart
```

### User Story Independence

- **US1 (P1)**: Core journey — all other stories depend on US1 screens existing
- **US2 (P2)**: English translation + locale switch. Independent of US3–US5.
- **US3 (P2)**: Connectivity error states. Independent of US2, US4, US5.
- **US4 (P3)**: Duplicate warning in Submit flow. Independent of US2, US3, US5.
- **US5 (P3)**: Submission retry. Independent of US2, US3, US4.
- US2 and US3 can be worked in parallel after US1 is complete.
- US4 and US5 can be worked in parallel after US1 is complete.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001–T004)
2. Complete Phase 2: Foundational — CRITICAL, blocks everything (T005–T021)
3. Complete Phase 3: US1 — full Arabic journey (T022–T032)
4. **STOP and VALIDATE**: Run `flutter test test/unit/`, `flutter analyze`, manual Arabic journey end-to-end
5. Demo to stakeholders if ready

### Incremental Delivery

1. Setup + Foundational → project compilable, validation tests pass
2. US1 → Arabic journey works end-to-end (MVP!)
3. US2 + US3 in parallel → English journey + offline protection
4. US4 + US5 in parallel → duplicate warning + retry resilience
5. Polish → production-ready

### Parallel Team Strategy

With multiple developers after Foundational phase:
- Dev A: US2 (English translations + locale switch)
- Dev B: US3 (connectivity error states)
- Dev C: US4 + US5 (Review Screen submit flow — these share the same file so sequence US4 then US5)

---

## Notes

- `[P]` tasks modify different files and have no incomplete dependencies — safe to run in parallel
- `[Story]` label maps each task to its user story for traceability
- All 4 constitution-mandated validation unit tests are in Phase 2 (T011–T013) and must pass before story work begins
- `flutter analyze` must pass at each phase checkpoint before advancing
- Commit after each task or logical group; branch is `001-registration-app-mvp`
- AMS_API_KEY and AMS_BASE_URL must be supplied via `--dart-define` at runtime — never hardcode
- Age range validation (FR-011 partial) deferred until TODO(ELIGIBLE_AGE_RANGE) is resolved; DOB future-date guard is in T007
