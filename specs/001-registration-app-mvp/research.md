# Research: Sports For Life Academy MVP Registration App

**Date**: 2026-06-06
**Branch**: `001-registration-app-mvp`

All NEEDS CLARIFICATION items from Technical Context are resolved below.

---

## 1. Flutter Localization & RTL/LTR Support

**Decision**: `flutter_localizations` (built-in) + `intl` package with `.arb` files.

**Rationale**: This is Flutter's official localization mechanism. ARB (Application Resource Bundle)
files are structured JSON files; the `intl_translation` toolchain generates type-safe Dart
accessors. `MaterialApp` automatically applies RTL directionality when the locale is `ar`. No
third-party localization library is needed.

**How it works**:
- `app_ar.arb` and `app_en.arb` hold all translatable strings keyed identically.
- `flutter gen-l10n` generates `AppLocalizations` class.
- `Directionality.of(context)` returns RTL for Arabic; all standard Material widgets respond
  automatically.
- Language is set by updating `Locale` in the app's top-level `MaterialApp` state.

**Alternatives considered**:
- `easy_localization` — popular but adds a dependency and complexity not needed when Flutter's
  built-in tooling is sufficient.
- `flutter_i18n` — older, less maintained.

---

## 2. Step-by-Step Wizard (Multi-Step Form)

**Decision**: `PageView` with `PageController`, non-swipeable, programmatic navigation only.

**Rationale**: The wizard must show one form section per screen with explicit Back/Next controls.
`PageView` (with `physics: NeverScrollableScrollPhysics()`) gives each section a full screen,
avoids the visual line-item style of Flutter's `Stepper` widget, and allows the registration
wizard state to live in a parent Riverpod notifier without prop drilling. Tapping "Back" on the
first section should return to Branch Selection (via router), not within the PageView.

**Wizard screen order**: Parent Info (page 0) → Player Info (page 1) → Medical Info (page 2) →
Emergency Contact (page 3) → Review Screen (separate route, not a PageView page).

**Validation trigger**: Each "Next" tap validates only the current section's fields. The Review
Screen validates the full form before showing the duplicate-check and Submit flow.

**Alternatives considered**:
- Flutter `Stepper` widget — vertical indicator; not full-screen per step; inappropriate for
  mobile form sections with multiple fields.
- Navigator push per section — creates back-stack routing; form state must be passed through
  routes, making data preservation on failure more complex.
- Single scrollable form — rejected during `/speckit-clarify` (Q2).

---

## 3. Connectivity Checking

**Decision**: `connectivity_plus` package for point-in-time network checks.

**Rationale**: `connectivity_plus` is the Flutter team's recommended plugin for connectivity
status. Two point-in-time checks align with the spec: (1) at app launch (checked in `initState`
of the Welcome Screen or app root), (2) when the parent taps "Start Registration".

**Important caveat**: `connectivity_plus` reports network type availability (WiFi/mobile data
present), not actual internet reachability. A device can report "connected" while having no
actual internet access (e.g., captive portal, poor signal). For MVP this is acceptable. Post-MVP,
replace or supplement with a lightweight HTTPS HEAD request to the AMS health endpoint.

**Connectivity is NOT checked mid-form** (per spec FR-002 clarification). If connectivity is lost
mid-form, the failure surfaces at submission via the 30-second timeout and retry flow.

**Alternatives considered**:
- `internet_connection_checker` — performs an actual DNS lookup or HTTP ping; more accurate but
  adds latency to the "Start Registration" tap and introduces a network dependency just to check
  connectivity.
- Stream-based continuous listening — rejected; the spec gates are point-in-time, and continuous
  checking would add complexity without user-visible benefit.

---

## 4. HTTP Client, Timeout, and Retry

**Decision**: `dio` HTTP client with a 30-second `receiveTimeout` and `connectTimeout`. API key
injected via a `dio` `Interceptor`. Retry is manual (user taps Retry button) — not automatic.

**Rationale**: `dio` provides `InterceptorsWrapper` for clean cross-cutting concerns (API key
header on every request). Both `connectTimeout` and `receiveTimeout` are set to 30 seconds per
spec SC-001/FR-018. Manual retry (not automatic) is correct for POST submission to avoid
accidental double-submission.

