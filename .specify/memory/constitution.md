<!--
SYNC IMPACT REPORT
==================
Version change: (template) → 1.0.0 (initial ratification)

Modified principles: N/A — first-time fill from template placeholders

Added sections:
  - Core Principles (5 principles: Mobile-First, Bilingual, Privacy, Connectivity-Gated, Submission Resilience)
  - AMS Integration Standards
  - Development Quality Standards
  - Governance

Removed sections: All bracket placeholder tokens replaced; template comments removed

Templates reviewed:
  - .specify/templates/plan-template.md      ✅ Constitution Check gate present; principles now concrete
  - .specify/templates/spec-template.md      ✅ Scope/requirements align with privacy and bilingual constraints
  - .specify/templates/tasks-template.md     ✅ Task phases reflect quality standards (analyze, validate, localize)
  - .specify/templates/commands/ (none found) ✅ No command files to update

Follow-up TODOs:
  - TODO(ELIGIBLE_AGE_RANGE): Confirm eligible player age range with academy management before
    implementing DOB validation (referenced in Principle V and Development Quality Standards).
  - TODO(AMS_INTEGRATION_METHOD): Confirm REST API vs. DB write vs. message queue with AMS owner
    before beginning Phase 1 design (referenced in AMS Integration Standards).
-->

# Sports For Life Academy Registration App Constitution

## Core Principles

### I. Mobile-First, Cross-Platform Delivery

The application MUST be delivered as a single Flutter codebase targeting both Android and iOS.
Native platform divergence is prohibited unless strictly required by a platform-specific capability
that cannot be achieved in Flutter. UI MUST render correctly on standard phone screen sizes;
tablet-specific layouts are out of scope for MVP. All behaviour described in the MVP requirements
document (`plan.md`) MUST be implementable within this constraint.

### II. Bilingual by Design (Arabic + English)

Localization is a first-class concern, not a post-launch addition. All UI labels, validation
messages, error strings, and success copy MUST exist in both Arabic and English before any screen
is considered complete. Arabic is the default language on first launch. Arabic layouts MUST apply
RTL text direction; English layouts MUST apply LTR. Language selection is available only on the
Welcome Screen — switching language mid-form is explicitly prohibited to prevent data loss.
The `intl` package is the standard localization mechanism for this project.

### III. Privacy and Data Minimization

No registration data MUST be cached or persisted locally on the device after a successful
submission. This is a security requirement, not a preference. All network communication between
the app and the Academy Management System (AMS) MUST use HTTPS. Submitted information is
accessible only to authorized academy staff via AMS; the app itself retains no records.

### IV. Connectivity-Gated Flow

The app requires active internet connectivity to function. Internet availability MUST be verified
at two points: (1) on application launch, and (2) when the parent taps "Start Registration". If
no connection is detected at either checkpoint, the flow MUST be blocked and a clear error message
shown in the selected language. Offline mode is explicitly out of scope for MVP; workarounds that
simulate partial offline capability are prohibited.

### V. Submission Resilience

A submission failure (caused by connectivity loss or a server error) MUST NOT result in data loss.
All entered form data MUST be preserved so the parent can retry without re-entering any
information. Loss of form data on a failed submission is a P1 defect. Retry behaviour must be
surfaced as a clear, actionable UI message rather than a silent failure.

## AMS Integration Standards

All integration with the Academy Management System must comply with the following rules:

- **Integration method**: REST API is the preferred method. A direct database write is acceptable
  only if both systems share managed infrastructure and is approved in writing. A webhook or
  message queue is acceptable as a fallback. The method MUST be confirmed with the AMS owner
  before Phase 1 design begins.
  TODO(AMS_INTEGRATION_METHOD): Confirm with AMS owner before development starts.
- **Transport security**: All app-to-AMS communication MUST use HTTPS. Plain HTTP is prohibited.
- **Reference number**: On successful submission, AMS MUST return a system-generated reference
  number. The app displays this number on the Success Screen and makes it copyable.
- **Initial status**: Every new application record created in AMS MUST have status set to
  "Pending".
- **Duplicate detection**: Before submission, the app checks for an existing record with the same
  Player Full Name, Date of Birth, and selected Branch in AMS. A match triggers a soft warning
  dialog; the parent may proceed or cancel. Final deduplication authority rests with the Branch
  Manager in AMS — the app-side check is advisory only.

## Development Quality Standards

- `flutter analyze` MUST pass with zero errors before any feature branch is merged.
- All UI changes MUST be manually tested in both Arabic (RTL) and English (LTR) layouts before
  being marked complete.
- Form validation rules (Egyptian mobile number format `01X-XXXX-XXXX`, valid DOB not in future,
  player age within eligible range, emergency contact phone differs from parent mobile) are
  non-negotiable requirements and MUST be covered by widget or unit tests.
- TODO(ELIGIBLE_AGE_RANGE): The eligible player age range must be confirmed with academy
  management before the DOB validation rule is implemented.
- The MVP out-of-scope boundary (no photo uploads, no parent login, no offline mode, no payments,
  no push notifications, no multi-child sessions) MUST be respected. Scope additions require an
  explicit amendment to `plan.md` and a version bump to this constitution.

## Governance

This constitution is the highest-level authority for all development decisions on the Sports For
Life Academy Registration App. It supersedes informal conventions, personal preferences, and any
conflicting guidance in external tools or frameworks.

**Amendment procedure**: Any change to a Core Principle, the AMS Integration Standards, or the
Development Quality Standards requires: (1) updating this file with a version bump following the
policy below, (2) reviewing `.specify/templates/plan-template.md`, `spec-template.md`, and
`tasks-template.md` for alignment, and (3) a commit message referencing the new version (e.g.,
`docs: amend constitution to v1.1.0 — add data-retention principle`).

**Compliance review**: Every feature plan MUST include a Constitution Check gate (as defined in
`plan-template.md`) that is evaluated before Phase 0 research begins and re-checked after
Phase 1 design.

**Versioning policy**:
- MAJOR: A Core Principle is removed, fundamentally redefined, or governance structure changes.
- MINOR: A new principle or major section is added, or existing guidance is materially expanded.
- PATCH: Wording clarification, typo fix, or non-semantic refinement.

**Version**: 1.0.0 | **Ratified**: 2026-06-06 | **Last Amended**: 2026-06-06
