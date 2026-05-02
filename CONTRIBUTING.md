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
git clone https://github.com/davudgunduz/OshiUI.git
cd OshiUI

# Open in Xcode
open Package.swift

# — or build from the command line —
swift build
swift test
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
```

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

All public types must be `Sendable`. Use `@MainActor` for UI-bound types.

```swift
// ✅ Correct
@MainActor
public struct OshiButton: View { ... }

// ✅ Correct
public struct OshiColorToken: Sendable { ... }
```

### 3. Platform Abstractions

Never use raw `#if os()` in view code. Use the platform abstraction layer in `OshiUICore`.

### 4. Public API Documentation

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

## Testing Requirements

- **Unit tests** for all business logic and design token calculations
- **Snapshot tests** for every component's default state
- All tests must pass on iOS, macOS, and visionOS simulators
- Target: **90%+ code coverage** per module

## Pull Request Process

1. Create a feature branch from `main`
2. Implement your changes following the architecture rules above
3. Add or update tests (snapshot + unit)
4. Update relevant DocC documentation
5. Run `swift test` and ensure all tests pass
6. Open a PR with a clear description of changes
7. Request review from a maintainer

## Module Ownership

| Module | Primary Focus |
|--------|---------------|
| `OshiUICore` | Design tokens, color engine, typography |
| `OshiUISpatial` | Glassmorphism, 3D depth, volumetric effects |
| `OshiUIKinetic` | Animation physics, haptics, morphing |
| `OshiUINoir` | Cyberpunk aesthetic, toast notifications |
| `OshiUIHUD` | Progress indicators, badges, charts |
| `OshiUIHolographic` | RealityKit integration, spatial UI |
| `OshiUISynapse` | AI/LLM interfaces, streaming renderers |
| `OshiUICanvas` | Layout grids, resizable widgets |

## Questions?

Open a [GitHub Discussion](https://github.com/davudgunduz/OshiUI/discussions) for questions, ideas, or feedback.
