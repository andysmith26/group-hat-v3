Status: Accepted • Owner: Andy Smith • Last verified: 2025-08-11

# Roadmap (Phased Plan)

- [ ] **Phase 1: Foundation & Infrastructure (2 hrs)**
  - Initialize SvelteKit + TypeScript
  - Git + CI/CD + Vercel environment variables
  - Minimal Hello World deploy

- [ ] **Phase 2: Data Integration Layer (5 hrs)**
  - Google Sheets API via service account
  - Scopes: `spreadsheets.readonly` (fetch), `spreadsheets` (write)
  - Secrets in Vercel env vars
  - Shared secret auth header + CORS allow-list
  - `/api/data` returns students, groups, preferences
  - Document sheet schema & dev auth config

- [ ] **Phase 3: Basic Data Display (4 hrs)**
  - UI fetch & render students/groups
  - Empty-state & error messaging for `/api/data`

- [ ] **Phase 4: Manual Grouping UI (6 hrs)**
  - Drag-and-drop (svelte-dnd-action) desktop + mobile
  - Tests: cross-group DnD, capacity enforcement
  - State update flow for moves

- [ ] **Phase 5: Auto-Assignment Algorithms (6 hrs)**
  - Implement `balancedAssign` and `randomAssign`
  - Tests: correctness + missing/unfulfillable preferences

- [ ] **Phase 6: Undo/Redo System (4 hrs)**
  - Snapshot-based history stack (depth limit)
  - Tests: manual moves + post-auto-assign

- [ ] **Phase 7: UI Polish & Responsiveness (4 hrs)**
  - Layout refinement, fill indicators
  - A11y basics: keyboard navigation, focus states

- [ ] **Phase 8: Save & Errors (4 hrs)**
  - `/api/save` writes to new tab; clipboard fallback
  - Error messaging: outage, permission

- [ ] **Phase 9: Comprehensive Testing & Refinement (4 hrs)**
  - Broad testing with realistic datasets
  - Fixes + UX refinement

- [ ] **Phase 10: Documentation & Wrap-up (3 hrs)**
  - Finalize README and docs
  - 1-hr buffer

**Total**: ~38 hrs (+ ~2 hrs buffer)
