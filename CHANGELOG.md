# Changelog

All notable changes to OshiUI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

#### Critical Bug Fixes — Phase 7
- `OshiRadarChart`: Fixed crash when `data.count < 3` — data is now zero-padded to minimum polygon size (3 vertices), eliminating index-out-of-bounds in axis iteration
- `OshiChatView`: Fixed unreliable auto-scroll — replaced `defaultScrollAnchor(.bottom)` (initial layout only) with `ScrollViewReader` + `scrollTo` for reliable scroll-to-bottom on every new message
- `OshiResizableWidget`: Refactored drag state management — eliminated `@GestureState` + `@State` dual-tracking race condition, replaced with clean single-source-of-truth `onChanged`/`onEnded` pattern
- `README.md`: Removed unverified "120+ tokens/sec at 60fps" performance claim for `OshiStreamingText` — replaced with accurate description of animation-suppressed rendering

### Improved

#### Accessibility Hardening — Phase 7
- `OshiToastModifier`: Added `accessibilityReduceMotion` support — falls back from spring slide-in to eased opacity-only transition when Reduce Motion is enabled
- `OshiSpringPreset`: Added `reducedMotionAnimation` computed property — provides centralized eased fallback calibrated to each preset's response duration

#### Performance Optimization — Phase 7
- `OshiThinkingParticles`: Added `isActive` lifecycle guard — pauses `TimelineView(.animation)` via `onDisappear`/`onAppear` to prevent GPU usage when the view is off-screen

#### API Expansion — Phase 7
- `OshiHapticEngine`: Added async `withProvider(_:operation:)` overload for safe mock injection in async test contexts

#### Testing — Phase 7
- Expanded test suite from 136 to 148 tests across 38 suites (12 new tests, 3 new suites)
- `OshiRadarChart`: Added 5 regression tests for data padding edge cases (single value, empty, two values, 3+, body render)
- `OshiSpringPreset`: Added 2 tests for `reducedMotionAnimation` API
- `OshiHapticEngine`: Added 2 async `withProvider` injection tests
- `OshiResizableWidget`: Added 3 tests for refactored widget (default sizes, custom sizes, body render)

### Improved
- `OshiMorphView`: Respects `accessibilityReduceMotion` — falls back from spring physics to eased animation, disables scale transitions in favor of opacity-only

- `OshiNeonGlowModifier`: Respects `accessibilityReduceMotion` — falls back to single subtle shadow
- `OshiHolographicCanvas`: Disables hover-driven parallax rotation when Reduce Motion is enabled
- `OshiRadarChart`: Disables spring entry animation when Reduce Motion is enabled
- `OshiAchievementBadge`: Disables glow pulse animation when Reduce Motion is enabled
- `OshiThinkingParticles`: Full static fallback indicator when Reduce Motion is enabled
- `OshiVolumetricButtonStyle`: Disables spring overshoot and scale animation when Reduce Motion is enabled
- `KineticImpactButtonStyle`: Disables spring physics and scale reduction when Reduce Motion is enabled
- `OshiLayeredCard`: Disables hover scale animation when Reduce Motion is enabled
- `OshiProgressBar`: Falls back from kinetic spring to standard eased animation when Reduce Motion is enabled

#### API Consistency — Phase 6
- Standardized ButtonStyle naming: `.oshiKineticImpact()` is now the primary API
- Deprecated `.kineticImpact()` with migration message pointing to `.oshiKineticImpact()`
- Extracted `OshiCardDepthLevel` to top-level enum (was nested inside generic `OshiLayeredCard<Content>`)
- Added backward-compatible deprecated typealias `OshiLayeredCard.DepthLevel`
- Removed redundant `.accessibilityLabel` from `OshiVolumetricButton` convenience wrapper
- `OshiChatView.onSend` closure now explicitly typed as `@MainActor @Sendable` for clear actor isolation
- `OshiProgressStyle` now conforms to `Equatable`

#### Identifiable-First Compliance — Phase 6
- `OshiRadarChart`: Refactored all `ForEach` loops to use `Identifiable` wrapper structs (`RadarAxisIndex`, `RadarRingIndex`)
- `OshiSnapGrid` preview: Replaced index-based `ForEach` with `Identifiable` model (`PreviewGridCell`)

#### Thread Safety — Phase 6
- `OshiHapticEngine`: Added `withProvider(_:operation:)` scoped injection method for safe parallel test execution
- `OshiHapticEngine.provider`: Added documentation warning about parallel test race conditions

#### Documentation — Phase 6
- Corrected `OshiUIHolographic` module documentation: removed false RealityKit/ARKit/SceneKit claims
- Removed references to non-existent types (`OshiModel3D`, `OshiSpatialDropZone`) from DocC
- Updated umbrella module DocC table to use accurate Holographic description
- Added comprehensive DocC documentation to `OshiSnapGridProxy` with usage examples
- Added `ROADMAP.md` with v1.0.0 → v2.0.0 milestone plan

