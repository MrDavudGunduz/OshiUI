# Contributing to OshiUI

Thank you for your interest in contributing to OshiUI! This document provides guidelines and information for contributors.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## Getting Started

### Prerequisites

- **Xcode 26.0+** with Swift 6.0 toolchain
- **macOS 15.0+** (Sequoia or later)
- Familiarity with SwiftUI and Swift concurrency

### Setup

```bash
# Clone the repository
git clone https://github.com/MrDavudGunduz/OshiUI.git
cd OshiUI

# Open in Xcode
open Package.swift

# — or build from the command line —
swift build
swift test
```

### Verify Your Setup

After cloning, run the full test suite to confirm everything is working:

```bash
# Build all modules
swift build --configuration debug

# Run all tests
swift test

# Lint the codebase
brew install swiftlint
swiftlint lint --strict
```

## Development Workflow

### Branch Naming

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feature/` | New features | `feature/kinetic-button-style` |
| `fix/` | Bug fixes | `fix/glassmorphism-blur-crash` |
| `refactor/` | Code improvements | `refactor/core-color-engine` |
| `docs/` | Documentation only | `docs/spatial-module-article` |
| `test/` | Test additions | `test/hud-progress-snapshots` |

### Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

feat(core): add neon glow shape style engine
fix(spatial): resolve glassmorphism blur clipping on macOS
test(kinetic): add spring physics animation snapshot tests
docs(hud): add radar chart usage article
refactor(noir): extract scan-line pattern into reusable modifier
```

**Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `build`, `ci`, `chore`, `perf`

**Scopes:** `core`, `spatial`, `kinetic`, `noir`, `hud`, `holographic`, `synapse`, `canvas`, `infra`

## Architecture Rules

These rules are **non-negotiable** across all modules:

### 1. Identifiable-First Data

All list and grid data structures must use `Identifiable` conformance. Hardcoded index-based access is **prohibited**.

```swift
// ✅ Correct
ForEach(items) { item in
    ItemRow(item: item)
}

// ❌ Forbidden — never use index-based access
ForEach(0..<items.count, id: \.self) { index in
    ItemRow(item: items[index])
}
```

### 2. Swift 6 Strict Concurrency

All public types must be `Sendable`. Use `@MainActor` for UI-bound mutable state.

```swift
// ✅ Correct — Sendable value types
public enum OshiColorToken: Sendable { ... }

// ✅ Correct — MainActor for haptic engine
@MainActor
public enum OshiHapticEngine: Sendable { ... }
```

### 3. Platform Abstractions

Never use raw `#if os()` in view code. Use the `OshiPlatform` abstraction layer in `OshiUICore`.

```swift
// ✅ Correct
if OshiPlatform.supportsHaptics {
    OshiHapticEngine.impact(.medium)
}

// ❌ Forbidden in view code
#if os(iOS)
    // platform-specific code
#endif
```

### 4. Design Token Consumption

All components must consume `OshiColor`, `OshiTypography`, and `OshiSpacing` tokens. Hardcoded colors, fonts, or spacing values are prohibited.

```swift
// ✅ Correct
.padding(OshiSpacing.lg)
.font(OshiTypography.body)
.foregroundStyle(OshiColor.textPrimary)

// ❌ Forbidden
.padding(16)
.font(.body)
.foregroundStyle(.white)
```

### 5. Accessibility Requirements

Every interactive component must include:
- `accessibilityLabel` for VoiceOver identification
- `accessibilityValue` for stateful components
- `accessibilityAddTraits` for interaction type hints
- `accessibilityHint` for non-obvious interactions
- `Reduce Transparency` fallback for blur/glass effects

```swift
// ✅ Correct
.accessibilityElement(children: .combine)
.accessibilityLabel("Achievement: \(title)")
.accessibilityValue(isUnlocked ? "Unlocked" : "Locked")
.accessibilityAddTraits(isUnlocked ? .isSelected : [])
```

### 6. Public API Documentation

Every `public` symbol must have a DocC documentation comment with at least:
- A summary line
- Parameter descriptions (if applicable)
- A code example

```swift
/// A button style that applies spring physics and haptic feedback on press.
///
/// Use `kineticImpact` for primary actions that benefit from tactile response.
///
/// ```swift
/// Button("Save") { save() }
///     .buttonStyle(.kineticImpact)
/// ```
///
/// - Parameter intensity: The haptic feedback intensity. Default is `.medium`.
public struct KineticImpactButtonStyle: ButtonStyle { ... }
```

### 7. Preview Coverage

Every view component must include at least one `#Preview` block demonstrating its default and variant states.

## Testing Requirements

### Test Framework

OshiUI uses **Swift Testing** (`import Testing`) with `@Suite` and `@Test` annotations:

```swift
@Suite("OshiUICore — Color Tokens")
struct OshiColorTests {
    @Test("Neon cyan has expected hue range")
    func cyanHue() {
        // assertions
    }
}
```

### Test Categories

| Category | Requirement | Target Coverage |
|----------|-------------|-----------------|
| **Unit tests** | All design token values, model logic | 90%+ |
| **Behavioral tests** | Interaction flows (tap, drag, hover) | All interactive components |
| **Snapshot tests** | Visual regression baselines | All view components |
| **Performance tests** | Frame budget for animated components | `OshiThinkingParticles`, `OshiRadarChart` |

### Coverage Targets

- **Per module:** 70% minimum
- **Core module:** 90% minimum
- **Overall framework:** 80% minimum

## Pull Request Process

1. Create a feature branch from `main`
2. Implement your changes following the architecture rules above
3. Add or update tests (unit + snapshot where applicable)
4. Ensure all previews render correctly
5. Update relevant DocC documentation
6. Run `swift build && swift test && swiftlint lint --strict`
7. Open a PR with a clear description of changes
8. Request review from a maintainer

### PR Checklist

- [ ] Code follows all architecture rules (Identifiable-first, token consumption, etc.)
- [ ] All public symbols have DocC documentation with code examples
- [ ] SwiftUI Previews added/updated for all view changes
- [ ] Accessibility labels, traits, and hints included
- [ ] Unit tests added with 70%+ coverage for changed code
- [ ] `swift build` passes on all platforms
- [ ] `swift test` passes
- [ ] `swiftlint lint --strict` passes
- [ ] CHANGELOG updated with changes

## Module Ownership

| Module | Primary Focus | Key Types |
|--------|---------------|-----------|
| `OshiUICore` | Design tokens, color engine, typography | `OshiColor`, `OshiTypography`, `OshiSpacing` |
| `OshiUISpatial` | Glassmorphism, 3D depth, volumetric effects | `GlassmorphismModifier`, `OshiLayeredCard` |
| `OshiUIKinetic` | Animation physics, haptics, morphing | `KineticImpactButtonStyle`, `OshiHapticEngine` |
| `OshiUINoir` | Cyberpunk aesthetic, toast notifications | `OshiNoirCard`, `OshiToast` |
| `OshiUIHUD` | Progress indicators, badges, charts | `OshiProgressBar`, `OshiAchievementBadge` |
| `OshiUIHolographic` | Spatial parallax, volumetric panels | `OshiHolographicCanvas`, `OshiVolumetricPanel` |
| `OshiUISynapse` | AI/LLM interfaces, streaming renderers | `OshiStreamingText`, `OshiChatView` |
| `OshiUICanvas` | Layout grids, resizable widgets | `OshiSnapGrid`, `OshiResizableWidget` |

## Questions?

Open a [GitHub Discussion](https://github.com/MrDavudGunduz/OshiUI/discussions) for questions, ideas, or feedback.
