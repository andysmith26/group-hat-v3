# Implementation Guide

This guide outlines a phased approach to implementing Group Hat v3 over roughly 40 hours of development. The work is broken down into 10 phases, each with specific goals, motivation, user stories satisfied, and risks to manage. This structure ensures that the project delivers working functionality incrementally while maintaining the overall architectural integrity and core values.

## Phase 1: Foundation & Infrastructure (2 hours)

**Goals:**

* Initialize a new SvelteKit project (with TypeScript) for the front-end.
* Set up the project repository with version control and CI/CD.
* Configure deployment pipeline (using Vercel) and verify a “Hello World” deployment.
* Establish environment variables and configuration for secrets (Google API credentials, etc.).

**Motivation:**
Starting with a solid foundation ensures all subsequent work builds on reliable infrastructure. An early deployment setup enables continuous testing and stakeholder feedback throughout development. By getting a basic app up on Vercel from the start, we de-risk integration issues and can continuously deploy changes.

**User Stories Achieved:**

* As a *developer*, I can push changes and have them automatically deployed, so that I can iterate quickly and see results live.
* As a *teacher*, I can access the application via a stable URL (even if it’s just a placeholder page initially), so that I know where the tool will live and can bookmark it.

**Risks & Mitigation:**

* **Risk:** Initial project setup or deployment configuration issues could eat into planned time.
  **Mitigation:** Use a proven SvelteKit + Vercel template or starter. Start with the default example app to ensure the pipeline works, then incrementally add our code. Perform a minimal “Hello World” deploy to verify CI/CD early.
* **Risk:** Misconfigured environment variables could cause runtime errors.
  **Mitigation:** Immediately set up local `.env` and Vercel env vars for at least a dummy value, and document the needed variables (Google service account, sheet ID, etc.) in `operations.md` so we don’t forget anything.

**Why This Phase:**
This phase is minimal but critical. Laying the groundwork (repository, build, deploy) first means every subsequent phase can focus on feature code rather than pipeline issues. Allocating \~2 hours is sufficient given experience and AI assistance, and prevents snowballing setup problems later.

---

## Phase 2: Data Integration Layer (5 hours)

**Goals:**

* Implement server-side integration with Google Sheets API using a service account.
* Create a backend endpoint (e.g. `GET /api/data`) that fetches student names, groups, and preference data from the Google Sheet.
* Handle authentication to Google APIs via the service account’s credentials (stored securely).
* Ensure data privacy measures are in place (no unnecessary data stored, etc., per our philosophy).
* Lay groundwork for a `/api/save` endpoint (even if not fully implemented yet) for future save functionality.

**Motivation:**
Eliminating manual CSV uploads is the biggest usability improvement over v2. Direct Google Sheets integration makes the tool seamless for teachers who already use Google Forms (with responses automatically in a Sheet). Building the data layer early also forces us to solidify the data schema and ensures that subsequent UI work can be done with real data.

**User Stories Achieved:**

* As a *teacher*, I can load student preferences directly from my Google Sheet, without downloading or uploading any files, so that setup is quick and error-free.
* As a *teacher*, I know that my student data remains secure and is not stored in any additional databases, so that privacy is maintained (the data comes straight from and goes back to my own Google Sheet).

**Risks & Mitigation:**

* **Risk:** Google API authentication is complex (scopes, credentials, etc.).
  **Mitigation:** Start by testing with a public or simple sheet (no auth) to get the integration right, then add the service account credentials. Use Google’s Node.js client libraries and follow their examples. Have a fallback plan (e.g., read a local JSON of sample data) to use if the API integration takes longer than expected, so UI development isn’t blocked.
* **Risk:** API rate limits or quota issues might arise with Google Sheets API.
  **Mitigation:** Implement simple caching on the server (store the last fetched data in memory for quick reloads within a session) and be mindful to fetch only what is needed. For the MVP scale (one class sheet), this is unlikely an issue, but design the code to minimize API calls (e.g., one call to fetch all needed ranges at once).

**Why This Phase:**
Around 5 hours is allocated because this involves external systems and should include testing with real Google Sheets data. This phase must be completed before any UI that depends on real data is built, and it carries some uncertainty (credentials, permissions), so it’s given a healthy time slot early in the project.

---

## Phase 3: Basic Data Display (4 hours)

**Goals:**

* Create a simple front-end page that displays the loaded class data (students and groups) in a basic format.
* Define TypeScript interfaces or types for core entities like `Student` and `Group` based on the data coming from the sheet.
* Set up Svelte stores or another state management approach to hold the data in the front-end.
* Verify the end-to-end data flow: the front-end calls `/api/data`, receives data, and correctly populates the UI.

