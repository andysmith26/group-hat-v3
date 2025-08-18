# Architecture Overview

```mermaid
flowchart LR
  %% ========= Nodes =========
  UI["Browser UI<br/>SvelteKit (Svelte 5)"]
  Teacher((Teacher))
  Auth((Auth Provider<br/>Google OAuth))

  subgraph Server["Security Boundary <br/>(Server)"]
    API["SvelteKit API Routes<br/>(Server)"]
    SA["Service Account<br/>Credentials"]
  end

  subgraph GW[Google Workspace]
    Students[(Students Sheet)]
    Groups[(Groups Sheet)]
    Prefs[(Preferences Sheet)]
  end

  %% ========= Flows =========
  UI -->|Sign in / redirect| Auth
  Auth -->|Token / code| UI

  UI -->|GET /api/data<br/>Auth cookie / bearer| API
  UI -->|POST /api/assignments| API
  API -->|Verify token| Auth

  API -->|Read students| Students
  API -->|Read groups| Groups
  API -->|Read prefs| Prefs
  API -->|Write groups / assignments| Groups
  API -->|Write preference updates| Prefs

  API ---|Uses credentials| SA
  SA ---|Sheets API scopes| GW

  UI -. Clipboard fallback (copy list) .-> Teacher
  API -->|Generate link / open sheet| Groups

  %% ========= Styling =========
  classDef ui fill:#f0f9ff,stroke:#3b82f6,stroke-width:1px;
  classDef api fill:#fff7ed,stroke:#ea580c,stroke-width:1px;
  classDef auth fill:#fdf2f8,stroke:#db2777,stroke-width:1px;
  classDef sheet fill:#ecfdf5,stroke:#059669,stroke-width:1px;
  classDef service fill:#f5f3ff,stroke:#7c3aed,stroke-width:1px,stroke-dasharray:3 2;
  classDef external stroke-dasharray:4 3,stroke:#64748b;

  class UI ui
  class API api
  class Auth auth
  class SA service
  class Teacher external
  class Students,Groups,Prefs sheet
```

## Legend & Notes
- Security Boundary: API + service account (never exposed client-side).
- Auth Provider: External (Google OAuth). UI receives code/token; API verifies.
- Service Account: Holds Sheets API scopes; only used within server.
- Separate Sheets: Isolation for students, groups, preferences.
- Clipboard Fallback: Manual, no server round trip.
- Generate link: Convenience to open a sheet directly.

---

## Sequence Diagram: Authentication & Initial Data Load

```mermaid
sequenceDiagram
    participant T as Teacher
    participant B as Browser UI
    participant Auth as Google OAuth
    participant API as SvelteKit API
    participant SA as Service Account
    participant Sheets as Google Sheets

    rect rgb(248,250,252)
    T->>B: Click "Sign in"
    B->>Auth: OAuth authorization request (scopes)
    Auth-->>B: Authorization code
    B->>API: POST /api/auth/callback (code)
    API->>Auth: Exchange code for tokens
    Auth-->>API: ID & Access token
    API->>API: Verify ID token (signature, audience, expiry)
    API-->>B: Set session cookie / response
    end

    B->>API: GET /api/data (session cookie)
    API->>SA: Use service account credentials
    SA->>Sheets: Read Students / Groups / Prefs
    Sheets-->>SA: Sheet data
    SA-->>API: Aggregated data
    API-->>B: JSON payload (students, groups, prefs)
    B-->>T: Render groups list / UI state

    note over B,API: Session cookie may store opaque session id linked to server state
```

## Sequence Diagram: Create / Save Assignments

```mermaid
sequenceDiagram
    participant T as Teacher
    participant B as Browser UI
    participant API as SvelteKit API
    participant SA as Service Account
    participant Sheets as Google Sheets

    T->>B: Click "Save Assignments"
    B->>API: POST /api/assignments (assignments JSON, cookie)
    API->>API: Validate session & payload
    API->>SA: Use service account credentials
    SA->>Sheets: Write new group assignments
    Sheets-->>SA: Write acknowledgement
    SA-->>API: Success / updated revision id
    API-->>B: 201 Created (metadata)
    B-->>T: Show confirmation / link to sheet

    note over API,Sheets: Least-privilege scopes limit access to required Sheets only
```

### Additional Notes
- Tokens: Only the server (API) exchanges the auth code; browser never gets service account keys.
- Session: Prefer HTTP-only, Secure, SameSite=Lax (or Strict) cookie containing an opaque session id mapped to server-side token data.
- Caching: Consider short-lived in-memory or KV cache for sheet reads to reduce latency; bust cache on writes.
- Error Handling: Distinguish auth (401/403), validation (422), and sheet I/O (5xx with retry guidance).
- Observability: Log correlation id across Browser -> API -> Sheets operations for traceability.