# Design Token Guide

A comprehensive reference for OshiUI's color, typography, and spacing systems.

@Metadata {
    @PageKind(article)
}

## Overview

Design tokens are the atomic values that define the OshiUI visual language.
Every component in the framework consumes these tokens, ensuring visual
consistency across your entire application.

## Color Tokens

### Neon Palette

The neon palette is designed for dark-first interfaces with high-contrast accents.

| Token | Hue | Use Case |
|-------|-----|----------|
| ``OshiColor/neonCyan`` | 187° | Primary interactive accent |
| ``OshiColor/neonMagenta`` | 299° | Secondary highlights |
| ``OshiColor/neonLime`` | 90° | Success and positive states |
| ``OshiColor/neonAmber`` | 36° | Warnings and attention |
| ``OshiColor/neonViolet`` | 270° | Premium and spatial elements |
| ``OshiColor/neonCoral`` | 7° | Destructive and critical actions |

### Surface Colors

Surfaces provide the depth hierarchy for backgrounds and containers.

| Token | Brightness | Use Case |
|-------|-----------|----------|
| ``OshiColor/surfaceDeep`` | 8% | Root backgrounds |
| ``OshiColor/surfaceElevated`` | 14% | Cards and elevated content |
| ``OshiColor/surfaceFloating`` | 20% | Modals and popovers |

### Text Colors

Text colors use opacity-based hierarchy on white for dark backgrounds.

| Token | Opacity | Use Case |
|-------|---------|----------|
| ``OshiColor/textPrimary`` | 95% | Headlines and body |
| ``OshiColor/textSecondary`` | 60% | Supporting text |
| ``OshiColor/textTertiary`` | 35% | Metadata and hints |

## Typography Tokens

All typography tokens use Apple's Dynamic Type system with the SF Pro
font family. Sizes automatically adapt to the user's accessibility settings.

| Token | Style | Weight | Design |
|-------|-------|--------|--------|
| ``OshiTypography/display`` | Large Title | Bold | Rounded |
| ``OshiTypography/title`` | Title | Semibold | Rounded |
| ``OshiTypography/title2`` | Title 2 | Semibold | Rounded |
| ``OshiTypography/title3`` | Title 3 | Medium | Rounded |
| ``OshiTypography/body`` | Body | Regular | Default |
| ``OshiTypography/bodyBold`` | Body | Semibold | Default |
| ``OshiTypography/callout`` | Callout | Regular | Default |
| ``OshiTypography/footnote`` | Footnote | Regular | Default |
| ``OshiTypography/caption`` | Caption | Medium | Default |
| ``OshiTypography/code`` | Body | Regular | Monospaced |
| ``OshiTypography/codeSmall`` | Caption | Regular | Monospaced |

## Spacing Tokens

Spacing follows an 8-point grid system for consistent rhythm.

| Token | Value | Use Case |
|-------|-------|----------|
| ``OshiSpacing/xxs`` | 2pt | Hairline gaps |
| ``OshiSpacing/xs`` | 4pt | Tight spacing |
| ``OshiSpacing/sm`` | 8pt | Compact layouts |
| ``OshiSpacing/md`` | 12pt | Default content spacing |
| ``OshiSpacing/lg`` | 16pt | Section padding |
| ``OshiSpacing/xl`` | 24pt | Card insets |
| ``OshiSpacing/xxl`` | 32pt | Major section breaks |
| ``OshiSpacing/xxxl`` | 48pt | Screen-level margins |

### Corner Radius

| Token | Value | Use Case |
|-------|-------|----------|
| ``OshiSpacing/radiusSmall`` | 8pt | Buttons and badges |
| ``OshiSpacing/radiusMedium`` | 12pt | Cards and panels |
| ``OshiSpacing/radiusLarge`` | 20pt | Modals and sheets |
| ``OshiSpacing/radiusFull`` | 9999pt | Pills and circles |
