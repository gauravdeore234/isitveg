# IsItVeg — UI Design Spec

> App for Indian travelers to scan food packaging abroad and instantly know if ingredients are vegetarian. Works fully offline. Target users are non-technical, traveling in unfamiliar countries, often under stress.

---

## Brand & Visual Identity

**App name:** IsItVeg  
**Tagline:** "Know what you eat. No internet needed."

### Colors

Source of truth: the Stitch design export (`stitch_isitveg_scanner`), implemented
verbatim in `lib/config/theme.dart` as `AppColors` / `AppPalette`.

| Token | Value | Usage |
|---|---|---|
| primary | `#0D631B` | Wordmark, links, outline buttons, active text |
| primary-container | `#2E7D32` | Veg verdict card, active nav pill, capture button |
| on-primary-container | `#CBFFC2` | Content on primary-container |
| primary-fixed | `#A3F69C` | Scanner recognition line |
| error | `#BA1A1A` | Non-veg verdict card, flagged dots |
| error-container / on-error-container | `#FFDAD6` / `#93000A` | "Non-Veg" badge |
| uncertain | `#F9A825` | Uncertain verdict card (text on it is `#1A1A2E`) |
| tertiary | `#774C00` | "Review Required" history label |
| background / surface | `#FCF8FF` | Page canvas (lavender-tinted, not pure white) |
| surface-container-lowest | `#FFFFFF` | Bottom nav, pack cards |
| surface-container-low | `#F5F2FF` | History cards, flagged-ingredient cards |
| surface-container | `#EFECFF` | Extracted-text panel |
| surface-container-high | `#E8E5FF` | Feature icon discs, info banner |
| surface-container-highest | `#E2E0FC` | Manual-entry textarea, "Possibly" badge |
| on-surface / on-surface-variant | `#1A1A2E` / `#40493D` | Body text |
| outline / outline-variant | `#707A6C` / `#BFCABA` | Metadata text / 1px card borders |
| Background (dark) | `#1A1A2E` | |
| Card (dark) | `#1E2A47` | |

### Typography

Inter (via `google_fonts`), weights restricted to 400 / 600 / 700.

| Style | Size / line-height | Weight | Usage |
|---|---|---|---|
| display-lg-mobile | 28 / 36 | 700 | Verdict word, onboarding wordmark |
| headline-md | 22 / 30 | 600 | Top app bar wordmark |
| title-lg | 20 / 28 | 600 | Section headers, card titles, buttons |
| body-lg | 16 / 24 | 400 | Ingredient lists, helper copy |
| body-sm | 14 / 20 | 400 | Secondary text, metadata |
| label-caps | 12 / 16 | 700, +0.05em | Chips, badges, nav labels, sizes |

### Spacing, radius & elevation

- 8px base grid: `xs 4 · base 8 · sm 12 · md 16 · lg 24 · xl 32`; 16px container margin.
- Content is centred in a 600px max-width canvas on wide screens.
- Radii: `4` badges · `8` history cards & banners · `12` cards, inputs, panels ·
  `16` verdict card · pill for every button and chip.
- Depth comes from tonal layering plus 1px `outline-variant` borders, not shadows.

### Iconography
- Material Icons (outlined style for inactive, filled for active)
- No custom illustrations needed — icons + color carry the UI

---

## Screen 1: Onboarding (first launch only)

**Purpose:** Explain the app in 5 seconds and get to the camera.

### Layout
- Full screen, centered vertically
- Large circular icon at top (green circle with a leaf/eco icon, 160×160px)
- App name "IsItVeg" in bold, green, large heading below icon
- Tagline "Know what you eat. No internet needed." in muted body text
- 3 feature rows with icon + text:
  - 📷 "Scan ingredient lists with your camera"
  - ✅ "Instantly know if food is vegetarian"
  - 📵 "Works completely offline"
- Full-width green "Get Started" button pinned near bottom (56px height, 12px radius)

### Behavior
- Shown once on first launch only
- "Get Started" → requests camera permission → goes to Scanner screen
- No skip button (the value prop is strong enough)

