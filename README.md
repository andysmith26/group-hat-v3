# Group Hat (v3)

A lightweight, teacher-centered tool to create balanced student groups quickly.

## Quickstart
1. **Clone & install**
   ```bash
   pnpm i
   pnpm dev
   ```
2. **Set environment variables** (Vercel or `.env`):
   - `GOOGLE_SA_EMAIL` — Google service account email
   - `GOOGLE_SA_KEY` — JSON private key for the service account (escaped newlines)
   - `SHEET_ID` — Google Sheet ID holding Students / Groups / Preferences
   - `AUTH_SHARED_SECRET` — random secret for API requests
   - `ALLOWED_ORIGINS` — comma-separated origins allowed by CORS (e.g. `http://localhost:5173,https://*.vercel.app`)

3. **Run tests**
   ```bash
   pnpm test
   ```

## Environments
- **Local**: http://localhost:5173
- **Preview (Vercel)**: created per PR
- **Production**: `https://<your-app>.vercel.app`

## Where to find things
- Architecture overview: `docs/architecture.md`
- Data contracts (Sheet schema): `docs/data-contracts.md`
- API reference: `docs/api.md`
- Operations & deployment: `docs/operations.md`
- Testing strategy: `docs/testing.md`
- Roadmap: `docs/roadmap.md`
- Decisions (ADRs): `docs/adrs/`

---
_Status: Accepted • Owner: Andy Smith • Last verified: 2025-08-11_
