# Postpartum Recovery Tracker — Project Overview

## Problem
Postpartum recovery is medically complex and often under-monitored between provider visits. Warning signs are frequently missed or normalized by exhausted parents due to limited guidance, fragmented communication, and the lack of a simple, supportive tool to track recovery.

## Users
- Primary: postpartum birthing parent
- Secondary: doula, partner/support person, medical provider

## Vision
Support the fourth trimester with a gentle, structured daily check-in, early detection of concerning patterns, and simple, clear communication to care teams.

## Core Goals
- Track recovery metrics consistently
- Detect concerning patterns early
- Communicate clearly with providers
- Help the user feel supported and informed

---

## MVP Scope

### What the MVP Includes
- Daily Check-In (2–3 minutes)
  - Pain level (0–10)
  - Bleeding level (none/light/moderate/heavy)
  - Lochia color (rubra/serosa/alba)
  - Mood screen (1–5) + PHQ-2 style toggles
  - Temperature (optional)
  - Notes (free text)
- Event Flags
  - Quick log of concerning symptoms (e.g., heavy bleeding, chest pain, shortness of breath, severe headache, leg pain/swelling)
- Pattern Detection (Rule-based)
  - Fever ≥ 100.4°F → urgent alert
  - Heavy bleeding → urgent alert
  - Severe pain ≥ 7 for > 24h → attention alert
  - PHQ-2 positive → attention alert with supportive guidance
  - Chest pain / shortness of breath / leg pain-swelling → urgent alert
- Alerts View
  - Timeline of alerts with clear, supportive next steps
- History View
  - Recent entries and trends at a glance
- Supportive Guidance
  - “What to watch for” + “When to call” inline content
- Shareable Summary (V1)
  - Weekly text summary suitable to paste into a portal/email

### What the MVP Excludes (for now)
- Account system or cloud sync
- Provider portal or messaging
- Advanced analytics or ML
- PDF export (beyond simple text summary)
- Localization beyond English

---

## Product Principles

- Gentle, supportive tone; avoid alarm unless necessary
- Minimize input friction; default sensible values
- Make critical guidance clear and actionable
- Private by default; explicit opt-in for any sharing/export
- Accessible and inclusive (large touch targets, concise language)

---

## High-Level Architecture

- Platform: iOS (SwiftUI + SwiftData)
- Data Layer: SwiftData persistent models
  - DailyCheckIn, SymptomEvent, Alert
  - Persistable enums for bleeding/lochia/symptoms
- Rule Engine: Small, testable Swift helper that evaluates new entries and emits alerts
- UI: SwiftUI NavigationSplitView
  - Sidebar: Today’s Check-In, History, Alerts, Resources
  - Detail: Form, lists, and guidance content
- Privacy: All data stored locally; no network calls in MVP

---

## Data Model (Draft)

- DailyCheckIn
  - date: Date (start of day)
  - painScore: Int (0–10)
  - bleedingLevel: BleedingLevel (enum)
  - lochiaColor: LochiaColor (enum)
  - moodScore: Int (1–5)
  - phq2Q1: Bool
  - phq2Q2: Bool
  - temperatureF: Double?
  - notes: String?
- SymptomEvent
  - timestamp: Date
  - type: SymptomType (enum)
  - notes: String?
- Alert
  - timestamp: Date
  - level: AlertLevel (info/attention/urgent)
  - reason: String
  - resolved: Bool

Enums:
- BleedingLevel: none, light, moderate, heavy
- LochiaColor: rubra, serosa, alba
- SymptomType: chestPain, shortnessOfBreath, heavyBleeding, severeHeadache, legPainSwelling, fever, other
- AlertLevel: info, attention, urgent

---

## Rule Engine (MVP)

Evaluates each new DailyCheckIn and SymptomEvent:

