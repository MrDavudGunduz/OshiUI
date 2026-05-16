# Contributing to OshiUI

Thank you for your interest in contributing to OshiUI! This document provides guidelines and information for contributors.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## Getting Started

### Prerequisites

- **Xcode 16.0+** with Swift 6.0 toolchain (CI uses Xcode `26.0` — see `XCODE_VERSION` in `ci.yml`)
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

# Run all tests (136 tests across 35 suites)
swift test

# Lint the codebase
brew install swiftlint
swiftlint lint --strict
```

## Development Workflow

### Branch Naming

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feature/` | New features | `feature/oshi-text-field` |
| `fix/` | Bug fixes | `fix/glassmorphism-blur-crash` |
| `refactor/` | Code improvements | `refactor/core-color-engine` |
| `docs/` | Documentation only | `docs/spatial-module-article` |
| `test/` | Test additions | `test/hud-progress-snapshots` |
| `perf/` | Performance improvements | `perf/metal-shader-glow` |

### Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

feat(core): add neon glow shape style engine
fix(spatial): resolve glassmorphism blur clipping on macOS
test(kinetic): add spring physics animation snapshot tests
docs(hud): add radar chart usage article
refactor(noir): extract scan-line pattern into reusable modifier
perf(holographic): migrate canvas to Metal shader
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

// ✅ Correct — Explicit actor isolation on closures
public let onSend: @MainActor @Sendable (String) async -> Void
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

Every component must respect system accessibility preferences. This is **non-negotiable**.

**Interactive components must include:**
- `accessibilityLabel` for VoiceOver identification
- `accessibilityValue` for stateful components
- `accessibilityAddTraits` for interaction type hints
- `accessibilityHint` for non-obvious interactions

**Animation components must check:**
- `@Environment(\.accessibilityReduceMotion)` — disable spring physics, fall back to eased or instant
- `@Environment(\.accessibilityReduceTransparency)` — disable blur/glass effects, fall back to solid fills

```swift
// ✅ Correct — Accessibility labels
.accessibilityElement(children: .combine)
.accessibilityLabel("Achievement: \(title)")
.accessibilityValue(isUnlocked ? "Unlocked" : "Locked")
.accessibilityAddTraits(isUnlocked ? .isSelected : [])

// ✅ Correct — Reduce Motion pattern (inner view for ButtonStyles)
@Environment(\.accessibilityReduceMotion) private var reduceMotion

.scaleEffect(reduceMotion ? 1.0 : (isPressed ? 0.97 : 1.0))
.animation(
    reduceMotion
        ? .easeInOut(duration: 0.15)
        : .spring(response: 0.2, dampingFraction: 0.6),
    value: isPressed
)
```

> **ButtonStyle note:** Since `ButtonStyle` cannot directly read `@Environment`, use an inner `View` struct that wraps the configuration label and reads the environment. See `OshiVolumetricButtonStyle` for the reference implementation.

### 6. Consistent API Naming

All public View extensions and ButtonStyle extensions must follow the `.oshi` prefix convention:

```swift
// ✅ Correct
.buttonStyle(.oshiVolumetric())
.buttonStyle(.oshiKineticImpact())
.oshiGlassmorphism()
.oshiNeonGlow()
.oshiStreamCursor(.pulse)

// ❌ Forbidden — missing prefix
.buttonStyle(.kineticImpact())  // Deprecated
```

### 7. Public API Documentation

Every `public` symbol must have a DocC documentation comment with at least:
- A summary line
- Parameter descriptions (if applicable)
- A code example
- Accessibility behavior notes (if the component handles Reduce Motion / Reduce Transparency)

```swift
/// A button style that applies spring physics and haptic feedback on press.
///
/// Automatically respects the **Reduce Motion** accessibility setting by
/// falling back to eased animations without scale overshoot.
///
/// ```swift
/// Button("Save") { save() }
///     .buttonStyle(.oshiKineticImpact())
/// ```
///
/// - Parameter intensity: The haptic feedback intensity. Default is `.medium`.
public struct KineticImpactButtonStyle: ButtonStyle { ... }
```

### 8. Preview Coverage

Every view component must include at least one `#Preview` block demonstrating its default and variant states.

### 9. Haptic Testing

When using `OshiHapticEngine` in new components, use `OshiHapticEngine.withProvider(_:operation:)` for safe test injection:

```swift
// ✅ Correct — scoped provider injection (safe for parallel tests)
let mock = MockHapticProvider()
OshiHapticEngine.withProvider(mock) {
    OshiHapticEngine.impact(.heavy)
    #expect(mock.impactCalls.count == 1)
}

// ⚠️ Avoid — direct provider mutation (race-prone in parallel tests)
OshiHapticEngine.provider = mock
```

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

- **Per module:** 70% minimum (enforced by CI)
- **Core module:** 90% minimum
- **Overall framework:** 80% minimum

### Current Test Stats

| Metric | Value |
|--------|-------|
| Total tests | 136 |
| Total suites | 35 |
| Modules with tests | 8/8 |
| CI coverage enforcement | ✅ Active (70% threshold) |

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
- [ ] Accessibility: VoiceOver labels, traits, and hints included
- [ ] Accessibility: Reduce Motion / Reduce Transparency fallbacks implemented where applicable
- [ ] API naming follows the `.oshi` prefix convention
- [ ] Unit tests added with 70%+ coverage for changed code
- [ ] `swift build` passes on all platforms (zero warnings)
- [ ] `swift test` passes (136+ tests)
- [ ] `swiftlint lint --strict` passes
- [ ] CHANGELOG updated with changes

## Module Ownership

| Module | Primary Focus | Key Types |
|--------|---------------|-----------|
| `OshiUICore` | Design tokens, color engine, typography | `OshiColor`, `OshiTypography`, `OshiSpacing` |
| `OshiUISpatial` | Glassmorphism, 3D depth, volumetric effects | `GlassmorphismModifier`, `OshiLayeredCard`, `OshiCardDepthLevel` |
| `OshiUIKinetic` | Animation physics, haptics, morphing | `KineticImpactButtonStyle`, `OshiHapticEngine` |
| `OshiUINoir` | Cyberpunk aesthetic, toast notifications | `OshiNoirCard`, `OshiToast` |
| `OshiUIHUD` | Progress indicators, badges, charts | `OshiProgressBar`, `OshiAchievementBadge` |
| `OshiUIHolographic` | Spatial parallax, volumetric panels | `OshiHolographicCanvas`, `OshiVolumetricPanel` |
| `OshiUISynapse` | AI/LLM interfaces, streaming renderers | `OshiStreamingText`, `OshiChatView` |
| `OshiUICanvas` | Layout grids, resizable widgets | `OshiSnapGrid`, `OshiResizableWidget` |

## Roadmap & Priorities

See our [Roadmap](ROADMAP.md) for the full plan from `v1.0.0` through `v2.0.0`. Current contribution priorities:

| Priority | Area | Difficulty |
|----------|------|------------|
| 🔴 Critical | Snapshot test infrastructure | Medium |
| 🔴 Critical | `OshiTheme` protocol design | High |
| 🟠 High | `OshiTextField` implementation | Medium |
| 🟠 High | Gallery demo app | Low–Medium |
| 🟡 Medium | Metal shader prototype | High |
| 🟢 Low | Interactive `@Previewable` previews | Low |

## Questions?

Open a [GitHub Discussion](https://github.com/MrDavudGunduz/OshiUI/discussions) for questions, ideas, or feedback.
