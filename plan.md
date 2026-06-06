# Sports For Life Academy Registration App — MVP Requirements
**Version:** 1.1
**Last Updated:** June 2026

---

## Changelog (v1.0 → v1.1)

| # | Change | Reason |
|---|--------|--------|
| 1 | Added bilingual support (Arabic / English) requirement | MVP targets Egyptian parents; Arabic is primary language |
| 2 | Added branch selector screen | QR is universal; branch must be captured per submission |
| 3 | Added age eligibility validation rule | DOB is collected but no guard existed against ineligible players |
| 4 | Added duplicate submission detection | No protection against re-registering the same player |
| 5 | Added connectivity check requirement | App requires internet; must inform user early rather than fail at submission |
| 6 | Added AMS integration specification guidance | "Send data to AMS" was underspecified for development |
| 7 | Clarified document/photo upload is out of scope | Prevents scope creep assumptions during development |

---

## 1. Overview

The Sports For Life Academy Registration Application is a mobile application designed to replace the current paper-based registration process used for new player applications.

The primary objective of the MVP is to allow parents to submit player registration requests digitally and automatically send the submitted information to the Academy Management System for review.

---

## 2. Business Goals

- Eliminate paper registration forms.
- Reduce manual data entry by academy staff.
- Improve registration accuracy.
- Centralize registration requests in the Academy Management System.
- Speed up the registration process.
- Improve the parent experience during registration.

---

## 3. User Roles

### Parent

The Parent is the only user role included in the MVP.

**Permissions:**

- Open the application.
- Select the academy branch.
- Complete the registration form.
- Review entered information.
- Submit a registration request.

---

## 4. Registration Process

### Registration Flow

1. Parent scans the universal academy QR code.
2. Parent installs and opens the application.
3. App checks for internet connectivity. If unavailable, displays a connectivity error and blocks further progress.
4. Parent selects their academy branch.
5. Parent selects their preferred language (Arabic or English).
6. Parent starts a new registration request.
7. Parent completes the registration form.
8. Parent reviews the entered information.
9. Parent submits the application.
10. Application is automatically sent to the Academy Management System.
11. Application status is created as "Pending".
12. Success screen is displayed with the application reference number.

---

## 5. Functional Requirements

### 5.1 Welcome Screen

**Description:** Provides a simple entry point to the registration process.

**Requirements:**

- Display academy logo.
- Display academy name.
- Display welcome message.
- Display language selection toggle (Arabic / English). Default: Arabic.
- Display "Start Registration" button.

---

### 5.2 Connectivity Check

**Description:** Ensures the parent has an active internet connection before entering the registration flow.

**Requirements:**

- The system shall check for internet connectivity when the application is launched and again when the parent taps "Start Registration".
- If no connection is detected, the system shall display an error message instructing the parent to connect to the internet before proceeding.
- The system shall not allow the parent to proceed to the registration form without an active connection.

---

### 5.3 Branch Selection

**Description:** Allows the parent to identify which academy branch they are registering for, since the QR code is universal.

**Requirements:**

- Display a list of all active academy branches.
- Require the parent to select one branch before proceeding.
- Store the selected branch as part of the submitted application record.
- The selected branch shall be visible on the Review screen and in the Academy Management System.

---

### 5.4 Registration Form

**Description:** Allows parents to submit player information.

**Requirements:** The system shall provide a registration form with the following sections.

---

#### Parent Information

**Required Fields:**

- Parent Full Name
- Mobile Number
- Alternative Mobile Number

**Optional Fields:**

- Email Address

---

#### Player Information

**Required Fields:**

- Player Full Name
- Date of Birth
- Gender

**Optional Fields:**

- School Name

---

#### Medical Information

**Required Field:**

- Medical Conditions (Yes / No)

**Conditional Field:**

- Medical Condition Details — displayed only if Medical Conditions = Yes.

---

#### Emergency Contact Information

**Required Fields:**

- Emergency Contact Name
- Emergency Contact Phone Number

---

> **Out of Scope (MVP):** Photo upload, birth certificate upload, and any document attachments are explicitly excluded from the MVP. These may be considered in a future release.

---

### 5.5 Form Validation

**Requirements:**

The system shall validate all required fields before allowing submission.

The system shall verify:

- Required fields are completed.
- Mobile numbers are entered in a valid Egyptian format (e.g., 01X-XXXX-XXXX).
- Date of birth is a valid date and not a future date.
- Player age falls within the academy's eligible age range (to be confirmed with academy management before development).
- Emergency contact information is provided.
- Emergency contact phone number is different from the parent's primary mobile number.

The system shall display inline validation messages adjacent to invalid fields in the selected language.

---

### 5.6 Duplicate Submission Detection

**Description:** Prevents the same player from being submitted more than once.

**Requirements:**

- Before submission, the system shall check whether a record with the same Player Full Name and Date of Birth already exists in the Academy Management System for the selected branch.
- If a potential duplicate is detected, the system shall display a warning message informing the parent that a registration for this player may already exist.
- The parent shall be given the option to proceed with submission or cancel and contact the academy.

> **Note:** Final duplicate deduplication authority rests with the Branch Manager in the AMS. The app-side check is a soft warning, not a hard block.

---

### 5.7 Review Application

**Description:** Allows parents to review entered information before submission.

**Requirements:**

- Display all entered information, including the selected branch and language.
- Allow parent to return and edit any section.
- Allow parent to confirm and proceed to submission.

---

### 5.8 Application Submission

**Description:** Submits registration information to the Academy Management System.

**Requirements:**

