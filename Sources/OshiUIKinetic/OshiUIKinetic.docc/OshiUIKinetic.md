# ``OshiUIKinetic``

Physics-driven motion and tactile feedback for interactive components.

@Metadata {
    @DisplayName("OshiUI Kinetic")
    @SupportedLanguage(swift)
}

## Overview

`OshiUIKinetic` makes every interaction physical. Buttons push back with spring physics, shapes morph organically between states, and haptic pulses provide tactile confirmation.

The module ships with pre-tuned spring presets (`snappy`, `bouncy`, `heavy`) for a consistent motion language across your app.

```swift
import OshiUIKinetic

Button("Confirm") { submit() }
    .buttonStyle(.kineticImpact(intensity: .heavy))
```

## Topics

### Button Styles

- ``KineticImpactButtonStyle``

### Animations

- ``OshiMorphView``
- ``OshiSpringPreset``

### Haptics

- ``OshiHapticEngine``