**Motivation:**
Establishing the data flow and basic display early validates that our architecture (front-end ↔ back-end ↔ Google Sheets) works. It provides a foundation for all upcoming UI work and gives an early visible result (even if minimal) to ensure we’re on the right track.

**User Stories Achieved:**

* As a *teacher*, I can see a list of my students and initial empty groups when I open the app, confirming that my data from the Google Sheet has loaded.
* As a *teacher*, I can tell that the app is connected to my spreadsheet (for example, if I update the sheet and reload, I see the changes), so that I trust the integration.

**Risks & Mitigation:**

* **Risk:** Managing application state for the first time (students, groups lists) could introduce complexity or bugs.
  **Mitigation:** Start with straightforward Svelte writable stores or context, avoid premature optimization. Keep the state global for now (since it’s a small app) and refactor later if needed. Use the TypeScript interfaces to catch type mismatches.
* **Risk:** The developer might not be fully comfortable with Svelte/SvelteKit yet.
  **Mitigation:** Keep this phase’s UI very simple (e.g., a list of student names and group names) to get familiar with Svelte syntax and data binding. Leverage online examples or AI help for any Svelte-specific syntax issues.

**Why This Phase:**
Allocating \~4 hours for this ensures there’s time to set up the basic structures that will be used throughout the app (components, stores, API calls) without doing any heavy logic yet. It’s a manageable chunk that provides immediate feedback and momentum.

---

## Phase 4: Manual Grouping UI (6 hours)

**Goals:**

* Implement the drag-and-drop functionality for manually assigning students to groups.
* Develop the `GroupCard` component to visually represent a group and its members.
* Enforce group capacity in the UI (e.g., visually indicate when a group is full, and prevent extra drops if needed).
* Update the application state whenever a student is moved between groups or back to an “unassigned” pool.
* Ensure that these interactions are smooth on desktop (mouse) and touch devices.

**Motivation:**
Manual grouping is the core user interaction of Group Hat – teachers need to be able to adjust groupings easily. Building this now establishes the interactive backbone of the app. It’s also a complex feature, so tackling it early ensures we have time to refine it. This phase brings the app’s main screen to life with real interactivity.

**User Stories Achieved:**

* As a *teacher*, I can drag and drop students between groups to create the groups I want, giving me fine-grained control over group assignments.
* As a *teacher*, I can see when a group has reached its capacity (for example, the group card might visually indicate it’s full), so that I don’t overload groups.
* As a *teacher*, I can also remove a student from a group (drag them out to an “unassigned” area or another group), so that I can correct mistakes or adjust compositions easily.

**Risks & Mitigation:**

* **Risk:** Integrating a drag-and-drop library (like `svelte-dnd-action`) might have a learning curve or unexpected behavior.
  **Mitigation:** Start with the library’s basic example to ensure it works in our context. Implement a simple use-case first (e.g., just reordering within one list) before multiple lists, to understand the events. Read documentation and use a minimal setup to test library behavior, then build up complexity.
* **Risk:** Ensuring the drag/drop works on mobile touch screens and not just with a mouse.
  **Mitigation:** Test early on an actual phone or tablet (or at least using browser dev tools emulation for touch). The chosen library is known to support touch, but we should verify gestures like dragging with a finger. Also, as a fallback, consider adding alternative ways to move students (like “move to group” buttons or dropdown) if dragging fails on some device – but only if absolutely necessary.

**Why This Phase:**
We’ve allocated \~6 hours because this is a make-or-break feature for usability. There are many moving parts (UI updates, state management, library integration, capacity rules), and it’s worth getting it right. Doing it now, after basic data flow is set, ensures we can test manual grouping thoroughly before adding automated grouping logic.

---

## Phase 5: Auto-Assignment Algorithms (6 hours)

**Goals:**

* Implement the first version of the **random assignment** algorithm (even distribution of students into groups randomly).
* Implement the **balanced assignment** algorithm that respects student preferences (try to maximize each student’s chances of getting one of their preferred groups while balancing group sizes).
* Provide a simple UI control to choose which algorithm to run (e.g., a dropdown or two buttons: “Random Assign” and “Preference-Based Assign”).
* Hook up an “Auto-Assign” button that, when clicked, runs the selected algorithm and updates the groups state with the computed assignment.
* Indicate in the UI which students got one of their top preferences (e.g. highlight or mark “happy” students).

