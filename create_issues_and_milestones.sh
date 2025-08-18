#!/bin/bash

set -e
echo "Creating milestone: Roster Display UI"
gh milestone create "Roster Display UI" || true
gh issue create --title "Create src/routes/groups/+page.svelte" --body "**What needs to be built:**
Create the main Svelte page that loads and renders students/groups from the Sheets API.

**What to test:**
Ensure it renders correctly using mocked data and `load()` function.

**What to document:**
Add JSDoc to load function. Comment props and markup." --milestone "Roster Display UI" --label "enhancement"
gh issue create --title "Create GroupTable.svelte and StudentRow.svelte components" --body "**What needs to be built:**
Render group name, capacity, and students in a <table> layout.

**What to test:**
Unit test with fixture data; validate table DOM.

**What to document:**
Comment props and structure in both components." --milestone "Roster Display UI" --label "enhancement"
gh issue create --title "Use load() function to fetch from /api/data" --body "**What needs to be built:**
Integrate SvelteKit `load()` to request student/group data via API on page init.

**What to test:**
Write Vitest test for successful load and fallback states.

**What to document:**
Document structure of response payload from API." --milestone "Roster Display UI" --label "enhancement"
echo "Creating milestone: State & Reassignment Logic"
gh milestone create "State & Reassignment Logic" || true
gh issue create --title "Create assignmentStore.ts" --body "**What needs to be built:**
Create a Svelte writable store that maps studentId -> groupId|null.

**What to test:**
Unit test reducer logic and update behavior.

**What to document:**
JSDoc type definition; describe update flow." --milestone "State & Reassignment Logic" --label "enhancement"
gh issue create --title "Create AssignmentPanel.svelte" --body "**What needs to be built:**
Show students with controls for reassigning group membership.

**What to test:**
Simulate UI reassignment and check DOM/assignmentStore changes.

**What to document:**
Describe UI assumptions and bindings." --milestone "State & Reassignment Logic" --label "enhancement"
gh issue create --title "Add dropdown in StudentRow.svelte" --body "**What needs to be built:**
Bind to assignment store and update on change.

**What to test:**
Test interaction with assignment store and UI update.

**What to document:**
Explain dropdown values and onchange behavior." --milestone "State & Reassignment Logic" --label "enhancement"
echo "Creating milestone: Auto-Assign Algorithm"
gh milestone create "Auto-Assign Algorithm" || true
gh issue create --title "Create lib/algorithms.ts" --body "**What needs to be built:**
Implement balancedAssign(students, groups, prefs).

**What to test:**
Write tests for edge cases and capacity constraints.

**What to document:**
Inline JSDoc and usage notes." --milestone "Auto-Assign Algorithm" --label "enhancement"
gh issue create --title "Wire Auto Assign button in AssignmentPanel.svelte" --body "**What needs to be built:**
Hook up to balancedAssign and update assignment store.

**What to test:**
Test integration with mocked state.

**What to document:**
Comment flow of data and assumptions." --milestone "Auto-Assign Algorithm" --label "enhancement"
echo "Creating milestone: Export Results"
gh milestone create "Export Results" || true
gh issue create --title "Create exportAssignmentToText utility" --body "**What needs to be built:**
Format assignment into text table for clipboard copy.

**What to test:**
Test formatting with sample data sets.

**What to document:**
Document function signature and output format." --milestone "Export Results" --label "enhancement"
gh issue create --title "Add Copy button and integrate clipboard" --body "**What needs to be built:**
Use navigator.clipboard API to copy generated string.

**What to test:**
Simulate copy and validate toast appears.

**What to document:**
Comment UI integration assumptions." --milestone "Export Results" --label "enhancement"
echo "Creating milestone: UI Polish + Validation"
gh milestone create "UI Polish + Validation" || true
gh issue create --title "Add responsive layout styles" --body "**What needs to be built:**
Ensure the UI is usable at 1024px and 1280px widths.

**What to test:**
Manual layout verification; snapshot DOM.

**What to document:**
Document CSS or utility classes used." --milestone "UI Polish + Validation" --label "enhancement"
gh issue create --title "Highlight overfilled groups" --body "**What needs to be built:**
Calculate group fill and flag over-capacity visually.

**What to test:**
Test overfill conditions with mock data.

**What to document:**
Explain UI warning logic." --milestone "UI Polish + Validation" --label "enhancement"
gh issue create --title "Create HelpPanel.svelte with usage tips" --body "**What needs to be built:**
Add collapsible text block with brief instructions.

**What to test:**
Check toggle behavior and a11y attributes.

**What to document:**
Inline guidance for devs adding future tips." --milestone "UI Polish + Validation" --label "enhancement"
echo "Creating milestone: Testing & Feedback"
gh milestone create "Testing & Feedback" || true
gh issue create --title "Test with real class data (sanitized)" --body "**What needs to be built:**
Validate full flow with live Google Sheet data.

**What to test:**
Exploratory test session with teacher or peer.

**What to document:**
Log session outcomes and gaps." --milestone "Testing & Feedback" --label "enhancement"
gh issue create --title "Write Vitest tests for balancedAssign" --body "**What needs to be built:**
Cover known happy/unhappy student paths.

**What to test:**
Run coverage and boundary test cases.

**What to document:**
Document any edge case discovered." --milestone "Testing & Feedback" --label "enhancement"
gh issue create --title "Prepare staging link and share" --body "**What needs to be built:**
Use Vercel preview for testing session.

**What to test:**
Ensure it loads and behaves without auth.

**What to document:**
Record issues or teacher feedback." --milestone "Testing & Feedback" --label "enhancement"
echo "Creating milestone: Optional - Save to Sheet"
gh milestone create "Optional - Save to Sheet" || true
gh issue create --title "Implement POST /api/save endpoint" --body "**What needs to be built:**
Push assignments back to a new tab in the Google Sheet.

**What to test:**
Mock sheet write, then validate real call.

**What to document:**
Explain endpoint design and payload contract." --milestone "Optional - Save to Sheet" --label "enhancement"
gh issue create --title "Wire Save button to endpoint" --body "**What needs to be built:**
Trigger save and show success toast.

**What to test:**
Test UI flow and error fallback.

**What to document:**
Document UX contract and retries." --milestone "Optional - Save to Sheet" --label "enhancement"