# ``OshiUINoir``

High-contrast cyberpunk aesthetics and cinematic notification systems.

@Metadata {
    @DisplayName("OshiUI Noir")
    @SupportedLanguage(swift)
}

## Overview

`OshiUINoir` replaces bland system alerts with futuristic toast capsules that animate from screen edges with neon glow trails. Every component is optimized for dark backgrounds with sharp, high-contrast neon accents and scan-line texture overlays.

```swift
import OshiUINoir

// Cyberpunk-styled card with scan-line texture
OshiNoirCard(accentColor: .oshiMagenta) {
    Text("SYSTEM STATUS: ONLINE")
        .oshiNoirText()
}

// Futuristic toast notification
@State var showToast = false

content
    .oshiToast(isPresented: $showToast) {
        OshiToast("Mission Complete", icon: "checkmark.circle.fill", glow: .oshiLime)
    }
```

## Topics

### Notifications

- ``OshiToast``
- ``OshiToastConfiguration``

### Components

- ``OshiNoirCard``
- ``OshiNoirDivider``
