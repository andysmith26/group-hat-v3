Status: Accepted • Owner: Andy Smith • Last verified: 2025-08-11

# Architecture

## Overview
Group Hat is a SvelteKit (Svelte 5) app with a thin server layer for Google Sheets access. The browser UI handles grouping (manual drag-and-drop and auto-assign algorithms). API routes read/write to a single Google Sheet via a service account. No user data is persisted on our servers.

## Diagram
See `docs/diagrams/arch-overview.mmd` (Mermaid).

## Key components
- **UI (SvelteKit)**: Renders students & groups, supports drag-and-drop and keyboard interactions, shows fill indicators and errors.
- **Domain Logic**: In-memory model of students, groups, and preferences + algorithms: `balancedAssign` and `randomAssign`.
- **History**: Snapshot-based undo/redo stack in memory.
- **API routes**: `GET /api/data` (read-only) and `POST /api/save` (write results). Both require a shared secret header and pass a strict CORS check.
- **Data store**: Google Sheets (single spreadsheet with three tabs).

## Data flow (happy path)
1. UI calls `GET /api/data` → server (service account) fetches Students / Groups / Preferences → returns JSON.
2. User manually arranges or runs an auto-assign algorithm → state updates in memory + history snapshot.
3. User clicks Save → UI posts assignments to `POST /api/save`.
4. Server writes to a **new tab** in the spreadsheet (default) and returns a confirmation. UI shows a success link. If writing fails, UI offers **Copy to clipboard** fallback.

## Security boundary
- Service account credentials live **only** on the server (Vercel). The browser never sees them.
- Endpoints require `X-Auth-Token: <AUTH_SHARED_SECRET>` and must pass a CORS allow-list check (`ALLOWED_ORIGINS`).
- Logging excludes student PII and secrets.

## Non-goals (MVP)
- OAuth login and per-teacher accounts.
- Server-side persistence or databases beyond Google Sheets.
- Deep accessibility audit (we do basics only).
- Full mobile-first redesign (we ensure it’s usable, not perfect).

