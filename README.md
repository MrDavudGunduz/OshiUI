<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="Assets/oshiui-banner.png" />
    <source media="(prefers-color-scheme: light)" srcset="Assets/oshiui-banner.png" />
    <img src="Assets/oshiui-banner.png" alt="OshiUI — SwiftUI User Interface Library" width="100%" />
  </picture>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-F05138?style=for-the-badge&logo=swift&logoColor=white" />
  <img src="https://img.shields.io/badge/iOS-18+-000000?style=for-the-badge&logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/macOS-15+-000000?style=for-the-badge&logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/visionOS-2+-000000?style=for-the-badge&logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/SPM-Compatible-brightgreen?style=for-the-badge&logo=swift" />
</p>

<p align="center">
  <strong>推し — Your favorite UI, elevated.</strong><br/>
  <em>A futuristic, physics-driven SwiftUI component library for iOS, macOS, and visionOS.</em>
</p>

<p align="center">
  <code>Neon Glows</code> · <code>Glass Depth</code> · <code>Kinetic Haptics</code> · <code>Spatial Holograms</code> · <code>AI-Ready Interfaces</code>
</p>

---

## Overview

**OshiUI** is a modular, production-grade UI framework that transforms flat SwiftUI interfaces into immersive, physics-aware experiences. Built with Swift 6 strict concurrency, it ships as 8 independently adoptable modules — from atomic design tokens to volumetric visionOS controls.

```swift
import OshiUI

struct ContentView: View {
    var body: some View {
        OshiButton("Launch", style: .kineticImpact) {
            // Spring physics + haptic feedback, zero config
        }
        .oshiGlassmorphism()
        .oshiNeonGlow(.cyan)
    }
}
```

---

## Modules

OshiUI is organized into 8 focused modules. Import only what you need, or use the umbrella `OshiUI` product for everything.

| Module | Description | Phase |
|--------|-------------|-------|
| **`OshiUICore`** | Atomic design tokens — colors, typography, spacing with neon glow engine | 1 |
| **`OshiUISpatial`** | Glassmorphism, 3D layered cards, volumetric depth effects | 2 |
| **`OshiUIKinetic`** | Spring physics, haptic feedback, morphing flow animations | 2 |
| **`OshiUINoir`** | High-contrast cyberpunk components, futuristic toast notifications | 3 |
| **`OshiUIHUD`** | Kinetic progress bars, glowing achievement badges, radar charts | 3 |
| **`OshiUIHolographic`** | RealityKit bridge, spatial drag-and-drop, volumetric panels | 4 |
| **`OshiUISynapse`** | Streaming text renderer, particle "thinking" animations for LLMs | 4 |
| **`OshiUICanvas`** | Magnetic snap grids, resizable modular widget areas | 5 |

### Dependency Graph

```
                    ┌─────────────┐
                    │   OshiUI    │  (Umbrella)
                    └──────┬──────┘
           ┌───────────────┼───────────────┐
           │               │               │
     ┌─────┴─────┐  ┌─────┴─────┐  ┌─────┴─────┐
     │  Spatial   │  │  Kinetic  │  │   Core    │
     └─────┬─────┘  └─────┬─────┘  └───────────┘
           │               │               ▲
     ┌─────┴─────┐  ┌─────┴─────┐         │
     │Holographic│  │   Noir    │    (all depend
     │  Canvas   │  │   HUD     │     on Core)
     └───────────┘  │  Synapse  │
                    └───────────┘
```

---

## Installation

### Swift Package Manager (Recommended)

Add OshiUI to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/davudgunduz/OshiUI.git", from: "1.0.0")
]
```

Then add the desired module to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "OshiUI", package: "OshiUI"),       // Full suite
        // — or pick individual modules —
        // .product(name: "OshiUICore", package: "OshiUI"),
        // .product(name: "OshiUISpatial", package: "OshiUI"),
    ]
)
```

### Xcode

1. **File → Add Package Dependencies…**
2. Enter `https://github.com/davudgunduz/OshiUI.git`
3. Select the modules you need

---

## Requirements

| Requirement | Minimum |
|-------------|---------|
| Swift | 6.0 |
| iOS | 18.0+ |
| macOS | 15.0+ |
| visionOS | 2.0+ |
| Xcode | 26.0+ |

---

## Architecture Principles

1. **Modular by Design** — Each module is independently compilable and adoptable. No monoliths.
2. **Identifiable-First** — All list and grid data structures use dynamic `Identifiable` conformance. Hardcoded indices are architecturally prohibited.
3. **Swift 6 Concurrency** — Strict `Sendable` compliance across all public API surfaces.
4. **Platform Adaptive** — Automatic behavior adaptation across iOS, macOS, and visionOS via compile-time platform abstractions.
5. **Zero-Configuration Defaults** — Every component works beautifully out of the box while remaining deeply customizable.

---

## Documentation

Full API documentation is available via Apple DocC:

```bash
# Generate documentation locally
swift package generate-documentation --target OshiUICore
```

Each module includes:
- API reference with inline code examples
- Architecture articles explaining design decisions
- SwiftUI Preview catalog for visual exploration

---

## Contributing

We welcome contributions! Please read our [Contributing Guide](CONTRIBUTING.md) before submitting a pull request.

---

## License

OshiUI is released under the **MIT License**. See [LICENSE](LICENSE) for details.

---

<p align="center">
  <sub>Built with ♥ by <a href="https://github.com/davudgunduz">Davud Gunduz</a></sub><br/>
  <sub>推し — Because your UI deserves to be someone's favorite.</sub>
</p>
