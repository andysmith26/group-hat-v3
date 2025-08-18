Status: Accepted • Owner: Andy Smith • Last verified: 2025-08-11

# Testing Strategy

## What we test
- **Algorithms**
  - `balancedAssign` and `randomAssign`
  - Invariants: no over-capacity groups; no duplicates; preferences honored when possible.
- **Manual DnD**
  - Moves across groups respect capacity; keyboard and touch basics work.
- **History**
  - Undo/redo across manual moves and after auto-assign.
- **API surfaces**
  - `/api/data` happy path, empty data, and error banner
  - `/api/save` success path and fallback surfaced in UI
- **A11y basics**
  - Focus visible, tab order sensible, ARIA labels for controls.

## How to run
```bash
pnpm test
```

## Fixtures
- Small, realistic CSV/JSON fixtures for students, groups, and preferences.
- Edge cases: missing students in preferences, zero-capacity group, unfulfillable constraints.

