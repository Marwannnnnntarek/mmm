# Feature Specification: Sports For Life Academy MVP Registration App

**Feature Branch**: `001-registration-app-mvp`

**Created**: 2026-06-06

**Status**: Draft

**Input**: User description: "Sports For Life Academy MVP — digital player registration replacing paper forms: welcome screen, bilingual support, branch selection, multi-section registration form, review, duplicate check, AMS submission, success screen"

## User Scenarios & Testing

### User Story 1 - Arabic Registration Journey (Priority: P1)

A parent scans the academy QR code, opens the app (Arabic is the default language), selects their
branch from a list, fills in all required information across four form sections, reviews a summary
of their entries, and submits the application. A Success Screen displays a copyable reference
number. The entire experience is in Arabic with right-to-left layout.

**Why this priority**: Arabic is the primary language of the target audience (Egyptian parents) and
covers the core end-to-end journey. All other stories depend on this path working correctly.

**Independent Test**: Complete the full registration flow from app launch to Success Screen in
Arabic with valid data for all fields. Verify the reference number is displayed and the application
appears in AMS under the selected branch with status "Pending".

**Acceptance Scenarios**:

1. **Given** the app is launched and Arabic is selected (default), **When** the parent completes
   all form sections and taps Submit, **Then** the Success Screen is shown with a unique,
   copyable application reference number.
2. **Given** the parent is on any screen during the Arabic journey, **When** any text or UI
   element is rendered, **Then** all content uses RTL direction and Arabic labels.
3. **Given** a valid application is submitted, **When** the submission succeeds, **Then** the
   application is recorded in AMS with status "Pending", linked to the selected branch, and
   accessible to the Branch Manager.

---

### User Story 2 - English Registration Journey (Priority: P2)

A parent selects English on the Welcome Screen and completes the same registration flow with all
labels, validation messages, and instructions in English using a left-to-right layout.

**Why this priority**: English support is required for multilingual households. The core Arabic
journey (US1) must be working before this story is validated.

**Independent Test**: Select English on the Welcome Screen and complete the full registration
flow to the Success Screen. Verify all text is in English and the layout is LTR throughout.

**Acceptance Scenarios**:

1. **Given** the parent selects English on the Welcome Screen, **When** all subsequent screens
   are displayed, **Then** all labels, error messages, and buttons appear in English with LTR
   layout.
2. **Given** the parent has not yet tapped "Start Registration", **When** they change language
   on the Welcome Screen, **Then** no form data is lost (none has been entered yet).

---

### User Story 3 - Connectivity-Blocked Start (Priority: P2)

A parent with no internet connection is prevented from entering the registration flow and sees a
clear, actionable message in the selected language.

**Why this priority**: The app is entirely online-dependent. Blocking access early with a clear
message is better than allowing the parent to fill in a form that cannot be submitted.

**Independent Test**: Disable the device's internet connection and tap "Start Registration".
Verify a connectivity error message is shown and the form is inaccessible. Restore internet and
confirm the flow proceeds normally.

**Acceptance Scenarios**:

1. **Given** the device has no internet connection, **When** the app is launched, **Then** a
   connectivity error message is displayed and the parent cannot proceed.
2. **Given** the device has no internet connection, **When** the parent taps "Start
   Registration", **Then** the registration form does not open and an error message is displayed.
3. **Given** a connectivity error was displayed, **When** internet is restored and "Start
   Registration" is tapped again, **Then** the registration flow opens normally.

---

### User Story 4 - Duplicate Player Warning (Priority: P3)

Before submitting, a parent whose child may already be registered at the same branch in AMS sees a
soft warning and can decide to proceed with submission or cancel and contact the academy.

**Why this priority**: Reduces accidental duplicate registrations that create extra work for Branch
Managers. The warning is advisory only; the parent retains final control.

**Independent Test**: Attempt to register a player whose Full Name and Date of Birth already exist
in AMS for the same branch. Verify the warning dialog appears before any data is sent, and that
both "Proceed" and "Cancel" actions behave correctly.

**Acceptance Scenarios**:

1. **Given** AMS contains a record matching the player's Full Name, Date of Birth, and selected
   Branch, **When** the parent taps Submit on the Review Screen, **Then** a duplicate warning
   dialog is shown before the application is transmitted.
2. **Given** the duplicate warning is displayed, **When** the parent chooses to proceed,
   **Then** the application is submitted and the Success Screen is shown.
3. **Given** the duplicate warning is displayed, **When** the parent chooses to cancel,
   **Then** the form remains open with all data intact.

---

### User Story 5 - Submission Failure Recovery (Priority: P3)

A parent whose submission fails due to a connectivity loss or server error can retry without
re-entering any information.

