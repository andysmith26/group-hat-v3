# Data Contracts (Google Sheets)

The spreadsheet identified by `SHEET_ID` must include three tabs with exact names and headers.

## 1) `Students`
Required columns (row 1 = headers):
- `id` (string, unique) — stable student identifier
- `name` (string) — display name
- `email` (string, optional)
- `notes` (string, optional)

Example rows:
```
id,name,email,notes
s-001,Avery Hill,avery@example.org,
s-002,Jordan Lee,,Needs partner confidence
```

## 2) `Groups`
Required columns:
- `id` (string, unique)
- `name` (string)
- `capacity` (integer ≥ 1)

Example rows:
```
id,name,capacity
g-1,Blue,4
g-2,Green,4
```

## 3) `Preferences`
Required columns:
- `studentId` (string, must match `Students.id`)
- `preferWith` (comma-separated `Students.id`, optional)
- `avoidWith` (comma-separated `Students.id`, optional)
- `notes` (string, optional)

Example rows:
```
studentId,preferWith,avoidWith,notes
s-001,s-002,,
s-002,,s-003,avoid conflict
```

## Invariants
- Every `studentId` in `Preferences` must exist in `Students`.
- Group `capacity` is enforced in the UI and by algorithms.
- A student appears in at most one group in an assignment.
- Prefer/avoid lists can reference only existing students (invalid IDs are ignored with a warning).

## Versioning
- Backward-compatible changes (adding optional columns) bump **schema minor**.
- Breaking changes (renaming/removing columns) bump **schema major** and require UI/API updates.

