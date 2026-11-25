---
name: Vice Synthwave
colors:
  surface: '#11131c'
  surface-dim: '#11131c'
  surface-bright: '#373943'
  surface-container-lowest: '#0c0e17'
  surface-container-low: '#191b25'
  surface-container: '#1d1f29'
  surface-container-high: '#282933'
  surface-container-highest: '#32343e'
  on-surface: '#e1e1ef'
  on-surface-variant: '#e3bdc5'
  inverse-surface: '#e1e1ef'
  inverse-on-surface: '#2e303a'
  outline: '#aa888f'
  outline-variant: '#5b3f46'
  surface-tint: '#ffb1c5'
  primary: '#ffb1c5'
  on-primary: '#65002f'
  primary-container: '#ff4a8e'
  on-primary-container: '#590028'
  inverse-primary: '#ba005c'
  secondary: '#d0bcff'
  on-secondary: '#3c0091'
  secondary-container: '#571bc1'
  on-secondary-container: '#c4abff'
  tertiary: '#4cd7f6'
  on-tertiary: '#003640'
  tertiary-container: '#009eb9'
  on-tertiary-container: '#002f38'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffd9e1'
  primary-fixed-dim: '#ffb1c5'
  on-primary-fixed: '#3f001b'
  on-primary-fixed-variant: '#8f0045'
  secondary-fixed: '#e9ddff'
  secondary-fixed-dim: '#d0bcff'
  on-secondary-fixed: '#23005c'
  on-secondary-fixed-variant: '#5516be'
  tertiary-fixed: '#acedff'
  tertiary-fixed-dim: '#4cd7f6'
  on-tertiary-fixed: '#001f26'
  on-tertiary-fixed-variant: '#004e5c'
  background: '#11131c'
  on-background: '#e1e1ef'
  surface-variant: '#32343e'
typography:
  display-hero:
    fontFamily: Plus Jakarta Sans
    fontSize: 36px
    fontWeight: '800'
    lineHeight: 44px
    letterSpacing: -0.03em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 26px
    letterSpacing: -0.01em
  title-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: '0'
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.01em
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.05em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system channels an electric 1980s neon synthwave atmosphere merged with ultra-sleek, premium mobile gaming utility. The visual experience is dark, immersive, cinematic, and nostalgic—evoking midnight drives along palm-lined ocean boulevards, vibrant sunsets, and retro-futuristic hedonism.

The core design style fuses **Minimal Dark Glassmorphism** with **Vibrant Neon Accentuation**:
- **Backgrounds:** Deep obsidian and nocturnal ink navy eliminate ambient glare and make high-energy neon hues pop with maximum intensity.
- **Surfaces:** Floating tinted container cards with gossamer-thin translucent strokes and subtle glow highlights.
- **Accents:** Electric magenta, laser cyan, and twilight purple deliver high-voltage focal cues without overwhelming informational clarity.
- **Geometry:** Ergonomic full-radius pill shapes for interactive triggers, contrasted against structured, gently rounded media cards.

## Colors

The color palette is calibrated for pitch-black and low-light mobile displays, delivering crisp readability alongside neon contrast.

### Palette Architecture
- **Primary (`#ff2a85` / `#ec4899`):** Hot neon magenta used for primary call-to-actions, active navigation highlights, pricing badges, and hero titles.
- **Secondary (`#8b5cf6`):** Electric synthwave violet, balancing pink intensities and serving as secondary indicators, subtle glows, and backdrop gradient stops.
- **Tertiary (`#06b6d4`):** Laser cyan, reserved for interactive sub-accents, verified badges, rating callouts, and specialized data points.
- **Neutral Dark Canvas:**
  - Base Canvas: `#0c0e17`
  - Elevated Canvas / Sub-canvas: `#10121d`
  - Surface Container Low: `#181b28`
  - Surface Container High: `#1e2235`
  - Border Glass Stroke: `rgba(255, 255, 255, 0.08)` to `rgba(255, 42, 133, 0.2)`
- **Content Neutral:**
  - High Contrast: `#ffffff` (Headlines, primary card labels)
  - Medium Contrast: `#94a3b8` (Secondary metadata, body copy)
  - Low Contrast: `#64748b` (Disabled states, placeholder labels)

## Typography

Typography relies on geometric precision and tight tracking to produce a contemporary, arcade-inspired tech aesthetic.

