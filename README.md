# Group Hat (v3)

A lightweight, teacher-centered tool to create balanced student groups quickly. This is the third iteration (v3), rebuilt from scratch with a modern stack and a focus on clarity and maintainability.

## Quickstart

1. **Clone & Install**

   ```bash
   pnpm install
   pnpm dev
   ```

   This will start the development server (SvelteKit). Ensure you have Node.js and PNPM installed.

2. **Set Environment Variables** (for local `.env` or Vercel environment):

   * `GOOGLE_SA_EMAIL` – Google service account email (for Google Sheets API access)
   * `GOOGLE_SA_KEY` – Google service account private key (JSON, escaped for environment)
   * `SHEET_ID` – Google Sheet ID that holds Students, Groups, Preferences data
   * `AUTH_SHARED_SECRET` – a secret token for API request authorization
   * `ALLOWED_ORIGINS` – comma-separated list of allowed origin URLs for the front-end (e.g. `http://localhost:5173,https://your-deployment-url`)

3. **Run Tests**

   ```bash
   pnpm test
   ```

   This will execute the unit test suite. (Ensure you’ve set up any necessary test environment or sample data.)

Once the app is running, you can access it locally at the URL printed in the console (typically `http://localhost:5173`). The application will connect to the Google Sheet specified in your environment to load student data. Make sure the Google service account has access to that sheet.

## Environments

* **Local Development:** `http://localhost:5173` (via SvelteKit dev server)
* **Preview (Vercel):** Every pull request can create a preview deployment.
* **Production:** e.g., `https://<your-app>.vercel.app` (once deployed, or the custom domain if configured)

## Documentation

Detailed documentation for developers and contributors is available in the `docs/` folder. Key documents include:

* **Guiding Philosophy:** See [`docs/philosophy.md`](docs/philosophy.md) for the core values and principles that inform all design decisions. Read this to understand the rationale behind our approach.
* **Architecture Overview:** See [`docs/architecture.md`](docs/architecture.md) for a high-level description of the system design, including the front-end, back-end, and how Google Sheets is integrated. If you plan to modify the system or add features, start here.
* **Implementation Guide (Phased Plan):** See [`docs/implementation-guide.md`](docs/implementation-guide.md) to understand how the development was structured. This outlines the project in phases and can help in locating where certain functionality is implemented or planned.
* **Data Contracts:** See [`docs/data-contracts.md`](docs/data-contracts.md) for the expected format of data (e.g., the Google Sheet columns for students, groups, preferences). Keep this updated if the data model changes.
* **API Reference:** See [`docs/api.md`](docs/api.md) for details on the API endpoints (`/api/data`, `/api/save`, etc.), their request/response formats, and how to use them. Useful for debugging or if extending the back-end.
* **Operations & Deployment:** See [`docs/operations.md`](docs/operations.md) for how to deploy the app (currently we use Vercel), manage environment variables, and other DevOps notes.
* **Testing Strategy:** See [`docs/testing.md`](docs/testing.md) for how tests are organized and guidelines for writing new tests when you add features or fix bugs.
* **Roadmap:** See [`docs/roadmap.md`](docs/roadmap.md) for a summarized checklist of features and phases. This is a quick-glance view of project progress and planned work.
* **Architecture Decision Records:** See the `docs/adrs/` directory for ADR files documenting major architecture and tech decisions (e.g., framework choice, authentication strategy, etc.).
  
