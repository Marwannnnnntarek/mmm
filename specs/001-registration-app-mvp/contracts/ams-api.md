# AMS REST API Contract

**Date**: 2026-06-06
**Branch**: `001-registration-app-mvp`
**Status**: Proposed — requires confirmation with AMS owner before development begins

---

## General Rules

- **Base URL**: To be confirmed with AMS owner. Example: `https://ams.sportsforlifeacademy.com/api`
- **Authentication**: All requests MUST include the header `X-API-Key: <static-key>`. Requests
  with a missing or invalid key MUST be rejected by AMS with HTTP 401.
- **Transport**: HTTPS only. Plain HTTP must be refused.
- **Content-Type**: All request bodies and response bodies use `application/json`.
- **Client timeout**: 30 seconds (connect + receive). The app treats any response not received
  within 30 seconds as a failure and shows the retry screen.
- **Date format**: ISO 8601 date (`YYYY-MM-DD`) for all date fields.
- **Language codes**: `"ar"` for Arabic, `"en"` for English (ISO 639-1).

---

## Endpoints

### 1. GET /branches

**Purpose**: Retrieve the list of active academy branches for the Branch Selection screen.

**Request**

```
GET /branches
Headers:
  X-API-Key: <static-key>
```

**Response 200 — Success**

```json
{
  "branches": [
    {
      "id": "string",
      "name": "string"
    }
  ]
}
```

| Field | Type | Notes |
|-------|------|-------|
| branches | array | May be empty if no active branches exist |
| branches[].id | string | Stable identifier sent back in submission payload |
| branches[].name | string | Human-readable name displayed in the UI |

**Response 401** — Invalid or missing API key

```json
{ "error": "Unauthorized" }
```

**Response 500** — Server error

```json
{ "error": "string" }
```

**App behaviour on failure**: Show inline error and Retry button on Branch Selection screen.
Do not allow the parent to proceed until a successful 200 response is received (FR-003).

---

### 2. GET /registrations/check-duplicate

**Purpose**: Check whether a player with the same Full Name and Date of Birth is already
registered at the selected branch. Used for the soft duplicate warning before submission.

**Request**

```
GET /registrations/check-duplicate
Headers:
  X-API-Key: <static-key>
Query parameters:
  playerFullName  string   Required. URL-encoded full name of the player.
  dateOfBirth     string   Required. ISO 8601 date (YYYY-MM-DD).
  branchId        string   Required. Branch ID from /branches response.
```

**Response 200 — Success**

```json
{
  "isDuplicate": true,
  "matchCount": 1
}
```

| Field | Type | Notes |
|-------|------|-------|
| isDuplicate | boolean | `true` if ≥1 matching record found |
| matchCount | integer | Number of matching records (0 if no duplicate) |

**Response 400** — Missing or invalid query parameters

```json
{ "error": "string", "field": "string" }
```

**Response 401** — Invalid or missing API key

```json
{ "error": "Unauthorized" }
```

**App behaviour**:
- If `isDuplicate == true`: show soft warning dialog. Parent may proceed or cancel (FR-015).
- If request fails (network error, 4xx, 5xx): skip the duplicate check silently and allow
  submission to proceed. The Branch Manager in AMS has final deduplication authority.

---

### 3. POST /registrations

**Purpose**: Submit a completed registration application to AMS.

**Request**

```
POST /registrations
Headers:
  X-API-Key: <static-key>
  Content-Type: application/json
```

**Request Body**

```json
{
  "branchId": "string",
  "language": "ar",
  "parent": {
    "fullName": "string",
    "mobileNumber": "string",
    "alternativeMobileNumber": "string",
    "email": "string"
  },
  "player": {
    "fullName": "string",
    "dateOfBirth": "YYYY-MM-DD",
    "gender": "male",
    "schoolName": "string"
  },
  "medicalInfo": {
    "hasMedicalConditions": false,
    "conditionDetails": "string"
  },
  "emergencyContact": {
    "name": "string",
    "phoneNumber": "string"
  }
}
```

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| branchId | string | Yes | From /branches response |
| language | string | Yes | `"ar"` or `"en"` |
| parent.fullName | string | Yes | |
| parent.mobileNumber | string | Yes | Egyptian format |
| parent.alternativeMobileNumber | string | Yes | Egyptian format |
| parent.email | string | No | Omit field if not provided |
| player.fullName | string | Yes | |
| player.dateOfBirth | string | Yes | ISO 8601 date |
| player.gender | string | Yes | `"male"` or `"female"` |
| player.schoolName | string | No | Omit field if not provided |
| medicalInfo.hasMedicalConditions | boolean | Yes | |
| medicalInfo.conditionDetails | string | Conditional | Required when `hasMedicalConditions` is `true`; omit otherwise |
| emergencyContact.name | string | Yes | |
| emergencyContact.phoneNumber | string | Yes | Egyptian format; differs from parent.mobileNumber |

**Response 201 — Created**

```json
{
  "referenceNumber": "string",
  "status": "pending",
  "submissionTimestamp": "2026-06-06T10:30:00Z"
}
```

| Field | Type | Notes |
|-------|------|-------|
| referenceNumber | string | System-generated; displayed on Success Screen; copyable |
| status | string | Always `"pending"` on creation |
| submissionTimestamp | string | ISO 8601 datetime |

**Response 400** — Validation error

```json
{
  "error": "Validation failed",
  "fields": [
    { "field": "parent.mobileNumber", "message": "Invalid Egyptian mobile format" }
  ]
}
```

**Response 401** — Invalid or missing API key

```json
{ "error": "Unauthorized" }
```

**Response 500** — Server error

```json
{ "error": "string" }
```

**App behaviour**:
- 201: Extract `referenceNumber`; show Success Screen; clear all form data from memory.
- 400: Show a user-friendly error in the selected language; keep form data; offer retry.
- 401: Show a generic error message (do not expose key details); keep form data.
- 5xx or timeout (30s): Show retry screen with all form data preserved (FR-018).

---

## Error Handling Summary

| Scenario | HTTP Status | App Response |
|----------|-------------|--------------|
| Invalid API key | 401 | Generic error; keep form data |
| Bad request (validation) | 400 | User-friendly field-level error if possible |
| Server error | 500 | Retry screen; data preserved |
| Network error / timeout | N/A (client) | Retry screen; data preserved |
| Duplicate check fails | Any error | Skip check silently; allow submission |
| Branch list fails | Any error | Inline error + Retry on Branch Selection screen |