- If temperatureF ≥ 100.4 → urgent alert: “Fever”
- If bleedingLevel == heavy OR symptom == heavyBleeding → urgent alert: “Heavy bleeding”
- If painScore ≥ 7 today and yesterday ≥ 7 → attention alert: “Persistent severe pain”
- If phq2Q1 || phq2Q2 → attention alert: “Mood screen positive”
- If symptom in [chestPain, shortnessOfBreath, legPainSwelling] → urgent alert

Alerts include:
- Clear reason and timestamp
- Next-step guidance (“Call your provider,” “Go to the ER,” “Self-care suggestions”)

---

## UI/UX Flow

- Onboarding (later): one screen with reassurance and privacy notice
- Today’s Check-In
  - Short form with steppers/pickers and optional fields
  - Save triggers rule evaluation → alert if needed
- Alerts
  - List of alerts with color-coding by severity
  - Tap to read recommended next steps
- History
  - List of days with badges (pain/mood/bleeding)
  - Tap a day to see details
- Resources
  - Emergency information, when to call, community resources

---

## Roadmap

### Phase 1: MVP (Weeks 1–3)
- Implement SwiftData models and migrations
- Build Today’s Check-In form
- Build Alerts list and History list
- Implement rule engine (sync, local)
- Add weekly text summary generator
- Basic accessibility pass
- Unit tests for rule engine

Deliverable: Local-only app with daily check-ins, alerts, and history.

### Phase 2: Usability & Safety (Weeks 4–6)
- Refine copy and tone with clinician review
- Add reminders/notifications for daily check-in
- Enhance history with simple charts (pain/mood over time)
- Add “Resolve alert” flow with notes
- Expand resources and emergency guidance
- More tests; stabilize persistence

### Phase 3: Sharing & Provider Communication (Weeks 7–9)
- Export weekly summary as PDF
- Optional provider share template
- Optional health integrations (if appropriate)
- Localization groundwork

### Phase 4: Intelligence & Personalization (Stretch)
- Personalized thresholds (e.g., baseline pain)
- Postpartum timeline tips
- Optional on-device insights

---

## Developer Notes

- Tech stack: SwiftUI, SwiftData, Swift Concurrency
- State management: SwiftUI state + environment + queries
- Persistence: Local-only SwiftData, model container configured in App entry
- Testing: Focus on rule engine and model logic (Swift Testing)
- Accessibility: Large tap targets, Dynamic Type, VoiceOver labels
- Security/Privacy: No network access; consider app passcode/FaceID later

---

## Example Navigation Structure 

- NavigationSplitView
  - Sidebar
    - Today’s Check-In
    - Alerts
    - History
    - Resources
  - Detail
    - Shows the corresponding view

---

## Risks and Mitigations

- Over-alerting (false positives): Tune thresholds and copy; allow user to resolve alerts
- Under-reporting: Reminders, friendly nudges, very short forms
- Emotional tone: Clinician-reviewed, supportive language; clear emergency guidance
- Privacy concerns: No network; transparent storage; future opt-in for sharing

### Ethics & Safety

- Medical disclaimer: This app is not a medical device and does not provide medical advice. It is intended for informational and support purposes only and is not a substitute for professional diagnosis, treatment, or emergency care. Always consult a qualified healthcare provider with questions about symptoms or health decisions. If you experience severe symptoms or believe you are in an emergency, call your local emergency number immediately.
- Clinical boundaries: Alerts are heuristic and may miss or over-emphasize issues. The app should not delay seeking care or override clinical judgment.
- Data stewardship: All data is stored locally in the MVP. If future versions introduce sharing, users must explicitly opt in; sharing should be transparent, revocable, and minimal to the stated purpose.
- Inclusive design: Language and guidance should be trauma-informed and inclusive of diverse postpartum experiences and care models.
- Safety copy review: Critical guidance and alerts should be reviewed with clinicians to ensure clarity and reduce harm.

---

## Success Metrics (MVP)

- Daily completion rate of check-ins
- Time-to-first alert (if applicable)
- Number of alerts acknowledged/resolved
- Qualitative feedback: “I knew when to call,” “This reduced my worry”