### Design notes
- Lots of whitespace — clean, not busy
- The green icon circle should feel like the FSSAI veg dot, but modern
- Dark mode: icon circle becomes dark green tint instead of light green

---

## Screen 2: Scanner (Home Tab)

**Purpose:** Point camera at ingredients, tap to scan. This is the default home screen.

### Layout
- Full-bleed camera preview (no safe area padding — camera fills entire screen)
- **Scanning guide overlay** centered in screen:
  - Semi-transparent dark overlay on everything OUTSIDE the guide rectangle
  - Guide rectangle: 85% screen width, 60% of that as height, positioned at ~25% from top
  - White corner brackets (not full border — just 4 corner L-shapes, ~24px long)
  - Label above rectangle: "Position ingredients label here" (white text, subtle shadow)
- **Top-right icon button:** keyboard icon (⌨) in a semi-transparent dark pill — opens manual entry
- **Bottom bar** (gradient fade from transparent to black):
  - Gallery icon + label "Gallery" — left side
  - **Capture button** — exact center (important: must be perfectly centered)
    - Outer white ring (4px border, circular)
    - Inner green filled circle
    - Scanner icon inside
    - Shows spinner when processing
  - Right side is empty (for visual balance)

### Behavior
- Tap capture → shows spinner on button → processes → navigates to Result
- Tap gallery → opens photo picker → processes → navigates to Result
- Tap keyboard icon → navigates to Manual Entry
- If no camera permission: show centered state with camera icon, explanation text, "Grant Permission" button

### Design notes
- Corner brackets should glow white — they're the user's focal point
- The "Position ingredients label here" text should be above the box, not inside it
- Bottom gradient starts at ~60% screen height
- Processing state: capture button shows circular progress indicator (white, 3px stroke)

---

## Screen 3: Result

**Purpose:** Show verdict clearly. Let user understand WHY if non-veg.

### Layout (scroll view, top to bottom)

#### Verdict Badge (top, prominent, animated in with spring scale)
- Large rounded card (20px radius), full width
- Background tinted with verdict color (light tint in light mode, dark tint in dark mode)
- Centered content:
  - Large icon (64px): ✅ check_circle for veg / ❌ cancel for non-veg / ❓ help for uncertain
  - Icon color matches verdict
  - Bold heading: "Vegetarian" / "Non-Vegetarian" / "Uncertain"
  - Sub-text for uncertain only: "Some ingredients may be animal-derived. Check flagged items below."

#### Category Chips (below badge, only if non-veg)
- Horizontal wrapping row of chips
- Each chip: small icon + label, red tinted border, red text
- Examples: "🍖 Contains Meat", "🥚 Contains Egg", "🐟 Contains Fish", "🦟 Insect-Derived"

#### Flagged Ingredients Section (collapsible cards)
- Section header: "Flagged Ingredients" in bold
- Each flagged ingredient = a card:
  - Left: colored dot (red = definite, yellow = uncertain)
  - Center: ingredient name (bold) + category in small muted text
  - Right: "Non-Veg" or "Possibly" badge in small tinted chip
  - Chevron down/up → tap to expand
  - Expanded shows: explanation paragraph + "Found as: [exact text from label]"

#### Extracted Text Section
- Section header: "Extracted Text"
- Scrollable text area with light grey background, showing raw OCR output
- Selectable text (so user can copy)

#### Bottom CTA
- Outlined "Scan Another" button (full width, 56px, green outline)

### Behavior
- Spring animation on verdict badge load (scale from 0.5 to 1.0, elastic curve)
- Every scan auto-saves to history — no manual save needed
- "Scan Another" → pop back to Scanner

### Design notes
- The verdict badge is the MOST important element — make it take up significant vertical space
- Non-veg state should feel alarming but not panicky — clear red without being aggressive
- Veg state should feel reassuring — calm green with a checkmark
- Uncertain state should feel cautionary — amber/yellow, honest about limitations

---

