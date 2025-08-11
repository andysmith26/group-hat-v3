Status: Accepted • Owner: Andy Smith • Date: 2025-08-11

# 0005 — Save to New Tab (Default)

## Context
We want auditable, non-destructive writes and easy re-runs.

## Decision
Default write to a new tab named `GroupHat Result - <date>`; optionally support writing an `Assigned Group` column in `Students`.

## Consequences
Pros: non-destructive, versioned. Cons: more tabs over time (acceptable). Add cleanup guidance in operations if needed.