**Motivation:**
Automated grouping is the flagship capability that saves teachers time. By implementing the algorithms, we achieve feature parity with v2 (which had auto-grouping) and improve upon it using the new architecture. This also tests our domain logic separation – the algorithms should utilize the data models and be independent of the UI, which we can validate here.

**User Stories Achieved:**

* As a *teacher*, I can click a button to automatically assign all students into groups based on their preferences, so that I get a good initial grouping without doing it all manually.
* As a *teacher*, I can choose between different assignment methods (e.g., purely random or preference-based) to compare outcomes or use the method I trust more.
* As a *teacher*, after auto-assignment, I can easily see which students got one of their preferred groups (for instance, they might be highlighted in green), so that I understand the outcome quality at a glance.

**Risks & Mitigation:**

* **Risk:** The assignment algorithms might not work correctly on the first try, leading to obvious issues (like students missing or duplicate assignments).
  **Mitigation:** Start by porting the known logic from v2 (which had some working algorithms) but rewrite it in a cleaner, testable way. Use small test datasets to manually verify outcomes. Also, incorporate unit tests for these algorithms in this phase (simple cases like 3 students, 2 groups with obvious preferences, etc.).
* **Risk:** The “balanced” algorithm might not satisfy many preferences if done greedily, leading to teacher disappointment.
  **Mitigation:** Make sure to at least match v2’s capability. If time allows, consider slight improvements or at least clearly communicate how the algorithm works (maybe in documentation or a tooltip). This sets the stage for future enhancement, but for now, any automatic result that’s reasonable is still a time-saver.
* **Risk:** UI getting out of sync with the new assignment state (since we’re programmatically changing a lot of data at once).
  **Mitigation:** Because we’re using reactive stores, this should largely be handled. But we will test by running auto-assign, then trying a manual move, etc., to ensure everything stays consistent. We’ll also ensure to clear any previous manual moves properly when auto-assign runs (or integrate them if possible).

**Why This Phase:**
Another \~6 hours is allotted because implementing two algorithms and testing them thoroughly is non-trivial. Achieving this in the MVP fulfills one of the primary requirements of the app (automating group creation), and doing it after manual UI is done means we can immediately visualize and test the algorithm results in the actual interface.

---

## Phase 6: Undo/Redo System (4 hours)

**Goals:**

* Implement a history stack to record state changes in group assignments so that actions can be undone and redone.
* Include both manual moves and auto-assign actions in the history (so a teacher can even undo an entire auto-assignment if they didn’t like the result).
* Add “Undo” and “Redo” buttons to the UI, and support the common keyboard shortcuts (Ctrl+Z / Ctrl+Y or Cmd+Z / Cmd+Shift+Z on Mac).
* Ensure that the history has a reasonable limit (to avoid memory issues if a teacher does a lot of operations, e.g., keep last 50 states).
* Make sure that undo/redo operations properly update the UI by reverting to a previous state of assignments.

**Motivation:**
Teachers need the confidence to experiment with groupings. An Undo/Redo feature is critical to let them try adjustments or different algorithms without fear of ruining their work. It significantly improves UX (v2 had an undo function behind a keyboard shortcut, but exposing it clearly and making it robust is a UX win).

**User Stories Achieved:**

* As a *teacher*, I can undo an accidental move or assignment with a single click (or keystroke), so that mistakes are not permanent and I can try different ideas freely.
* As a *teacher*, I can redo an action I’ve undone, so that I can compare scenarios or recover an undone change if I decide it was actually better.
* As a *teacher*, I can use familiar shortcuts (Ctrl+Z / Ctrl+Y) for undo/redo, which makes the feature feel natural and quick.

**Risks & Mitigation:**

* **Risk:** Implementing a history of a complex state could introduce bugs (e.g., a redo might not correctly reapply a state if intervening changes happened).
  **Mitigation:** Use a simple approach: whenever a state-changing action occurs, take a deep clone of the relevant state (the assignment of students to groups) and push it onto a history stack. Similarly, pop from the stack for undo. We won’t try to get fancy with diffs – just store full snapshots given the data size is small (a few dozen students). Write a couple of tests for the history to ensure pushing, undoing, redoing works as expected.
* **Risk:** Memory usage if the state snapshots are large (unlikely with our data sizes).
  **Mitigation:** Limit the history depth (e.g., 50 or 100 operations max). The data involved (list of maybe up to 100 students and group IDs) is very small, so memory isn’t a real concern here.
