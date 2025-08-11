Status: Accepted • Owner: Andy Smith • Date: 2025-08-11

# 0003 — Undo/Redo via Snapshot History

## Context
Users need to experiment without fear; grouping is exploratory.

## Decision
Keep an in-memory history stack of shallow, compressed snapshots with a fixed depth (e.g., 50).

## Consequences
Pros: simple, fast. Cons: memory footprint grows with dataset size; limits cross-session history (acceptable for MVP).