**Why this priority**: Losing form data after several minutes of careful entry is the worst
possible experience for a non-technical parent using this app for the first time.

**Independent Test**: Simulate a server error at the point of submission. Verify all form fields
still contain the parent's entries and a retry option is clearly presented.

**Acceptance Scenarios**:

1. **Given** the parent submits the form, **When** a server or connectivity error occurs,
   **Then** all entered form data is preserved and a retry action is offered.
2. **Given** the submission error message is displayed, **When** the parent taps retry and the
   subsequent attempt succeeds, **Then** the Success Screen is shown with a reference number.
3. **Given** repeated submission failures occur, **When** the parent views the error screen,
   **Then** all entered data remains intact across every retry attempt.

---

### Edge Cases

- What happens when the parent enters a future date as the player's date of birth?
- What happens if the emergency contact phone number matches the parent's primary mobile number?
- If the branch list fails to load, an inline error and Retry button are shown; the parent cannot proceed until the list loads (resolved — see FR-003).
- What happens if the parent enters a mobile number in an invalid Egyptian format?
- If connectivity is lost mid-form, the parent may continue filling in sections; the failure surfaces at submission via the retry mechanism (resolved — see FR-002, FR-018).
- What happens if the parent taps Submit and then immediately loses connectivity mid-request?
- What happens if the medical condition details field is left blank when "Yes" is selected?
- What happens if the eligible age range check is not yet configured (TBD with management)?

## Requirements

### Functional Requirements

- **FR-001**: The system MUST display a Welcome Screen showing the academy logo, name, a welcome
  message, a language selection toggle (Arabic / English, default Arabic), and a "Start
  Registration" button.
- **FR-002**: The system MUST verify internet connectivity when the app is launched and again when
  the parent taps "Start Registration". If no connection is detected, the flow MUST be blocked and
  a message in the selected language MUST be displayed. Connectivity is not re-checked while the
  parent is completing form sections; if connectivity is lost mid-form, the parent MAY continue
  filling the form and the failure will surface at submission (handled by FR-018).
- **FR-003**: The system MUST present a list of active academy branches retrieved from AMS and
  require the parent to select one branch before proceeding to the registration form. If the
  branch list cannot be fetched, the system MUST display an inline error message and a Retry
  button on the Branch Selection screen; the parent MUST NOT be able to proceed until the list
  loads successfully.
- **FR-004**: The system MUST present the registration form as a step-by-step wizard: one section
  per screen in the sequence Parent Information → Player Information → Medical Information →
  Emergency Contact Information. Each screen MUST provide a "Next" action to advance and a "Back"
  action to return to the previous section.
- **FR-005**: The Parent Information section MUST collect: Parent Full Name (required), Mobile
  Number (required), Alternative Mobile Number (required), Email Address (optional).
- **FR-006**: The Player Information section MUST collect: Player Full Name (required), Date of
  Birth (required), Gender (required), School Name (optional).
- **FR-007**: The Medical Information section MUST include a Yes/No toggle for Medical Conditions.
  If "Yes" is selected, a Medical Condition Details text field MUST appear and be required.
- **FR-008**: The Emergency Contact Information section MUST collect: Emergency Contact Name
  (required) and Emergency Contact Phone Number (required).
- **FR-009**: The system MUST validate that all required fields are completed before allowing
  submission; any missing field MUST surface an inline validation message adjacent to that field.
- **FR-010**: The system MUST validate mobile numbers (parent primary, alternative, emergency
  contact) against the Egyptian mobile format (01X-XXXX-XXXX). Invalid formats MUST produce an
  inline validation message.
- **FR-011**: The system MUST reject a date of birth that is in the future. The system MUST also
  reject a date of birth outside the academy's eligible age range once that range is confirmed with
  management.
- **FR-012**: The system MUST reject a submission where the emergency contact phone number is
  identical to the parent's primary mobile number.
- **FR-013**: All inline validation messages MUST be displayed in the language the parent selected
  on the Welcome Screen.
- **FR-014**: The system MUST present a Review Screen (the final step before submission) displaying
  all entered data and the selected branch, grouped by section. The parent MUST be able to tap any
  section on the Review Screen to jump back to that wizard step, edit their entries, and return to
  the Review Screen to continue.
- **FR-015**: Before transmitting to AMS, the system MUST query AMS for an existing record
  matching the player's Full Name, Date of Birth, and selected Branch. If a match is found, a
  soft warning dialog MUST be shown. The parent MUST be able to proceed with submission or cancel
  and return to the form.
- **FR-016**: The system MUST transmit all form data, selected branch, and selected language to
  AMS upon confirmed submission. Every request to an AMS endpoint (branch list, duplicate check,
  submission) MUST include a static API key in the request header; requests without a valid key
  MUST be rejected by AMS.
