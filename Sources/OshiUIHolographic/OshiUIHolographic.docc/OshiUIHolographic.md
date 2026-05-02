# ``OshiUIHolographic``

Spatial simulations bridging RealityKit and SwiftUI for volumetric experiences.

@Metadata {
    @DisplayName("OshiUI Holographic")
    @SupportedLanguage(swift)
}

## Overview

`OshiUIHolographic` makes volumetric visionOS controls and RealityKit 3D canvases as simple as standard SwiftUI views. On non-visionOS platforms, components degrade gracefully to 2.5D representations.

```swift
import OshiUIHolographic

OshiHolographicCanvas {
    OshiModel3D(named: "spacecraft")
        .oshiRotation(.degrees(45), axis: .y)
}
```

## Topics

### 3D Content

- ``OshiHolographicCanvas``
- ``OshiModel3D``

### Spatial Interaction

- ``OshiSpatialDropZone``

### visionOS

- ``OshiVolumetricPanel``
