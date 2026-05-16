# Getting Started with OshiUIHUD

Add kinetic progress bars, achievement badges, and radar charts to your dashboard.

@Metadata {
    @PageKind(article)
}

## Overview

`OshiUIHUD` provides heads-up display components that visualize data with
kinetic energy. Progress bars fill with physical momentum, badges pulse
with tier-based glows, and radar charts render stats with precision.

## Step 1: Import the Module

```swift
import OshiUIHUD
```

## Step 2: Progress Bars

``OshiProgressBar`` fills with simulated physical inertia:

```swift
OshiProgressBar(value: 0.75, style: .kinetic)
    .oshiProgressGlow(OshiColor.neonLime)
```

Choose an ``OshiProgressStyle``:

| Style | Behavior |
|-------|----------|
| `.standard` | Smooth eased animation |
| `.kinetic` | Spring physics with overshoot |
| `.instant` | No animation |

## Step 3: Achievement Badges

``OshiAchievementBadge`` renders tier-based badges with glow animations:

```swift
OshiAchievementBadge(
    title: "Champion",
    tier: .gold,
    isUnlocked: true
)
```

Available tiers: `.bronze`, `.silver`, `.gold`, `.platinum` — each with
its own color and SF Symbol icon.

## Step 4: Radar Charts

``OshiRadarChart`` displays multi-axis comparative statistics:

```swift
OshiRadarChart(
    data: [0.8, 0.6, 0.9, 0.5, 0.7],
    axes: ["ATK", "DEF", "SPD", "INT", "LCK"],
    accentColor: OshiColor.neonCyan
)
.frame(width: 280, height: 280)
```

Data values are automatically clamped to `0.0...1.0`.

## Accessibility

- **Reduce Motion**: Progress bars fall back from kinetic spring to standard
  eased animation. Achievement badge glow pulse is disabled. Radar charts
  display data immediately without spring entry animation.
- **VoiceOver**: Radar charts provide semantic value descriptions
  (e.g., "ATK: 80%, DEF: 60%"). Achievement badges announce title, tier, and
  unlock status.

## Next Steps

- Explore `OshiUIKinetic` for spring physics and haptic feedback.
- Explore `OshiUINoir` for cyberpunk card styling.
