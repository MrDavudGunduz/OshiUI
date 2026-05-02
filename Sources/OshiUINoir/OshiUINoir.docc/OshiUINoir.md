# ``OshiUINoir``

High-contrast cyberpunk aesthetics and cinematic notification systems.

@Metadata {
    @DisplayName("OshiUI Noir")
    @SupportedLanguage(swift)
}

## Overview

`OshiUINoir` replaces bland system alerts with futuristic toast capsules that animate from screen edges with neon glow trails. Every component is optimized for dark backgrounds with sharp, high-contrast neon accents.

```swift
import OshiUINoir

OshiToast("ALERT: System Online", icon: .bolt, glow: .cyan)
    .oshiToastEdge(.top)
```

## Topics

### Notifications

- ``OshiToast``
- ``OshiToastConfiguration``

### Components

- ``OshiNoirCard``
- ``OshiNoirDivider``
