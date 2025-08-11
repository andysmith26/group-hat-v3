Status: Accepted • Owner: Andy Smith • Last verified: 2025-08-11

# Operations (Runbook)

## Environments
- **Local**: `pnpm dev` starts the SvelteKit server.
- **Vercel (Preview/Prod)**: auto-deploy on push. Protect secrets via Vercel Project Settings → Environment Variables.

## Required environment variables
- `GOOGLE_SA_EMAIL`
- `GOOGLE_SA_KEY` (escape newlines as `\n`)
- `SHEET_ID`
- `AUTH_SHARED_SECRET` (rotate on compromise or staff changes)
- `ALLOWED_ORIGINS` (comma-separated list/patterns)

## Granting Sheet access
Share the spreadsheet with the service account email (`GOOGLE_SA_EMAIL`) as **Editor**.

## Secret rotation
1. Create a new service account key in Google Cloud.
2. Update `GOOGLE_SA_KEY` in Vercel.
3. Redeploy.
4. Revoke the old key.

## Logging & PII
- Log structured events (request id, route, outcome, latency).
- Do **not** log student names/emails or secrets.
- Prefer error codes over raw provider messages.

## Troubleshooting
- **401**: Check `X-Auth-Token` and Vercel env.
- **403 (origin)**: Verify `ALLOWED_ORIGINS` and app URL.
- **403 (permission)**: Ensure the service account has Editor access.
- **429/503**: Wait and retry; consider exponential backoff.
- **500**: Inspect logs, capture a minimal repro, file an issue.

