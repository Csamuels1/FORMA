# FORMA Software Requirements Specification

## 1. Purpose

FORMA is a Flutter mobile app for men aged 28-45 who want to lose their first 20 pounds without going to a gym. The MVP focuses on home-only training, guided nutrition, progress tracking, and accountability.

## 2. Scope

### MVP in scope

- Onboarding with goal, environment, physical stats, photo capture, and plan reveal
- Home workout sessions with exercise guidance, timers, and progression
- Nutrition targets and meal suggestions relevant to the user's location
- Progress tracking with monthly photo check-ins and measurement logging
- Streaks, milestones, and monthly streak freeze
- Community feed with posting, liking, commenting, and following
- Ad-supported free tier and Pro tier gating

### MVP out of scope

- Gym and outdoor workout environments
- Referrals
- Advanced social graph tooling such as groups and event systems
- Medical advice, diagnosis, or body-composition guarantees
- Wearable integrations

### V2 scope

- Gym and outdoor workout environments
- Full comparison history and deeper analytics
- Expanded community features such as groups and shareable milestone cards
- Referral program

## 3. Personas

### Primary persona

- Male, 28-45
- Wants a realistic home-only path to lose weight
- Values structure, privacy, and visible progress
- Needs a plan that adapts without feeling overwhelming

### Secondary personas

- Other adults pursuing home fitness goals
- Users in later markets once localization expands

## 4. Functional requirements

### 4.1 Onboarding

- The app must collect goal selection, environment selection, body stats, and photo consent.
- The app must support a guided full-body photo capture flow.
- The app must generate and reveal a personalized daily plan after onboarding.

### 4.2 Workout Engine

- The app must present a daily workout session with exercise list, demo media, sets, reps, and rest timers.
- The app must track set completion and workout completion.
- The app must support progressive overload logic.
- The app must keep the active workout session usable offline.

### 4.3 Nutrition

- The app must display daily calorie and macro targets.
- The app must offer location-aware meal suggestions.
- The app must let users log meals and basic adherence.

### 4.4 Progress Tracking

- The app must support monthly photo check-ins.
- The app must support weight and measurement logging.
- The app must compare the current photo to the most recent prior photo on the free tier.
- The app must support complete comparison history for Pro users.

### 4.5 Streaks

- The app must track daily completion streaks.
- The app must show milestone celebrations.
- The app must support one streak freeze per month by default for Pro users, pending confirmation.

### 4.6 Community

- The app must provide an Instagram-style feed.
- The app must support follow, like, comment, and posting behavior.
- The app must support future topic-based groups, but groups are not part of the MVP implementation.

### 4.7 Monetization and Ads

- The app must support a free tier with ads.
- The app must support a Pro tier with ads removed.
- Ads must appear only in approved placements.
- Ads must never appear during an active set, during a rest timer, or during the photo consent/capture flow.
- Interstitial ads may appear only between workout sessions, after the Done action and before summary.
- AI plan re-adjustments must be limited to once every 2 weeks on the free tier.
- Monetization limits must be configurable remotely rather than hardcoded.

### 4.8 Notifications

- The app should support reminders for workouts, progress check-ins, and streak risk.
- Notification content must respect privacy and user preferences.

### 4.9 Account and Auth

- The app must support account creation, sign-in, and logout.
- The app must support account deletion and data deletion request flows.

## 5. Non-functional requirements

### 5.1 Performance

- The app should open to the main authenticated shell in under 3 seconds on a mid-range device after first launch assets are cached.
- Workout screens must remain responsive even when offline.
- Photo capture and workout timing must not stutter during active use.

### 5.2 Offline behavior

- Workout sessions must work without network connectivity after plan data is available.
- The app should queue writes for non-critical data when offline.
- Photo upload or cloud sync must fail gracefully and be resumable.

### 5.3 Privacy and data handling

- Body photos are sensitive personal data.
- The app must show explicit consent screens before photo capture or upload.
- The app must disclose whether photo analysis happens on-device or in the cloud before capture.
- The app must document storage location, retention policy, and deletion flow.
- The app must support account deletion that removes or anonymizes photos and derived data according to policy.
- The MVP should prefer the least invasive storage and analysis design that still works for the product.

### 5.4 Accessibility

- The app must support dynamic text sizing where practical.
- Core flows must remain usable with screen readers.
- Color alone must not be the only indicator for streak, success, or error states.

### 5.5 Localization and region-aware content

- The app must be localization-ready.
- Meal suggestions must be region-aware.
- Date, number, and currency formatting must respect locale settings.

## 6. Core flows

### 6.1 Onboarding flow

1. User opens the app and sees a short value proposition.
2. User selects the primary goal.
3. User selects the environment, which is home-only for MVP.
4. User enters physical stats.
5. User reviews consent and captures a body photo.
6. User sees the generated plan and enters the daily experience.

### 6.2 Daily workout loop

1. User opens the home dashboard and sees the daily plan.
2. User starts the workout session.
3. User completes each exercise set with timers and guidance.
4. User marks the workout as done.
5. If eligible, the app may show a between-session interstitial.
6. User sees the session summary and streak update.

## 7. Data handling and retention

- Photo retention must be configurable by policy and visible to the user.
- The app should keep only the minimum photo data required to support the current product tier.
- Deletion requests must remove the user's stored media and associated metadata according to the chosen backend implementation.

## 8. Open questions

- Should body-photo analysis run on-device with ML Kit or TFLite, or should a third-party API handle it?
- Which backend should be used for auth, database, storage, and messaging?
- Which ad network should be used?
- Should Pro streak freeze default to one per month or another cadence?
- Should photo retention be automatic deletion after a set period, user-managed retention, or a hybrid?
- Should meal suggestions be sourced from a curated dataset, external API, or manual regional catalog at MVP?
