# ``OshiUIHolographic``

Spatial simulations and volumetric experiences for SwiftUI interfaces.

@Metadata {
    @DisplayName("OshiUI Holographic")
    @SupportedLanguage(swift)
}

## Overview

`OshiUIHolographic` transforms your UI into a volumetric experience with parallax-driven 3D effects and floating control panels.

On visionOS, components leverage native spatial rendering. On iOS and macOS, they degrade gracefully to 2.5D parallax representations using hover and gyroscope input.

```swift
import OshiUIHolographic

// 3D parallax canvas with hover-driven rotation
OshiHolographicCanvas {
    VStack {
        Image(systemName: "globe")
            .font(.system(size: 60))
            .foregroundStyle(OshiColor.neonCyan)
        Text("HOLOGRAPHIC")
            .font(OshiTypography.title2)
    }
}
.frame(height: 300)

// Floating glass control panel
OshiVolumetricPanel {
    Toggle("Shields", isOn: $shieldsActive)
    Slider(value: $power, in: 0...100)
}
```

## Topics

### 3D Content

- ``OshiHolographicCanvas``

### Panels

- ``OshiVolumetricPanel``
