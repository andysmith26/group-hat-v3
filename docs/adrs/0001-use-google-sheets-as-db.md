Status: Accepted • Owner: Andy Smith • Date: 2025-08-11

# 0001 — Use Google Sheets as the Data Store

## Context
We need a zero-ops, familiar data source where teachers can inspect and edit data directly. Sheets provides a free, audit-friendly source of truth and avoids standing up a database.

## Decision
Use Google Sheets (one spreadsheet with Students, Groups, Preferences) accessed with a service account. The server is the only actor that talks to Google APIs.

## Consequences
Pros: no DB to run, easy inspection, exportable. Cons: quotas, eventual consistency, limited transactional semantics. Future: migrate to a DB if volume or concurrency demands it; keep the API contract stable.
