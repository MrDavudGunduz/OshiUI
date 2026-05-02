# ``OshiUIHUD``

Dashboard panels, kinetic progress indicators, and gamification components.

@Metadata {
    @DisplayName("OshiUI HUD")
    @SupportedLanguage(swift)
}

## Overview

`OshiUIHUD` visualizes data with kinetic energy. Progress bars fill with physical inertia, badges pulse with achievement glows, and radar charts render multi-axis statistics with animated transitions.

```swift
import OshiUIHUD

OshiProgressBar(value: progress, style: .kinetic)
    .oshiProgressGlow(.green)

OshiRadarChart(data: stats, axes: labels)
    .oshiRadarFill(.gradient(.cyan, .purple))
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
