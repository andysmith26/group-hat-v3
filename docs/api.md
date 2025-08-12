
# API

All endpoints require:
- Header: `X-Auth-Token: <AUTH_SHARED_SECRET>`
- CORS: origin must be in `ALLOWED_ORIGINS`

Errors return `{
  "error": {"code": "<CODE>", "message": "<human readable>"}
}` with appropriate HTTP status.

## GET /api/data
Fetches the latest Students, Groups, and Preferences from Google Sheets.

### Request
Headers:
- `X-Auth-Token`
- `Origin`

### Response 200
```json
{
  "students": [{"id":"s-001","name":"Avery Hill"}],
  "groups": [{"id":"g-1","name":"Blue","capacity":4}],
  "preferences": [{"studentId":"s-001","preferWith":["s-002"],"avoidWith":[]}]
}
```

### Error cases
- 401 `UNAUTHENTICATED` — missing/invalid secret
- 403 `FORBIDDEN_ORIGIN` — origin not allowed by CORS
- 503 `SHEETS_UNAVAILABLE` — Google Sheets error/outage
- 500 `INTERNAL` — unexpected server error

## POST /api/save
Writes the current assignment to a **new tab** in the spreadsheet (default).

### Request
Headers:
- `X-Auth-Token`
- `Origin`

Body:
```json
{
  "assignment": [{"studentId":"s-001","groupId":"g-1"}],
  "metadata": {"source":"ui","algorithm":"balancedAssign"}
}
```

### Response 200
```json
{
  "status":"ok",
  "sheet":{"tabName":"GroupHat Result - 2025-08-11","url":"https://docs.google.com/..."}
}
```

### Error cases
- 401 `UNAUTHENTICATED`
- 403 `FORBIDDEN_ORIGIN`
- 403 `PERMISSION_DENIED` — service account lacks access to the sheet
- 429 `RATE_LIMITED` — Sheets quota exceeded
- 503 `SHEETS_UNAVAILABLE`
- 500 `INTERNAL`

## Clipboard fallback
If `POST /api/save` fails, the UI offers a **Copy to clipboard** of CSV/JSON for manual paste.