- **FR-017**: On successful submission, AMS MUST return a system-generated reference number. The
  system MUST display this number on a Success Screen and allow the parent to copy it to the
  clipboard.
- **FR-018**: On submission failure (connectivity or server error), the system MUST preserve all
  entered form data and present a clear retry action to the parent. If no response is received
  from AMS within 30 seconds, the system MUST treat the request as failed and trigger this same
  failure behaviour.
- **FR-019**: Language selection MUST only be available on the Welcome Screen. Switching language
  after the parent has entered the registration flow is not permitted, to prevent data loss.
- **FR-020**: No registration data MUST be retained on the device after a successful submission.

### Key Entities

- **RegistrationApplication**: One parent's submission for one player at one branch. Holds all
  form section data, selected branch, selected language, submission timestamp, AMS-generated
  reference number, and status (default: Pending).
- **Parent**: The adult completing the registration. Has a full name, primary mobile number,
  alternative mobile number, and optional email address.
- **Player**: The child being registered. Has a full name, date of birth, gender, and optional
  school name.
- **MedicalInfo**: Records whether the player has medical conditions (Yes/No) and, when Yes, a
  description of those conditions.
- **EmergencyContact**: A named person reachable at a phone number that differs from the parent's
  primary mobile.
- **Branch**: An active academy location with a name, retrieved from AMS. One branch is selected
  per registration and stored against the application.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Parents can complete the full registration journey — from opening the app to
  receiving a reference number — in under 5 minutes on a standard mobile connection. A submission
  that receives no AMS response within 30 seconds is treated as failed and surfaces the retry
  screen.
- **SC-002**: 100% of submitted applications appear automatically in AMS under the correct branch
  with status "Pending"; zero manual data transfer by academy staff is required.
- **SC-003**: Both Arabic (RTL) and English (LTR) journeys complete without any untranslated
  text or layout direction errors on any screen.
- **SC-004**: All form data entered by the parent is preserved across any number of failed
  submission retries — zero data loss on retry.
- **SC-005**: Duplicate player warnings are shown to the parent for every matching record (same
  player name + date of birth + branch) before any data reaches AMS.
- **SC-006**: Academy staff report zero paper-to-digital transcription work for registrations
  submitted through the app.
- **SC-007**: The app reaches a usable Welcome Screen within 3 seconds of launch on a standard
  mobile data connection.

## Assumptions

- The Academy Management System (AMS) will expose a REST API for receiving registration
  submissions and returning a reference number. If no REST API exists at development time, an
  alternative integration method (direct DB write or message queue) must be confirmed with the AMS
  owner before Phase 1 design begins.
- The eligible player age range will be confirmed with academy management before the age
  validation rule is implemented. A minimum guard (date of birth must not be in the future) will
  be applied in the interim.
- The branch list is fetched from AMS at the start of the session. The number of branches is
  assumed to be manageable for a simple list UI (under 20 entries).
- The app is distributed through the App Store (iOS) and Google Play (Android). The universal QR
  code directs parents to the appropriate store listing.
- The parent is the only user of the app. No staff, admin, or Branch Manager features are included
  in the MVP.
- Photo uploads, birth certificate uploads, parent login, offline mode, payments, push
  notifications, and multi-child sessions are explicitly excluded from the MVP scope.
- All static UI copy (labels, instructions, validation messages, error strings) will be fully
  translated into Arabic and English. Names and free-text entries are accepted as typed by the
  parent in any script.
- The Success Screen reference number is generated by AMS, not by the app itself.
- AMS endpoints are secured by a static API key. The key is embedded in the app build and
  transmitted in every request header. AMS validates the key server-side and rejects requests
  with missing or invalid keys.

## Clarifications

### Session 2026-06-06

- Q: How should the app prove its identity when calling AMS endpoints? → A: Static API key
  embedded in the app, validated by AMS on each request (applied to FR-016 and Assumptions).
- Q: What is the registration form's navigation model? → A: Step-by-step wizard, one section per
  screen, with Next/Back navigation and Submit on the final Review Screen (applied to FR-004,
  FR-014).
- Q: What should the app do if the branch list cannot be fetched from AMS? → A: Show an inline
  error message with a Retry button; block progression until the list loads successfully
  (applied to FR-003, Edge Cases).
- Q: What should happen if the device loses internet while the parent is mid-form? → A: Allow
  the parent to continue filling the form; connectivity is re-checked only at submission, with
  the existing retry mechanism handling the failure (applied to FR-002, Edge Cases).
- Q: What is the maximum time the app should wait for a submission response before showing a
  failure message? → A: 30 seconds (applied to FR-018, SC-001).
