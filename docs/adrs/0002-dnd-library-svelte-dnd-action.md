Status: Accepted • Owner: Andy Smith • Date: 2025-08-11

# 0002 — Drag-and-Drop via svelte-dnd-action

## Context
We need reliable DnD on desktop and mobile with minimal boilerplate in Svelte 5.

## Decision
Adopt `svelte-dnd-action` for manual grouping interactions.

## Consequences
Pros: small API, good mobile support. Cons: library-specific behavior to learn. Alternative considered: custom pointer handlers (more work, less a11y by default).
