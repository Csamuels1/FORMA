# FORMA Technical Architecture

## Summary

FORMA should use a feature-first Flutter architecture with Riverpod for state management. The MVP baseline uses a Firebase-style backend stack for speed and operational simplicity, and the remaining vendor choice is now treated as a documented recommendation rather than an unresolved dependency.

## Flutter structure

- `lib/app/` for app shell, router, and theme
- `lib/core/` for shared utilities, design tokens, and common abstractions
- `lib/features/<feature>/` for feature modules
- `lib/features/<feature>/data`, `domain`, and `presentation` layers where needed

## State management

- Use Riverpod.
- Rationale: strong testability, granular rebuild control, and a clean fit for feature-first Flutter code.

## Backend recommendation

- Confirmed MVP baseline: Firebase Auth, Firestore, Cloud Storage, Cloud Functions, Cloud Messaging, and Remote Config.
- Reasoning: fast solo-team velocity, managed auth/storage, and good fit for iterative MVP delivery.
- For the MVP, this stack is the assumed implementation path unless the product direction changes.

## Body photo pipeline

1. Capture photo in a dedicated full-screen flow.
2. Show a guided overlay that enforces pose and framing.
3. Confirm consent before any analysis or upload.
4. Perform analysis on-device for MVP, with ML Kit or TFLite as the likely implementation path.
5. Store the minimum necessary photo data under a defined retention policy.
6. Support deletion of photos and derived artifacts when the user deletes the account or revokes consent.

## Ad integration plan

- Confirmed MVP ad network: AdMob.
- Banner ads may appear on the dashboard and feed.
- Interstitial ads may appear only between workout sessions.
- Ads are prohibited during active sets, rest timers, and photo capture or consent.
- Ad placement rules should be enforced centrally, not inside individual widgets.

## Data model

### Users

- id, auth provider, tier, locale, region, createdAt

### Workout plans

- id, userId, goal, environment, daysPerWeek, progressionRules

### Exercises

- id, planId, name, demoUrl, sets, reps, restSeconds

### Sessions

- id, userId, planId, date, status, completedSets, summary

### Food logs

- id, userId, date, calories, macros, mealItems

### Photos

- id, userId, type, storageRef, createdAt, retentionPolicy, analysisStatus

### Streaks

- userId, currentCount, bestCount, freezeBalance, lastActiveDate

### Community

- posts, comments, likes, follows, and media references

## Offline strategy

- Workout data and active-session data should be available offline.
- Non-critical writes can queue locally and sync later.
- The app should degrade gracefully when network access is unavailable.

## Third-party packages

- `flutter_riverpod`
- `go_router`
- `intl`
- Platform photo and camera packages during implementation
- Backend SDKs once the vendor choice is confirmed

## Security and privacy notes

- Sensitive data should be minimized and encrypted at rest wherever the backend supports it.
- Photo consent, storage, and deletion behavior must be explicit and auditable.

## Decision gates

- Backend vendor has been resolved for the MVP as Firebase-style infrastructure.
- Body-photo analysis has been resolved for the MVP as on-device analysis.
- Ad network has been resolved for the MVP as AdMob.