* **Risk:** The user might get confused about what exactly is undone/redone if we don’t give any indication.
  **Mitigation:** Consider providing a small on-screen message (“Undid last action” or “Redid last action”) or at least ensure the effect is apparent (the groups visibly revert). Given time constraints, a simple approach is fine.

**Why This Phase:**
4 hours is sufficient for a straightforward implementation of undo/redo using a stack, as this is a well-understood pattern. Doing it at this point means all major interactive features (manual moves, auto-assign) are in place, so we can integrate the history with all of them. It also gives us a fully functional core application by the end of this phase – the teacher can load data, auto-group, manually adjust, and undo/redo changes.

---

## Phase 7: UI Polish & User Experience (4 hours)

**Goals:**

* Refine the visual design and layout for clarity and professionalism (CSS polish, spacing, colors).
* Add helpful instructional text or tooltips where appropriate (e.g., a short blurb on how to use the app, or tooltip explanations on buttons).
* Ensure the layout is responsive for common use cases (in particular, test on a typical laptop resolution and a tablet; adjust styles as needed).
* Add visual indicators such as group fill level (e.g., show number of students vs capacity) and highlight any obvious issues (like if a group has more members than capacity, mark it in red).
* Double-check accessibility features: all buttons and interactive elements should be reachable via keyboard (tab order) and have appropriate labels.

**Motivation:**
A bit of polish goes a long way in building user confidence and satisfaction. This phase is about moving from a functional prototype to a tool that looks and feels ready for real use in a classroom setting. It’s also easier to do this once all major features are in, so we don’t waste time polishing things that might change. Moreover, addressing responsiveness and accessibility now ensures we aren’t surprised by issues later.

**User Stories Achieved:**

* As a *teacher*, I feel that the tool is intuitive to use without a lot of external guidance (the UI makes it clear how to load data, create groups, etc., thanks to labels or short instructions).
* As a *teacher*, I can use the tool on my tablet or on different screen sizes without elements overflowing or appearing distorted, so that I’m not limited to a single device.
* As a *teacher*, I can quickly see which groups have space for more students or which are overfull, because the UI clearly denotes group capacities (e.g., “3/5 students” or a visual fill bar).

**Risks & Mitigation:**

* **Risk:** Time could easily be lost in endless UI tweaks or chasing “perfect” design.
  **Mitigation:** Focus on improvements that enhance clarity and usability, not just aesthetics. Use simple, clean design patterns (e.g., card layouts, basic color schemes). If time runs short, prioritize things that affect understanding (labels, instructions) over pure visual flair.
* **Risk:** Some accessibility issues might be overlooked (especially if we’re not experts in a11y).
  **Mitigation:** Use Svelte’s accessibility warning mode (which surfaces common issues during development). Do a quick keyboard-only navigation test to ensure all interactive items can be reached and activated. For screen readers, ensure important elements have descriptive text. If deep accessibility testing isn’t feasible now, at least structure the HTML in a semantic way (using proper elements for lists, buttons, headings) as a foundation.

**Why This Phase:**
We allocate \~4 hours here to give a bit of breathing room for UX fixes and polish. By this stage, the app is fully functional, so this time is to make sure it’s also pleasant and easy to use. A polished app will encourage adoption and feedback, whereas a clunky-looking one might put users off despite good functionality.

---

## Phase 8: Save Functionality (4 hours)

**Goals:**

* Complete the implementation of saving group assignments back to the Google Sheet via a new API route (e.g., finalize the `/api/save` endpoint).
* When the teacher clicks a “Save” button in the UI, take the current grouping and send it to the server to write into the spreadsheet (likely creating a new worksheet or updating a “Results” tab).
* Provide feedback to the user upon saving – e.g., a confirmation message like “Groups saved to your Google Sheet” or an error message if something goes wrong.
* Implement a fallback option: if direct save fails (due to permissions or offline use), at least allow the teacher to copy the results (maybe format a text summary that can be copy-pasted, or enable a CSV download of the assignments).

**Motivation:**
Closing the loop on data integration (writing back results) makes the tool significantly more useful. In v2, teachers had to copy-paste or export results manually. With a save function, the app becomes a truly integrated part of their workflow, storing results in the same place they got their data. It’s also a key part of our “teacher-centered” value: don’t make the user do extra work to keep a record of what they did.

**User Stories Achieved:**

