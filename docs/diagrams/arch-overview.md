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