**Configuration**:
```dart
final dio = Dio(BaseOptions(
  baseUrl: const String.fromEnvironment('AMS_BASE_URL'),
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
));
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    options.headers['X-API-Key'] =
        const String.fromEnvironment('AMS_API_KEY');
    handler.next(options);
  },
));
```

**Error handling strategy**:
- `DioException.type == DioExceptionType.connectionTimeout` or `receiveTimeout` → treat as
  failure, show retry screen with data preserved.
- HTTP 4xx → parse error body; surface user-friendly message.
- HTTP 5xx → treat as server error; show retry screen.
- HTTP 401 → API key issue; show generic error (do not expose key details to user).

**Alternatives considered**:
- `http` (dart:http) — no interceptor support; API key must be added manually per call; less
  expressive error handling.
- Automatic retry with exponential backoff — rejected for POST submission due to double-submission
  risk. Acceptable for GET (branch list, duplicate check) but not implemented for MVP simplicity.

---

## 5. State Management (Form Data Preservation)

**Decision**: `riverpod` (`StateNotifier` + `StateNotifierProvider`) for all form state.

**Rationale**: Form data must survive across wizard screens, survive submission failures (spec
FR-018), and be cleared atomically after success (spec FR-020). A single `RegistrationNotifier`
holds the in-progress `RegistrationApplication` model. Riverpod's provider is scoped to the app
lifecycle, not to a widget subtree, so the state persists across screen transitions and is easily
cleared by calling `notifier.reset()` after the Success Screen is shown.

**State lifecycle**:
1. Parent opens app → `RegistrationApplication` is null (notifier starts empty).
2. Branch selected → notifier stores selected `Branch`.
3. Each wizard step completed → notifier updates the relevant section.
4. Submission fails → notifier preserves all data; status set to `failed`.
5. Retry tapped → notifier sets status to `submitting`; re-calls AMS service.
6. Submission succeeds → Success Screen shown; `notifier.reset()` called; state cleared.

**Alternatives considered**:
- `flutter_bloc` — more verbose for a single-screen-group form flow; better suited for complex
  event-driven features.
- `Provider` (ChangeNotifier) — adequate but Riverpod's compile-time safety and testability are
  preferred.
- `StatefulWidget` with props — cannot survive route navigation without complex passing; rejected.

---

## 6. API Key Security

**Decision**: Compile-time constant via `--dart-define=AMS_API_KEY=<value>`. Passed in every
request via `X-API-Key` header through a `dio` interceptor.

**Rationale**: `dart-define` injects values at build time (`const String.fromEnvironment()`).
The key is compiled into the binary rather than stored in a file that could be accidentally
committed. CI/CD pipelines supply the key as an environment variable during the build step.

**Security posture for MVP**:
- The key is in the binary and extractable by a determined attacker with a decompiler. This is
  acceptable for MVP given: (a) HTTPS encrypts the key in transit, (b) AMS can revoke/rotate
  keys, (c) no user PII is accessible via the API without submitting a full form.
- Post-MVP hardening: certificate pinning, AMS-side rate limiting per key, key rotation policy.

**Alternatives considered**:
- Hardcoded string literal — functionally equivalent but easier to accidentally commit or leak
  in logs; `dart-define` is strictly better.
- Runtime fetch from a config endpoint — adds a network dependency before the app is usable;
  over-engineered for MVP.

---

## 7. AMS Integration Method Confirmation

**Status**: REST API assumed per spec Assumptions section.
**Action required**: The AMS owner must confirm the REST API endpoint base URL and whether the
`/api/branches`, `/api/registrations/check-duplicate`, and `POST /api/registrations` endpoints
exist or need to be created. See `contracts/ams-api.md` for the proposed contract.

If the AMS cannot expose a REST API before development starts, a mock HTTP server (`json_server`
or a simple Dart shelf server) should be set up as a development stub so app development is not
blocked.

---

## 8. Eligible Age Range (Deferred)

**Status**: Pending confirmation with academy management (TODO in constitution).
**Interim behaviour**: FR-011 enforces that date of birth must not be in the future. The
age-range validation will be added as a separate task once the range is confirmed. The validation
logic will live in `player_info.dart` model as a static method, making it trivial to add the
range check without touching UI code.