* As a *teacher*, I can save my final group assignments back into my Google Sheet with one click, so that I have a record of the grouping and can share or refer to it later without leaving the spreadsheet environment.
* As a *teacher*, if the direct save fails for some reason, I am presented with an easy alternative (like copying the assignments to my clipboard) so that I never lose the grouping I see on screen.
* As a *teacher*, I receive clear confirmation when my grouping has been saved (or see an error if it wasn’t), so I have confidence about the outcome of clicking “Save”.

**Risks & Mitigation:**

* **Risk:** Writing to the Google Sheet might encounter issues (insufficient permissions, Google API nuances about specific ranges/tabs).
  **Mitigation:** Plan to write to a new worksheet to minimize risk of overwriting important data. For example, create a sheet tab named “GroupHat Results” with a timestamp. This way, even if something is off, we’re not corrupting the source data. Test the write operation with a sample sheet beforehand. Use clear error messages if it fails (e.g., “Unable to save – please check that the service account has edit access to the sheet”).
* **Risk:** Time might be tight at this phase, and save could be complex.
  **Mitigation:** If extremely short on time, implement a simpler fallback like generating a downloadable CSV or a text blob of results that the teacher can manually paste into a sheet. This ensures the functionality (getting data out) is there even if full automation isn’t perfect. But aim for the direct integration first.
* **Risk:** The teacher might worry about what happens to their original data on save.
  **Mitigation:** Clearly, our approach is to never overwrite the original form responses. By writing to a new tab or a specific area designated for output, we avoid confusion. Document this behavior (in the UI or docs) so they know their raw data remains untouched.

**Why This Phase:**
We assign \~4 hours to implement and test saving because it involves backend work and Google API calls that are a bit different from reading data. By doing this after most other features, we ensure that the grouping data is fully in place to be saved. It also gives us a near-complete product by phase 8 – at this point, the app can load data, allow grouping (manually or automatically), and save the results.

---

## Phase 9: Testing & Refinement (4 hours)

**Goals:**

* Conduct thorough testing with realistic data sets (e.g., use an actual Google Form output with dozens of student entries, various preferences, etc.) to ensure the app works in a real-world scenario.
* Identify and fix any bugs discovered during testing, especially critical issues that could cause data corruption or incorrect group assignments.
* Write core unit tests for critical functions (if not done in earlier phases) – particularly the grouping algorithms and any utility functions.
* Verify the application’s behavior under edge cases: no students, no preferences provided, all students preferring the same group, etc., to ensure graceful handling.
* Do a final accessibility and responsive design check (e.g., try using the app with only keyboard input, try on a smartphone browser, etc.) and make minor adjustments if needed.

**Motivation:**
Quality assurance at this stage ensures that when we deliver the “finished” product, it’s reliable and robust. Given the time constraints, we likely were testing as we built each phase, but this dedicated phase ensures we don’t skip verification of any important aspects. It’s much better to find and fix issues now than to have teachers encounter them during a demo or first use.

**User Stories Achieved:**

* As a *teacher (end user)*, I can rely on the tool to work correctly with my real class data – meaning it doesn’t crash, it handles all my students and preferences, and produces groupings that make sense – so that I trust using it for actual class planning.
* As a *developer/contributor*, I can run an automated test suite and see that key functionalities are verified, so that I have confidence making changes or that future changes won’t unknowingly break existing features.
* As a *teacher*, I can use basic features like navigation and grouping with assistive technology (keyboard or screen reader), so that the app is inclusive to different usage needs.

**Risks & Mitigation:**

* **Risk:** Not all bugs will be caught, especially subtle logical issues that require very specific scenarios.
  **Mitigation:** Prioritize testing the core usage scenarios that must work (loading data, performing an auto-assign, doing a few manual moves, saving results). Additionally, add tests for boundary conditions of algorithms (like when group sizes don’t divide the class evenly, or when preferences can’t all be satisfied). Accept that minor cosmetic bugs might remain but no show-stoppers.
* **Risk:** Time for testing is short and there might be pressure to skip it to add more features.
  **Mitigation:** Treat testing as non-negotiable for this phase. If needed, cut optional features (some polish or low-priority enhancement) to free time for testing. Automated tests, even if few, are especially valuable for long-term maintenance, so invest the hour or two to write them.
* **Risk:** Some accessibility improvements might be complex to implement fully.
  **Mitigation:** Ensure at least basic accessibility (we might not achieve full WCAG compliance in 40 hours, but ensure no fundamental blockers: all interactive elements are reachable and labeled). Document any known gaps for future work.

**Why This Phase:**
Another \~4 hours is reserved to solidify the project. By scheduling a testing phase, we acknowledge its importance. It also gives a bit of buffer – if an earlier phase ran over and minor feature work leaked into this time, we still ensure a final pass for bugs. After this phase, the app should be in a state that we can confidently hand to users.

