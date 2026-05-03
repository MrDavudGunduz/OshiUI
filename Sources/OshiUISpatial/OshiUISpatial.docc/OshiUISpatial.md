# ``OshiUISpatial``

Depth, volume, and material presence for SwiftUI interfaces.

@Metadata {
    @DisplayName("OshiUI Spatial")
    @SupportedLanguage(swift)
}

## Overview

`OshiUISpatial` transforms flat interfaces into volumetric experiences. Its GPU-optimized glassmorphism, parallax-lit 3D cards, and z-axis buttons bring physical weight and presence to every screen.

All effects respect the user's **Reduce Transparency** accessibility setting, gracefully degrading to solid backgrounds when enabled.

```swift
import OshiUISpatial

// Frosted glass effect with automatic accessibility fallback
Text("Frosted Glass")
    .padding()
    .oshiGlassmorphism(blur: 20, tint: .blue.opacity(0.1))

// 3D layered card with hover parallax
OshiLayeredCard(depth: .deep, accentColor: .oshiCyan) {
    VStack {
        Image(systemName: "cube.fill")
            .font(.largeTitle)
        Text("Spatial Card")
    }
    .padding()
}

// Volumetric 3D button with press-down physics
Button("Launch") { startMission() }
    .buttonStyle(.oshiVolumetric(color: OshiColor.neonCyan))
```

## Topics

### Modifiers

- ``GlassmorphismModifier``

### Views

- ``OshiLayeredCard``
- ``OshiVolumetricButton``
- ``OshiVolumetricButtonStyle``
