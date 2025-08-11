# Architecture Overview

The following diagram illustrates the high‑level architecture, security boundary, authentication interactions, and data flows between the browser UI, backend API, and Google Sheets.

```mermaid
flowchart LR
  %% Core Nodes
  UI["Browser UI<br/>SvelteKit (Svelte 5)"]
  Teacher[(Teacher User)]
  API[("SvelteKit API Routes<br/>(Server)")]
  Auth[("("Auth Provider<br/>(e.g. Google OAuth)")")]
  SA[(Service Account<br/>Credentials)]
  
  %% Google Workspace / Sheets Subgraph
  subgraph GW[Google Workspace]
    direction TB
    GS_Students[("Google Sheet:<br/>Students")]
    GS_Groups[("Google Sheet:<br/>Groups")]
    GS_Prefs[("Google Sheet:<br/>Preferences")]
  end

  %% Security Boundary (Server)
  subgraph SB[Security Boundary (Server / Deployment)]
    API
    SA
  end

  %% Edges: Browser <-> Auth
  UI -->|Sign-in / OAuth redirect| Auth
  Auth -->|ID token / OAuth code| UI

  %% Auth usage with API
  UI -->|HTTPS (fetch) GET /api/data<br/>Auth: cookie / bearer| API
  UI -->|HTTPS POST /api/assignments<br/>Auth: cookie / bearer| API
  API -->|Verify / Introspect token| Auth

  %% API <-> Sheets
  API -->|Read students| GS_Students
  API -->|Read groups| GS_Groups
  API -->|Read prefs| GS_Prefs
  API -->|Write new groups / assignments| GS_Groups
  API -->|Write preference updates| GS_Prefs

  %% Service account relation
  API ---|Uses service account creds| SA
  SA ---|Scopes allow Sheets R/W| GW

  %% Clipboard fallback path (no server round trip)
  UI -. Clipboard fallback (copy list) .-> Teacher

  %% Optional: opening a sheet in a new tab (direct view)
  API -->|Generate link / open new tab| GS_Groups

  %% Styling
  classDef ui fill:#f8faff,stroke:#3b82f6,stroke-width:1px;
  classDef api fill:#fff7ed,stroke:#ea580c,stroke-width:1px;
  classDef auth fill:#fdf2f8,stroke:#db2777,stroke-width:1px;
  classDef sheet fill:#ecfdf5,stroke:#059669,stroke-width:1px;
  classDef service fill:#f5f3ff,stroke:#7c3aed,stroke-width:1px,stroke-dasharray: 3 2;
  classDef external stroke-dasharray:4 3;
  class UI ui
  class API api
  class Auth auth
  class SA service
  class Teacher external
  class GS_Students,GS_Groups,GS_Prefs sheet

  %% Link & edge styles
  linkStyle default stroke:#555,stroke-width:1.1px;
  linkStyle 6,7 stroke:#2563eb;          %% UI -> API calls
  linkStyle 8 stroke:#db2777,stroke-dasharray:3 2; %% API verify token
  linkStyle 9,10,11,12,13 stroke:#059669;
  linkStyle 14 stroke:#7c3aed,stroke-dasharray:4 3;
  linkStyle 16 stroke:#ea580c,stroke-dasharray:3 2;

  %% Notes:
  %% - Security Boundary encloses server-resident components (API + Service Account).
  %% - Google Workspace subgraph groups Sheets assets.
  %% - Auth provider is external (OAuth).
  %% - Clipboard fallback provides offline / quick sharing option.
```

## Legend & Notes
- Security Boundary: Components deployed on the server (API + service account credentials) isolated from the browser.
- Auth Provider: External identity provider issuing tokens consumed by the UI and verified by the API.
- Service Account: Holds OAuth scopes for Google Sheets read/write operations; never exposed to the browser.
- Clipboard Fallback: Allows teacher to copy results locally if automated write / open-tab fails.
- Separate Sheets: Division of Students, Groups, and Preferences simplifies least-privilege and future auditing.