#### Documentation — Phase 6+
- Added "Getting Started" DocC tutorial articles for all 7 remaining modules: Spatial, Kinetic, Noir, HUD, Holographic, Synapse, Canvas
- Fixed stale deprecated `.kineticImpact()` API reference in `OshiUIKinetic` module documentation and DocC root page → `.oshiKineticImpact()`
- Documented intentional internal access of `OshiToastModifier` with rationale for API evolution safety

#### CI/CD Pipeline — Phase 6
- Expanded DocC CI verification to cover all 8 modules (was only Core and Spatial)
- Pinned Xcode version via `XCODE_VERSION` env variable with automatic fallback
- Fixed fragile Xcode selection that relied on filesystem sorting
- Fixed SwiftLint install syntax for reproducible CI runs
- Pinned SwiftLint version via `SWIFTLINT_VERSION` environment variable for reproducible builds
- Added coverage threshold enforcement step (minimum 70%) with automatic TOTAL line parsing
- Added SwiftLint binary caching for faster CI runs

#### CI/CD Pipeline — Phase 6+
- Hardened SwiftLint version pinning: CI now strictly validates installed version matches `SWIFTLINT_VERSION` and reinstalls on mismatch

#### Code Quality — Phase 6+
- Enforced design token consumption in `OshiColor` preview code: replaced all hardcoded padding, spacing, and corner radius values with `OshiSpacing` tokens

#### Testing — Phase 6
- Expanded test suite from ~90 to 136 tests across all 8 modules (35 suites)
- `OshiUIHolographic`: Added 9 new tests for Canvas and VolumetricPanel (init, rendering, structure)
- `OshiUINoir`: Added 10 new tests for NoirCard, NoirDivider, toast edge cases, and Sendable conformance
- `OshiUIKinetic`: Migrated mock tests to use `withProvider` scoped API, added routing and button style init tests
- `OshiUISpatial`: Added depth level max/Sendable tests, volumetric button style tests
- `OshiUIHUD`: Added progress style Equatable and custom style preservation tests
- Added `MockHapticProvider` for haptic engine dependency injection testing

### Added

#### Infrastructure
- SPM package manifest with 8 modular targets and 1 umbrella product
- Swift 6 strict concurrency mode (`swiftLanguageModes: [.v6]`)
- Multi-platform support: iOS 18+, macOS 15+, visionOS 2+
- Apple Privacy Manifest (`PrivacyInfo.xcprivacy`)
- SwiftLint configuration with 25+ opt-in rules
- GitHub Actions CI pipeline (iOS, macOS, visionOS matrix + SwiftLint + DocC)
- Professional documentation suite: README, CONTRIBUTING, CHANGELOG, ROADMAP, LICENSE

#### OshiUICore — Phase 1: Atomic Foundation
- `OshiColor`: Neon-glow color engine with 6 neon, 3 surface, and 3 text tokens
- `OshiColor.gradient(_:_:)`: Diagonal linear gradient factory
- `OshiColor.glowGradient(_:)`: Vertical glow gradient for border effects
- `OshiColor.radialGlow(_:)`: Radial glow emanation effect
- `ShapeStyle` extensions: `.oshiCyan`, `.oshiMagenta`, `.oshiLime`, `.oshiAmber`, `.oshiViolet`
- `OshiTypography`: 11-token type scale with Dynamic Type and accessibility support
- `OshiSpacing`: 8-point grid spacing system with corner radius presets
- `OshiPlatform`: Compile-time platform detection and capability queries
- `OshiNeonGlowModifier`: Layered shadow-based neon glow effect with Reduce Motion support
- `.oshiNeonGlow(_:radius:)`: Convenience View modifier
- `.oshiText(_:color:)`: Combined font + foreground style modifier
- DocC catalog with "Getting Started" and "Design Token Guide" articles
- Full SwiftUI Preview catalog for color palette exploration

#### OshiUISpatial — Phase 2: Depth & Volume
- `GlassmorphismModifier`: Frosted glass effect with `accessibilityReduceTransparency` support
- `.oshiGlassmorphism(blur:tint:borderOpacity:cornerRadius:)`: Convenience modifier
- `OshiLayeredCard`: 3D parallax card with Reduce Motion support
- `OshiCardDepthLevel`: Top-level depth enum with `.shallow`, `.standard`, `.deep`, `.lightweight` levels
- `OshiVolumetricButtonStyle`: Z-axis depth button with press-down physics and Reduce Motion fallback
- `OshiVolumetricButton`: Convenience wrapper for volumetric button style
- `.oshiVolumetric(color:)`: Static `ButtonStyle` extension

#### OshiUIKinetic — Phase 2: Physics & Motion
- `KineticImpactButtonStyle`: Spring physics button with haptic feedback and Reduce Motion fallback
- `.oshiKineticImpact(intensity:accentColor:)`: Primary static `ButtonStyle` extension
- `OshiHapticEngine`: Platform-adaptive haptic engine (iOS/macOS/visionOS) with `withProvider` scoped injection
- `OshiMorphView`: Spring-driven expand/collapse container with accessibility
- `OshiSpringPreset`: 4 pre-tuned spring animations (`.snappy`, `.bouncy`, `.heavy`, `.gentle`)