## Screen 4: History (History Tab)

**Purpose:** Browse past scans.

### Layout
- List of scan cards, newest first
- Each card:
  - Left: Verdict color dot/circle (green/red/yellow, 12px)
  - Center: verdict label + truncated ingredient text (1 line, ellipsis) + relative timestamp ("2 hours ago", "Yesterday")
  - Right: if image available, small thumbnail (40×40px, rounded corners)
- Swipe left to delete (with red "Delete" action revealed)

### Empty state
- Centered: history icon (outlined), "No scans yet", sub-text "Your scanned products will appear here"

### Behavior
- Tap any card → opens Result screen (read-only, no re-save)
- Swipe to delete → confirmation not needed (destructive but low-stakes)

---

## Screen 5: Manual Entry

**Purpose:** Fallback when camera can't read the label (too small, blurry, damaged).

### Layout
- Top: muted helper text "Type or paste the ingredient list below"
- Large multi-line text input filling available height (expands to fill screen)
  - Placeholder: example ingredient list
  - Green focused border (2px)
  - Light grey fill
- Bottom: full-width green "Check Ingredients" button (56px)
  - Shows "Analyzing…" with spinner while processing

### Behavior
- Submit → runs same analysis engine → navigates to Result screen
- Auto-saves to history same as camera scan

---

## Screen 6: Settings (Settings Tab)

**Purpose:** Manage downloadable language packs, view app info.

### Layout

#### Language Packs section
- Section header: "LANGUAGE PACKS" (uppercase, small, green, spaced letters)
- Yellow info banner: WiFi icon + "Download languages before you travel — they work offline after download."
- Grouped by region with grey region labels:
  - **Europe & Americas**
    - "ABC · Latin Script · Bundled · English, French, German, Spanish, Italian…" → shows "Installed" green badge, cannot remove
  - **East Asia**
    - "🇨🇳 Chinese · 4 MB" → Download button or delete button
    - "🇯🇵 Japanese · 4 MB"
    - "🇰🇷 Korean · 3 MB"
  - **South Asia**
    - "🇮🇳 Devanagari · 3 MB"
- Each non-bundled pack card:
  - While downloading: linear progress bar replaces the download button
  - Downloaded: green checkmark + "Installed" + red trash icon to remove
  - Not downloaded: outlined "Download" button

#### About section
- "How it works" row → opens bottom sheet explanation
- "About IsItVeg · Version 1.0.0" row

---

## Navigation

- Bottom navigation bar with 3 tabs:
  - **Scan** (document_scanner icon) — default home
  - **History** (history icon)
  - **Settings** (settings icon)
- Active tab: green icon + green label
- Inactive: grey icon + grey label
- No labels on some minimal designs — but keep labels here since users are non-technical

---

## Micro-interactions & Motion

| Element | Motion |
|---|---|
| Verdict badge | Spring scale in (0.5→1.0, elastic, 600ms) |
| Flagged ingredient expand | Height animate (200ms ease) |
| Capture button processing | Circular spinner replaces icon |
| Bottom nav switch | No animation (instant) |
| Language pack download | Linear progress bar fills left-to-right |

---

## Dark Mode

- Backgrounds: `#1A1A2E` (scaffold), `#1E2A47` (cards)
- Verdict tints: use 15% opacity colored overlay instead of light tint colors
- Text: white at 87% / 54% / 38% opacity for primary/secondary/disabled
- All verdict colors (green/red/yellow) remain the same — they're semantic

---

## Accessibility

- Minimum touch target: 44×44px
- Contrast: all text must pass WCAG AA (4.5:1 for body, 3:1 for large)
- The verdict badge heading should be readable at system large text sizes
- Camera overlay text has drop shadow for legibility on any background

---

## What NOT to design

- No illustrations or custom art needed — this is a utility app
- No onboarding carousel (single screen is enough)
- No loading skeletons (operations complete in <2 seconds)
- No social features, sharing, or accounts
- No success/confetti animations on veg result — keep it calm and trustworthy
