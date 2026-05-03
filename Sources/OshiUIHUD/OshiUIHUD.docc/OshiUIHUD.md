# ``OshiUIHUD``

Dashboard panels, kinetic progress indicators, and gamification components.

@Metadata {
    @DisplayName("OshiUI HUD")
    @SupportedLanguage(swift)
}

## Overview

`OshiUIHUD` visualizes data with kinetic energy. Progress bars fill with physical inertia, badges pulse with achievement glows, and radar charts render multi-axis statistics with animated transitions.

Every component includes full accessibility support with VoiceOver labels, dynamic values, and adjustable actions.

```swift
import OshiUIHUD

// Kinetic progress bar with physical momentum
OshiProgressBar(value: downloadProgress, style: .kinetic, accentColor: OshiColor.neonLime)
    .oshiProgressGlow(OshiColor.neonLime)

// Animated radar chart
OshiRadarChart(
    data: [0.8, 0.6, 0.9, 0.5, 0.7],
    axes: ["ATK", "DEF", "SPD", "INT", "LCK"]
)

// Tier-based achievement badge with pulse glow
OshiAchievementBadge(title: "Champion", tier: .gold, isUnlocked: true)
```

## Topics

### Progress

- ``OshiProgressBar``
- ``OshiProgressStyle``

### Gamification

- ``OshiAchievementBadge``
- ``OshiAchievementTier``

### Charts

- ``OshiRadarChart``