#### OshiUINoir — Phase 3: Cyberpunk Identity
- `OshiNoirCard`: High-contrast cyberpunk card with scan-line texture overlay
- `OshiNoirDivider`: Neon-accented horizontal divider
- `.oshiNoirText(_:)`: Uppercase, tracked, neon-tinted text modifier
- `OshiToast`: Futuristic toast notification capsule with neon glow
- `OshiToastConfiguration`: Edge and duration configuration for toasts
- `OshiToastModifier`: Auto-dismiss overlay with `Task.sleep` timing
- `.oshiToast(isPresented:configuration:content:)`: Toast presentation modifier

#### OshiUIHUD — Phase 3: Gamification & Dashboard
- `OshiProgressBar`: Kinetic progress bar with physical momentum animation and Reduce Motion fallback
- `OshiProgressStyle`: `.standard`, `.kinetic`, `.instant` animation modes (Equatable)
- `.oshiProgressGlow(_:)`: Neon glow effect for progress bars
- `OshiAchievementBadge`: Tier-based achievement badge with Reduce Motion–aware pulse glow
- `OshiAchievementTier`: `.bronze`, `.silver`, `.gold`, `.platinum` tiers
- `OshiRadarChart`: Multi-axis spider chart with animated data polygon and Reduce Motion support

#### OshiUIHolographic — Phase 4: Spatial Experiences
- `OshiHolographicCanvas`: 3D parallax canvas with hover-driven rotation and Reduce Motion support
- `OshiVolumetricPanel`: Floating glass control panel for spatial interfaces

#### OshiUISynapse — Phase 4: AI/LLM Interfaces
- `OshiStreamingText`: High-performance token-by-token text renderer
- `OshiStreamCursorStyle`: `.pulse`, `.block`, `.none` cursor animations
- `.oshiStreamCursor(_:)`: Environment-based cursor style modifier
- `OshiThinkingParticles`: Neural-inspired particle "thinking" indicator with Reduce Motion static fallback
- `OshiThinkingStyle`: `.neural`, `.pulse`, `.spiral` visual styles
- `OshiChatView`: Role-based chat interface with `@MainActor @Sendable` async send callback
- `OshiChatMessage`: Identifiable chat message model with `.user`, `.assistant`, `.system` roles

#### OshiUICanvas — Phase 5: Flexible Workspaces
- `OshiResizableWidget`: Drag-handle resizable container with min/max constraints and `accessibilityAdjustableAction`
- `OshiWidgetSize`: `.small`, `.medium`, `.large`, `.custom(CGFloat)` size presets
- `OshiSnapGrid`: LazyVGrid-based grid layout with configurable columns
- `OshiSnapGridProxy`: Grid intersection snap-point calculator with documentation

#### Testing
- Swift Testing suite with `@Suite` and `@Test` annotations for all 8 modules
- 136 tests across 35 suites with zero failures
- Design token value assertions for colors, typography, spacing
- Spring preset physics verification with behavioral assertions
- `MockHapticProvider` with `withProvider` scoped injection for safe parallel testing
- Chat message model and thinking style behavioral tests
- Widget size and snap grid proxy geometry tests
- Component rendering tests for Holographic, Noir, and Spatial modules

---

## [1.0.0] — TBD

> See [ROADMAP.md](ROADMAP.md) for the full v1.0.0 milestone plan.

### Planned
- Snapshot/visual regression testing infrastructure
- Performance benchmarking for animated components
- OshiUI Gallery demo application
- Interactive `@Previewable` SwiftUI previews
- Complete DocC tutorial articles for all 8 modules
- DocC CI generation and GitHub Pages deployment
- API freeze and stable release

---

## [1.1.0] — TBD

> See [ROADMAP.md](ROADMAP.md) for the full v1.1.0 milestone plan.

### Planned
- `OshiTheme` protocol — protocol-based dynamic theming engine
- `OshiMotionStyle` — global motion configuration
- Global glow intensity control via environment
- Built-in theme presets: Neon, Monochrome, Ocean, Solar

---

## [1.2.0] — TBD

> See [ROADMAP.md](ROADMAP.md) for the full v1.2.0 milestone plan.

### Planned
- `OshiTextField`: Neon-themed text input with focus ring and glitch error animation
- `OshiToggle`: Styled toggle with haptic feedback and neon glow trail
- `OshiSlider`: Physics-based slider with stepped haptic feedback
- `OshiSegmentedControl`: Neon-lit segmented picker

---

## [2.0.0] — TBD

> See [ROADMAP.md](ROADMAP.md) for the full v2.0.0 milestone plan.

### Planned
- Metal shader integration for GPU-first rendering
- Custom `ShaderLibrary` for neon glow, particles, and holographic sheen
- Canvas → Metal migration for all animated components
- Performance optimization: < 2% CPU for continuous animations
