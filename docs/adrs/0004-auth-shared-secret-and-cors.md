Status: Accepted • Owner: Andy Smith • Date: 2025-08-11

# 0004 — MVP Auth: Shared Secret + CORS

## Context
We need a minimal boundary so only our UI calls the server, and to keep credentials server-side.

## Decision
Require `X-Auth-Token` header matched to `AUTH_SHARED_SECRET` and enforce an allow-listed `ALLOWED_ORIGINS`.

## Consequences
Pros: simple, effective for MVP. Cons: not user-specific; rotate secrets on compromise. Future: Google Sign-In per teacher if multi-tenant expansion is needed.