- **Plus Jakarta Sans** provides rounded geometry and high legibility across small mobile interfaces while preserving a punchy modern voice.
- **Hero & Title Accents:** Large display labels often employ split styling, where leading text is solid white (`#FFFFFF`) and trailing focus words take the vibrant neon primary tone (`#FF2A85`).
- **Data & Micro-Labels:** Metadata points like download size, game mode, and age ratings use capitalized or tightened small labels (`label-sm`) with medium weights to ensure immediate scanning.

## Layout & Spacing

The layout is built for fluid mobile experiences with compact, edge-conscious spacing:

- **Mobile Viewport Grid:** Fluid container layout bounded by `margin: 1rem` (16px) outer edges.
- **Vertical Hierarchy:**
  - Component stacks (e.g., list items, detail metadata rows) use `space-sm` (8px) to `space-md` (16px) separation.
  - Distinct section groups (e.g., carousel banners, horizontal chip filters, item catalogs) use `space-lg` (24px) gutters.
- **Horizontal Carousels:** Category pill chips and game thumbnail galleries bleed seamlessly across the right margin with dynamic momentum scrolling.
- **Bottom Navigation Dock:** Fixed height with safe-area inset accommodation, holding evenly spaced items with `space-xs` (4px) between icon and text label.

## Elevation & Depth

Visual hierarchy uses tonal surface layering combined with soft neon back-glows:

- **Base Layer:** Nocturnal obsidian (`#0c0e17`) serves as the foundational canvas.
- **Tier 1 (Surface Containers):** Deep navy cards (`#181b28`) delineated by a hairline perimeter border (`1px solid rgba(255, 255, 255, 0.08)`).
- **Tier 2 (Elevated & Active States):** Surfaces step up to `#1e2235` with subtle top highlights (`linear-gradient(180deg, rgba(255,255,255,0.06) 0%, rgba(255,255,255,0) 100%)`).
- **Neon Diffused Glows:** Interactive and active elements (such as selected navigation tabs, primary action buttons, and sale banners) utilize tinted drop shadows:
  - Neon Pink Glow: `0 8px 24px -4px rgba(255, 42, 133, 0.45)`
  - Ambient Soft Glow: `0 4px 16px 0 rgba(139, 92, 246, 0.25)`

## Shapes

The interface embraces a dual shape system balancing fluid ergonomics with structural content:

- **Full Pills (Round-Full):** Used across all interactive controls including filter chips, call-to-action buttons ("Buy Now"), pill badges, and search indicators. This softens the tech aesthetic and maximizes touch affordance.
- **Content Cards & Media Tiles:** Enclosed using `rounded-xl` (1.25rem / 20px) to frame key art, promotional cards, and detail spec panels cleanly.
- **Small Media Thumbnails:** Nested imagery and mini list icons use `rounded-lg` (0.75rem / 12px) to harmonize with outer containers.

## Components

### Buttons
- **Primary Neon Action:** Full pill shape (`border-radius: 9999px`), background in pure `#ff2a85` or linear gradient from `#ff2a85` to `#f43f5e`, bright white typography, and a radiant pink drop shadow.
- **Secondary Glass Action:** Dark container fill (`#181b28`), subtle border (`1px solid rgba(255, 255, 255, 0.12)`), white text, no glow until pressed.

### Chips & Filter Pills
- **Inactive:** Deep navy container (`#181b28`), neutral grey text (`#94a3b8`), soft white boundary border.
- **Active:** Full primary pink background (`#ff2a85`), crisp white text, ambient magenta shadow.

### Cards & Media Panels
- **Promotional Hero Banner:** Edge-to-edge or rounded-xl card with vibrant 80s gradient overlay (`rgba(12, 14, 23, 0.4)` to solid navy), retro typography, and carousel pagination dots below.
- **Spec / Metadata Box:** 4-column structured grid of `#181b28` rounded containers displaying micro-labels (Size, Mode, Rating, Release) in muted grey above white value titles.

### Lists & Catalog Items
- Horizontal row arrangement with thumbnail (`48px` x `48px` rounded-lg) on the left, title and price stacked vertically in the center, and a compact pill action button ("Buy now") aligned right.

### Bottom Navigation Bar
- Fixed bottom dock with translucent background (`rgba(16, 18, 29, 0.85)` + `backdrop-filter: blur(20px)`) and hairline top divider.
- Active item uses primary magenta icon, filled glow dot, and colored title label. Inactive items use muted slate (`#64748b`).