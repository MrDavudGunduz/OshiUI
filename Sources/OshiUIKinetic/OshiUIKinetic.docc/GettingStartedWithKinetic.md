# Getting Started with OshiUIKinetic

Add physics-driven motion and haptic feedback to your interactions.

@Metadata {
    @PageKind(article)
}

## Overview

`OshiUIKinetic` makes every interaction physical. Buttons push back with
spring physics, views morph between states, and haptic pulses provide
tactile confirmation. This guide covers the key components.

## Step 1: Import the Module

```swift
import OshiUIKinetic
```

## Step 2: Kinetic Impact Buttons

Apply ``KineticImpactButtonStyle`` to any `Button` for spring physics
and automatic haptic feedback on press:

```swift
Button("Save") { save() }
    .buttonStyle(.oshiKineticImpact())

// Customize intensity, color, and spring preset
Button("Delete") { delete() }
    .buttonStyle(.oshiKineticImpact(
        intensity: .heavy,
        accentColor: OshiColor.neonCoral
    ))
```

## Step 3: Spring Presets

``OshiSpringPreset`` provides four pre-tuned animation curves for
consistent motion language:

| Preset | Character | Use Case |
|--------|-----------|----------|
| `.snappy` | Quick, precise | UI toggles, small transitions |
| `.bouncy` | Playful, elastic | Celebrations, reveals |
| `.heavy` | Weighty, deliberate | Modals, large panels |
| `.gentle` | Subtle, smooth | Micro-interactions, hover |

```swift
withAnimation(OshiSpringPreset.bouncy.animation) {
    isExpanded.toggle()
}
```

## Step 4: Morph Views

``OshiMorphView`` provides organic transitions between compact and
expanded states:

```swift
OshiMorphView(isExpanded: $isOpen, spring: .bouncy) {
    Label("Tap to expand", systemImage: "chevron.down")
        .padding()
} expanded: {
    DetailPanel()
        .padding()
}
```

## Step 5: Haptic Feedback

``OshiHapticEngine`` adapts to the current platform automatically:

```swift
// Impact feedback
OshiHapticEngine.impact(.medium)

// Notification feedback
OshiHapticEngine.notification(.success)

// Selection feedback (for pickers and toggles)
OshiHapticEngine.selection()
```

### Testing Haptics

Use ``OshiHapticEngine/withProvider(_:operation:)`` for safe mock injection:

```swift
let mock = MockHapticProvider()
OshiHapticEngine.withProvider(mock) {
    OshiHapticEngine.impact(.heavy)
    #expect(mock.impactCalls.count == 1)
}
```

## Accessibility

- **Reduce Motion**: Kinetic buttons fall back to eased animations without scale
  overshoot. Morph views use simple opacity transitions.

## Next Steps

- Explore `OshiUISpatial` for glassmorphism and depth effects.
- Explore `OshiUINoir` for cyberpunk card styling and toast notifications.
