# ``OshiUIKinetic``

Physics-driven motion and tactile feedback for interactive components.

@Metadata {
    @DisplayName("OshiUI Kinetic")
    @SupportedLanguage(swift)
}

## Overview

`OshiUIKinetic` makes every interaction physical. Buttons push back with spring physics, shapes morph organically between states, and haptic pulses provide tactile confirmation.

The module ships with pre-tuned spring presets (`snappy`, `bouncy`, `heavy`, `gentle`) for a consistent motion language across your app.

```swift
import OshiUIKinetic

// Spring physics button with haptic feedback
Button("Confirm") { submit() }
    .buttonStyle(.kineticImpact(intensity: .heavy, accentColor: .oshiLime))

// Morphing expand/collapse view
OshiMorphView(isExpanded: $isExpanded, spring: .bouncy) {
    Label("Tap to expand", systemImage: "chevron.down")
} expanded: {
    DetailPanel()
}

// Pre-tuned spring animation presets
withAnimation(OshiSpringPreset.snappy.animation) {
    isActive.toggle()
}

// Platform-adaptive haptic feedback
OshiHapticEngine.impact(.medium)
OshiHapticEngine.notification(.success)
OshiHapticEngine.selection()
```

## Topics

### Button Styles

- ``KineticImpactButtonStyle``

### Animations

- ``OshiMorphView``
- ``OshiSpringPreset``

### Haptics

- ``OshiHapticEngine``
