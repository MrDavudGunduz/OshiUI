# Getting Started with OshiUICore

Learn how to integrate OshiUI's design tokens into your SwiftUI project.

@Metadata {
    @PageKind(article)
}

## Overview

`OshiUICore` is the foundation of the OshiUI design system. Before using any
higher-level module, it's helpful to understand the design tokens that power
every component.

## Step 1: Import the Module

```swift
import OshiUICore
```

Or import the full umbrella for access to everything:

```swift
import OshiUI
```

## Step 2: Apply Colors

Use ``OshiColor`` to access the neon palette:

```swift
Text("Welcome")
    .foregroundStyle(OshiColor.neonCyan)

RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
    .fill(OshiColor.surfaceElevated)
    .overlay(
        RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
            .stroke(OshiColor.neonCyan.opacity(0.3))
    )
```

## Step 3: Use Typography

Apply consistent text styles with ``OshiTypography``:

```swift
VStack(alignment: .leading, spacing: OshiSpacing.sm) {
    Text("Section Title")
        .font(OshiTypography.title2)
    
    Text("Body content goes here.")
        .oshiText(OshiTypography.body, color: OshiColor.textSecondary)
}
```

## Step 4: Add Neon Glow

Make elements pop with the neon glow modifier:

```swift
Image(systemName: "bolt.fill")
    .font(.largeTitle)
    .foregroundStyle(OshiColor.neonCyan)
    .oshiNeonGlow(.oshiCyan, radius: 15)
```

## Step 5: Check Platform

Use ``OshiPlatform`` for platform-adaptive behavior:

```swift
if OshiPlatform.supportsHaptics {
    // Trigger haptic feedback
}

if OshiPlatform.supportsSpatial {
    // Enable volumetric content
}
```

## Next Steps

- Read <doc:DesignTokenGuide> for the complete token reference.
- Explore `OshiUISpatial` for glassmorphism and depth effects.
- Explore `OshiUIKinetic` for physics animations and haptics.
