# FORMA Implementation Tracker

This tracker follows the SRS and roadmap in order. Mark items complete only when the code path exists and is wired into the app shell.

## Foundation

- [x] Create repository scaffold and docs
- [x] Add shared Flutter app shell
- [x] Add theme, routing, and layout primitives
- [x] Build responsive auth entry and onboarding shell
- [x] Build adaptive home shell

## SRS modules

### Onboarding

- [x] Goal selection
- [x] Environment selection
- [x] Stats entry
- [x] Photo consent and capture
- [x] Plan reveal

### Workout engine

- [x] Workout session state model
- [x] Exercise list with sets and rest timer
- [x] Progression logic
- [x] Session summary flow

### Nutrition

- [x] Daily target model
- [x] Meal logging
- [x] Location-aware meal suggestions

### Progress tracking

- [x] Measurement entry
- [x] Monthly photo check-ins
- [x] Progress history

### Streaks

- [x] Daily streak state
- [x] Milestone banner
- [x] Freeze availability rules

### Community

- [x] Feed shell
- [x] Post cards
- [x] Like/comment/follow interactions

### Monetization

- [x] Policy model and remote-config-ready limits
- [x] Ad placement guardrails
- [x] Subscription tier shell

### Account/Auth

- [x] Sign-in flow
- [x] Sign-out flow
- [x] Account settings

### Notifications

- [x] Reminder preferences
- [x] User-controlled toggles
- [x] Shell access

## Next structural pass

- [x] Replace remaining placeholder screens with real feature state
- [x] Add reusable empty/loading/error surfaces
- [x] Prepare local repository interfaces for offline data