- Save application information.
- Generate a unique application reference number.
- Set application status to "Pending".
- Send application data to the Academy Management System via the defined integration method (see Section 6).
- Display the Success Screen upon confirmed submission.
- If the submission fails due to a connectivity or server error, display an error message and allow the parent to retry. Do not lose entered data on failure.

---

### 5.9 Success Screen

**Description:** Confirms successful submission.

**Requirements:**

Display:

- Success message.
- Application reference number (copyable).
- Thank you message.
- Instruction to await contact from the academy.

---

## 6. Academy Management System Integration

### Description

Submitted applications shall automatically appear in the Academy Management System upon successful submission.

### Integration Specification

> **Action required before development:** The development team must confirm the integration method with the AMS owner. The following options should be evaluated:
>
> - **REST API (preferred):** App POSTs application data as JSON to a secured AMS endpoint. AMS responds with a confirmation and the generated reference number.
> - **Database write:** App writes directly to the AMS database (acceptable only if both systems share infrastructure).
> - **Webhook / message queue:** App publishes to a queue; AMS consumes asynchronously.

### Requirements

- Create a new application record in the AMS.
- Set application status to Pending.
- Store selected branch against the application record.
- Make application available to the Branch Manager of the selected branch.
- Allow Branch Manager to review all submitted information.
- All communication between the app and AMS shall use HTTPS.

---

## 7. Application Management Requirements (AMS Side)

The Academy Management System shall provide:

### Applications List

- View all submitted applications.
- Search applications.
- Filter applications.
- Branch Managers shall only see applications for their assigned branch.

### Application Details

- View complete application information.
- View selected branch.
- View submission date.
- View application reference number.

### Application Status

| Status | Description |
|--------|-------------|
| Pending | Submitted, awaiting review |
| Approved | Accepted by Branch Manager |
| Rejected | Declined by Branch Manager |

---

## 8. Search Requirements

The system shall support searching applications by:

- Parent Name
- Player Name
- Mobile Number
- Application Reference Number

---

## 9. Filtering Requirements

The system shall support filtering applications by:

- Status
- Branch
- Submission Date
- Registration Date Range

---

## 10. Localization Requirements

### Description

The application shall support Arabic and English to serve the academy's parent base.

### Requirements

- Language selection shall be available on the Welcome Screen.
- The selected language shall apply to all screens, labels, validation messages, and success/error messages.
- Arabic layout shall use right-to-left (RTL) text direction.
- English layout shall use left-to-right (LTR) text direction.
- Default language on first launch shall be Arabic.
- The parent may switch language from the Welcome Screen only (not mid-form, to avoid data loss risk).
- All static content (labels, messages, instructions) shall be translated. Player/parent names are entered as-is by the parent.

---

## 11. Non-Functional Requirements

### Performance

- Application shall load within 3 seconds.
- Registration form shall load within 2 seconds.
- Submission process shall complete within 5 seconds.

### Security

- Data shall be securely stored.
- All communication shall use encrypted HTTPS connections.
- Submitted information shall only be accessible by authorized academy staff.
- No registration data shall be cached or stored locally on the device after successful submission.

### Availability

- Application shall support Android devices.
- Application shall support iOS devices.
- Application requires active internet connectivity. Offline mode is not supported in MVP.

### Usability

- Registration process shall be simple and intuitive for non-technical users.
- Form completion shall require minimal user actions.
- Mobile-friendly UI shall be provided.
- All UI shall render correctly in both RTL (Arabic) and LTR (English) layouts.

---

## 12. Data Fields

### Parent Information

| Field | Required | Notes |
|-------|----------|-------|
| Parent Full Name | Yes | |
| Mobile Number | Yes | Egyptian format |
| Alternative Mobile Number | Yes | |
| Email Address | No | |

### Player Information

| Field | Required | Notes |
|-------|----------|-------|
| Player Full Name | Yes | |
| Date of Birth | Yes | Must be valid, not future, within eligible age range |
| Gender | Yes | |
| School Name | No | |

### Medical Information

| Field | Required | Notes |
|-------|----------|-------|
| Medical Conditions | Yes | Yes / No |
| Medical Condition Details | Conditional | Required if Medical Conditions = Yes |

### Emergency Contact Information

| Field | Required | Notes |
|-------|----------|-------|
| Emergency Contact Name | Yes | |
| Emergency Contact Phone | Yes | Must differ from parent mobile |

### System Information

| Field | Source | Notes |
|-------|--------|-------|
| Application Reference Number | System-generated | Displayed on Success Screen |
| Selected Branch | Parent selection | Captured at Branch Selection screen |
| Submission Date | System-generated | |
| Application Status | System-generated | Default: Pending |
| Submission Language | System-captured | Arabic or English |

---

## 13. Out of Scope (MVP)

The following are explicitly excluded from the MVP to maintain focus:

- Document or photo uploads (player photo, birth certificate, medical certificate).
- Parent account creation or login.
- Push notifications or SMS confirmation.
- Offline / draft mode.
- Payment or fee collection.
- Multi-child registration in a single session.
- Branch-specific QR codes.
- Admin portal for managing branches within the app.

---

## 14. MVP Success Criteria

The MVP shall be considered successful when:

- Parents can complete registration in both Arabic and English without paper forms.
- Parents can select the correct branch during registration.
- Registration requests are submitted digitally with no data loss.
- Applications automatically appear in the Academy Management System under the correct branch.
- Duplicate player warnings are surfaced to parents before submission.
- Academy staff no longer manually transfer registration data from paper forms.
- Branch Manager can review all registration requests for their branch from a centralized system.
- Registration processing time is significantly reduced.