---

## Phase 10: Documentation & Wrap-up (3 hours)

**Goals:**

* Write or update the **README** and other documentation to accurately reflect the new v3 app (setup instructions, how to use the features, etc.).
* Document the high-level architecture decisions and rationale (which, in our case, means finalizing this documentation suite – architecture guide, ADRs, etc., to leave a clear record for future contributors).
* Add inline code comments in the codebase where the intent might not be obvious, especially for complex sections of logic.
* Fix any remaining “quick win” issues discovered in testing that are small (for example, a typo in the UI or a mislabeled button).
* Ensure that all environment variables, deployment steps, and usage instructions are clearly laid out for someone else setting up the project.

**Motivation:**
Good documentation and a bit of buffer time ensure the project is maintainable and comprehensible after the initial development sprint. Since this project is also a portfolio piece for the developer, having thorough documentation demonstrates professionalism and helps others (or the developer themselves, in a few months) to navigate the code. This final phase is about tying up loose ends and ensuring nothing critical is left undone.

**User Stories Achieved:**

* As a *developer* (or future contributor), I can read the repository’s README and docs to understand how the system is designed and how to run or modify it, so that onboarding to the project is smooth.
* As a *teacher*, I can find a basic usage guide or help in the documentation (if provided) so that I’m not lost using the tool or setting it up.
* As a *stakeholder*, I can see that the project has a clear record of decisions and plans, which gives me confidence that it was thoughtfully built and can be extended.

**Risks & Mitigation:**

* **Risk:** Rushing documentation could lead to inaccuracies or omissions, which might confuse future readers.
  **Mitigation:** Keep notes throughout development (each phase) on key points to document. Use this phase to compile and polish those notes. If time is very short, focus on the most critical docs: the README (quickstart, how to deploy, how to set up the sheet, etc.) and the architecture overview. Less critical might be exhaustive commenting of every function – prioritize high-level understanding.
* **Risk:** Running out of buffer time if earlier phases slipped, potentially eating into documentation time.
  **Mitigation:** Aim to write some documentation incrementally (for example, update README with any new setup steps as soon as they are implemented). Use the buffer strategically: if something in a previous phase took an extra hour, make sure to still allocate at least some time in this phase for docs, even if it means not every nice-to-have fix is done.

**Why This Phase:**
By reserving \~3 hours at the end (including a small buffer), we acknowledge that a project isn’t complete without documentation and cleanup. This time ensures that when the 40 hours are up, we have not only a working app but also a maintainable project. It’s the difference between a throwaway prototype and a sustainable tool. Documentation written here (and continuously) will serve as a reference for anyone who picks up the project later.

---

## Success Metrics

Each phase will be considered successful when:

1. The defined primary **user stories** for that phase are demonstrably working in the app.
2. Code for that phase’s features is committed and deployed to a testing/staging environment (e.g., the Vercel preview) for review.
3. Basic testing (manual or automated) confirms the new functionality behaves as expected.
4. No blocking bugs or issues are introduced that would prevent moving on to the next phase.

By meeting these criteria, we ensure that the project progresses with a continuously usable product, and we can catch problems early.

## Critical Path

Some phases are on the critical path for the project’s core functionality and must be completed in order, whereas others could be trimmed if time runs short. The following phases are **must-haves** and blockers for later work:

* **Phase 1: Foundation** – Blocks everything else (cannot start feature dev without a project setup).
* **Phase 2: Data Integration** – Blocks most UI work that needs real data (Phase 3 and beyond). Without data, the UI can’t be meaningfully built or tested.
* **Phase 4: Manual Grouping UI** – This is the core interactive feature; without it, the app fails the primary use case (even if auto-assignment exists, teachers need to tweak groupings).
* **Phase 5: Auto-Assignment** – Provides parity with v2’s functionality and is a key selling point (automation). Without it, v3 wouldn’t offer a major improvement over manual grouping alone.

Phases 6–10, while important for a polished and complete product, could be adjusted or reduced in scope if absolutely necessary. For example, if we’re running out of time: the Undo/Redo (Phase 6) and Save (Phase 8) features could potentially be simplified or deferred, and additional polish (Phase 7) could be minimal. Testing and docs (Phases 9 and 10) should not be skipped, but their depth can be proportional to remaining time. However, each of these later phases provides significant value to the end product, so they are included in the plan and will be tackled time permitting.
