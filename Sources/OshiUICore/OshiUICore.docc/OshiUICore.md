# ``OshiUICore``

The atomic design foundation powering every OshiUI component.

@Metadata {
    @DisplayName("OshiUI Core")
    @SupportedLanguage(swift)
}

## Overview

`OshiUICore` is the bedrock layer of the OshiUI design system. It defines the visual DNA — colors, typography, and spacing — that every other module inherits.

The color engine is built for futuristic aesthetics: neon glows, luminous gradients, and depth-aware `ShapeStyle` primitives that respond to the system's appearance mode.

The typography system dynamically scales with accessibility settings while preserving the OshiUI visual identity.

### Architecture: Identifiable-First

All data-driven views in OshiUI enforce `Identifiable`-based iteration. Index-based access is architecturally prohibited:

```swift
// ✅ OshiUI Standard
ForEach(items) { item in
    OshiCard(item: item)
}

// ❌ Prohibited
ForEach(0..<items.count, id: \.self) { i in ... }
```

## Topics

### Design Tokens

- ``OshiColor``
- ``OshiTypography``
- ``OshiSpacing``

### Platform

- ``OshiPlatform``

### Articles

- <doc:GettingStartedWithCore>
- <doc:DesignTokenGuide>
