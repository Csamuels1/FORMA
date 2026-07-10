# FORMA UI/UX Design System

## Design principles

- Strong hierarchy
- Minimal friction
- Visible progress
- Privacy-first interactions
- Mobile-first layout behavior

## Core components

- Primary and secondary buttons
- Text inputs and numeric steppers
- Goal selection cards
- Progress rings
- Timer component
- Set tracker rows
- Exercise detail cards
- Camera overlay guide
- Permission and consent modal
- Feed post cards
- Comment composer
- Follow button
- Streak flame indicator
- Milestone banner
- Nutrition summary cards
- Measurement entry sheet
- Ad container slots
- Empty state illustrations

## Screen inventory for MVP

- Splash and boot
- Auth entry
- Onboarding goal selection
- Onboarding environment selection
- Onboarding stats and photo consent
- Onboarding photo capture
- Onboarding plan reveal
- Home dashboard
- Daily workout session
- Session summary
- Nutrition dashboard
- Meal log entry
- Progress dashboard
- Monthly photo check-in
- Streaks summary
- Community feed
- Post detail and comments
- Profile and settings

## Navigation architecture

- Use a bottom navigation shell for the main authenticated area.
- Keep onboarding in a separate stack before the shell.
- Keep photo capture in a dedicated full-screen route with no distracting navigation chrome.
- Keep workout sessions in a focused, distraction-free stack.

## Tokens

### Spacing

- 4, 8, 12, 16, 20, 24, 32, 40

### Radius

- Small: 8
- Medium: 16
- Large: 24

### Elevation

- Use low elevation by default.
- Reserve stronger shadowing for cards and overlays only.

### Motion

- Keep transitions quick and purposeful.
- Use short staggered reveals for progress and plan reveal states.

## Flutter implementation notes

- Use Material 3 as the base framework.
- Map design tokens into a centralized theme layer.
- Keep component APIs consistent across features so workout, nutrition, and community screens feel like one system.
