# Getting Started with OshiUISpatial

Add depth, glass, and volume to your SwiftUI interfaces.

@Metadata {
    @PageKind(article)
}

## Overview

`OshiUISpatial` transforms flat interfaces into volumetric experiences. This
guide walks you through the three core components: glassmorphism, layered cards,
and volumetric buttons.

## Step 1: Import the Module

```swift
import OshiUISpatial
```

## Step 2: Apply Glassmorphism

Use ``GlassmorphismModifier`` to create frosted-glass panels. The effect
automatically falls back to a solid fill when the user enables
**Reduce Transparency**.

```swift
Text("Frosted Panel")
    .padding(OshiSpacing.xl)
    .oshiGlassmorphism(
        blur: 25,
        tint: .blue.opacity(0.1),
        borderOpacity: 0.4
    )
```

## Step 3: Create Layered Cards

``OshiLayeredCard`` adds parallax shadows and specular highlights that respond
to hover on macOS and device motion on iOS.

```swift
OshiLayeredCard(depth: .deep, accentColor: .oshiCyan) {
    VStack(spacing: OshiSpacing.md) {
        Image(systemName: "cube.fill")
            .font(.largeTitle)
            .foregroundStyle(OshiColor.neonCyan)
        Text("Floating Card")
            .font(OshiTypography.title3)
            .foregroundStyle(OshiColor.textPrimary)
    }
    .padding(OshiSpacing.xl)
}
```

Choose a ``OshiCardDepthLevel`` to control shadow intensity:

| Level | Use Case |
|-------|----------|
| `.shallow` | Subtle elevation for lists |
| `.standard` | Default card depth |
| `.deep` | Hero cards and featured content |
| `.lightweight` | High-density grids (10+ cards) |

## Step 4: Use Volumetric Buttons

``OshiVolumetricButton`` simulates a physical 3D button with press-down depth:

```swift
// Convenience wrapper
OshiVolumetricButton("Launch") {
    startMission()
}

// ButtonStyle API for custom labels
Button {
    download()
} label: {
    Label("Download", systemImage: "arrow.down.circle.fill")
}
.buttonStyle(.oshiVolumetric(color: OshiColor.neonViolet))
```

## Accessibility

- **Reduce Transparency**: Glassmorphism falls back to solid `OshiColor.surfaceElevated`.
- **Reduce Motion**: Layered cards disable hover scale; volumetric buttons disable spring overshoot.

## Next Steps

- Explore `OshiUIKinetic` for spring physics and haptic feedback.
- Explore `OshiUIHolographic` for holographic parallax canvases.
