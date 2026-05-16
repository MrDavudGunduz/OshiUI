# Getting Started with OshiUINoir

Add cyberpunk aesthetics and futuristic toast notifications to your app.

@Metadata {
    @PageKind(article)
}

## Overview

`OshiUINoir` provides high-contrast, cyberpunk-styled components designed
for dark interfaces with sharp neon accents and scan-line textures.

## Step 1: Import the Module

```swift
import OshiUINoir
```

## Step 2: Noir Cards

``OshiNoirCard`` renders content with a scan-line texture overlay and
neon border glow:

```swift
OshiNoirCard(accentColor: .oshiMagenta) {
    VStack(alignment: .leading, spacing: OshiSpacing.sm) {
        Text("ALERT: BREACH DETECTED")
            .oshiNoirText(OshiColor.neonMagenta)
        OshiNoirDivider(color: OshiColor.neonMagenta)
        Text("Sector 7-G compromised")
            .font(OshiTypography.caption)
            .foregroundStyle(OshiColor.textSecondary)
    }
}
```

Use `.oshiNoirText()` for uppercase, tracked, neon-tinted text styling.

## Step 3: Toast Notifications

Present futuristic toast banners with auto-dismiss behavior:

```swift
@State private var showToast = false

content
    .oshiToast(isPresented: $showToast) {
        OshiToast(
            "Mission Complete",
            icon: "checkmark.circle.fill",
            glow: OshiColor.neonLime
        )
    }
```

### Custom Configuration

Control the edge and duration with ``OshiToastConfiguration``:

```swift
.oshiToast(
    isPresented: $showToast,
    configuration: OshiToastConfiguration(edge: .bottom, duration: .seconds(5))
) {
    OshiToast("Saved", icon: "checkmark", glow: .oshiLime)
}
```

## Accessibility

- Toast notifications include VoiceOver labels and a "Dismiss notification"
  accessibility action.
- Noir cards use `.accessibilityElement(children: .contain)` for proper
  VoiceOver traversal.
- ``OshiNoirDivider`` is hidden from assistive technologies.

## Next Steps

- Explore `OshiUIHUD` for progress bars, achievement badges, and radar charts.
- Explore `OshiUIKinetic` for spring physics animations.
