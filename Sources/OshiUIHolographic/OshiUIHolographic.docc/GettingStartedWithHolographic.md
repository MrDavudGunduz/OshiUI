# Getting Started with OshiUIHolographic

Create spatial depth simulations and volumetric panels for immersive UI.

@Metadata {
    @PageKind(article)
}

## Overview

`OshiUIHolographic` brings spatial depth and holographic aesthetics to
standard SwiftUI views. Components adapt their rendering per platform
while maintaining a consistent visual identity.

## Step 1: Import the Module

```swift
import OshiUIHolographic
```

## Step 2: Holographic Canvas

``OshiHolographicCanvas`` renders content with 3D parallax depth driven
by hover position (macOS) or device motion (iOS):

```swift
OshiHolographicCanvas {
    VStack(spacing: OshiSpacing.md) {
        Image(systemName: "globe")
            .font(.system(size: 60))
            .foregroundStyle(OshiColor.neonCyan)
        Text("HOLOGRAPHIC")
            .font(OshiTypography.title2)
            .foregroundStyle(OshiColor.textPrimary)
    }
}
.frame(height: 300)
```

The canvas includes:
- Rotation clamping (±10° by default)
- Interactive spring-driven hover response
- Holographic sheen overlay
- Neon border glow on hover

## Step 3: Volumetric Panels

``OshiVolumetricPanel`` creates floating glass control surfaces with
neon accents, using ``GlassmorphismModifier`` under the hood:

```swift
OshiVolumetricPanel {
    Text("System Controls")
        .font(OshiTypography.title3)
        .foregroundStyle(OshiColor.textPrimary)
    Divider()
    HStack {
        Text("Power Level")
            .foregroundStyle(OshiColor.textSecondary)
        Spacer()
        Text("87%")
            .foregroundStyle(OshiColor.neonLime)
    }
    .font(OshiTypography.body)
}
```

## Platform Behavior

| Platform | Canvas Rendering | Panel Rendering |
|----------|-----------------|-----------------|
| **visionOS** | Full volumetric depth | Floating glass |
| **iOS** | Gyroscope parallax | Elevated glass |
| **macOS** | Hover-driven parallax | Elevated glass |

## Accessibility

- **Reduce Motion**: Parallax rotation is completely disabled. The canvas
  renders as a static panel with the glow and sheen effects intact.

## Next Steps

- Explore `OshiUISpatial` for glassmorphism and layered cards.
- Explore `OshiUICanvas` for snap grids and resizable widgets.
