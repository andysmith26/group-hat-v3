
# Roadmap (Phased Plan)

* [ ] **Phase 1: Foundation & Infrastructure**

  * Initialize SvelteKit + TypeScript project
  * Set up Git repo, CI/CD, and Vercel deployment
  * Configure environment variables (Google API credentials, etc.)
  * Deploy a “Hello World” to verify setup

* [ ] **Phase 2: Data Integration Layer**

  * Google Sheets API integration via service account
  * Set up Sheets API scopes (`spreadsheets.readonly` for fetch, `spreadsheets` for write)
  * Store service account credentials and Sheet ID in env vars
  * Implement `/api/data` endpoint to return students, groups, preferences from sheet
  * Implement basic auth for API (shared secret header) and CORS allow-list of app domain
  * Document the Google Sheet schema and any dev setup needed for the service account

* [ ] **Phase 3: Basic Data Display**

  * Front-end fetches from `/api/data` and renders a simple list of students & groups
  * Define TypeScript interfaces for Student, Group, etc.
  * Handle empty or error states for data loading (e.g., show a message if no data)

* [ ] **Phase 4: Manual Grouping UI**

  * Implement drag-and-drop of students between groups using `svelte-dnd-action`
  * Enforce group capacity limits in UI (no adding beyond capacity, or flag it)
  * Update application state on student move and reflect changes immediately
  * Write tests for drag/drop logic and capacity enforcement edge cases

* [ ] **Phase 5: Auto-Assignment Algorithms**

  * Implement `randomAssign` and `balancedAssign` algorithm functions
  * Add UI controls to select algorithm and trigger auto-assignment
  * After auto-assign, display which students got their preferred choices (e.g., highlight)
  * Write unit tests for algorithms (correctness, handling of edge cases like unsatisfiable prefs)

* [ ] **Phase 6: Undo/Redo System**

  * Implement a history stack for group assignment states (with a reasonable depth limit)
  * Add “Undo” and “Redo” buttons and wire up keyboard shortcuts (Ctrl+Z / Ctrl+Y)
  * Test that undo and redo correctly revert and reapply changes for both manual and auto actions

* [ ] **Phase 7: UI Polish & Responsiveness**

  * Refine layout and styling (ensure clean look on laptops, use CSS Grid/Flexbox for group layout)
  * Add instructional text or tooltips for usability
  * Ensure accessibility basics (tab navigation, ARIA labels where needed)
  * Verify UI on tablet (touch interactions, responsive layout)

* [ ] **Phase 8: Save & Error Handling**

  * Implement `/api/save` to write group results to a new sheet tab; ensure no original data overwritten
  * Add a “Save” button in UI; on click, call API and confirm success or show error
  * Implement fallback (copy to clipboard or download file) if direct save fails
  * Provide user feedback on save (e.g., toast notification “Saved!” or error message)

* [ ] **Phase 9: Comprehensive Testing & Refinement**

  * Test entire app with real-world-sized data; fix any functional bugs
  * Verify all user stories from each phase are met in integration
  * Add/improve unit tests for critical logic
  * Address any major UX issues discovered during testing

* [ ] **Phase 10: Documentation & Wrap-up**

  * Update README with usage and setup instructions
  * Finalize architecture docs and ADRs for key decisions
  * Add code comments in complex sections
  * Small fixes for any minor issues found late
  * Use remaining buffer time for any unfinished tasks or polish

