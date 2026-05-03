# Changelog

All notable changes to OshiUI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

#### Infrastructure
- SPM package manifest with 8 modular targets and 1 umbrella product
- Swift 6 strict concurrency mode (`swiftLanguageModes: [.v6]`)
- Multi-platform support: iOS 18+, macOS 15+, visionOS 2+
- Apple Privacy Manifest (`PrivacyInfo.xcprivacy`)
- SwiftLint configuration with 25+ opt-in rules
- GitHub Actions CI pipeline (iOS, macOS, visionOS matrix + SwiftLint)
- Professional documentation suite: README, CONTRIBUTING, CHANGELOG, LICENSE

#### OshiUICore — Phase 1: Atomic Foundation
- `OshiColor`: Neon-glow color engine with 6 neon, 3 surface, and 3 text tokens
- `OshiColor.gradient(_:_:)`: Diagonal linear gradient factory
- `OshiColor.glowGradient(_:)`: Vertical glow gradient for border effects
- `OshiColor.radialGlow(_:)`: Radial glow emanation effect
- `ShapeStyle` extensions: `.oshiCyan`, `.oshiMagenta`, `.oshiLime`, `.oshiAmber`, `.oshiViolet`
- `OshiTypography`: 11-token type scale with Dynamic Type and accessibility support
- `OshiSpacing`: 8-point grid spacing system with corner radius presets
- `OshiPlatform`: Compile-time platform detection and capability queries
- `OshiNeonGlowModifier`: Layered shadow-based neon glow effect
- `.oshiNeonGlow(_:radius:)`: Convenience View modifier
- `.oshiText(_:color:)`: Combined font + foreground style modifier
- DocC catalog with "Getting Started" and "Design Token Guide" articles
- Full SwiftUI Preview catalog for color palette exploration

#### OshiUISpatial — Phase 2: Depth & Volume
- `GlassmorphismModifier`: Frosted glass effect with `accessibilityReduceTransparency` support
- `.oshiGlassmorphism(blur:tint:borderOpacity:cornerRadius:)`: Convenience modifier
- `OshiLayeredCard`: 3D parallax card with `.shallow`, `.standard`, `.deep` depth levels
- `OshiVolumetricButtonStyle`: Z-axis depth button with press-down physics
- `OshiVolumetricButton`: Convenience wrapper for volumetric button style
- `.oshiVolumetric(color:)`: Static `ButtonStyle` extension

#### OshiUIKinetic — Phase 2: Physics & Motion
- `KineticImpactButtonStyle`: Spring physics button with haptic feedback on press
- `.kineticImpact(intensity:accentColor:)`: Static `ButtonStyle` extension
- `OshiHapticEngine`: Platform-adaptive haptic engine (iOS/macOS/visionOS)
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
- `OshiProgressBar`: Kinetic progress bar with physical momentum animation
- `OshiProgressStyle`: `.standard`, `.kinetic`, `.instant` animation modes
- `.oshiProgressGlow(_:)`: Neon glow effect for progress bars
- `OshiAchievementBadge`: Tier-based achievement badge with pulse glow animation
- `OshiAchievementTier`: `.bronze`, `.silver`, `.gold`, `.platinum` tiers
- `OshiRadarChart`: Multi-axis spider chart with animated data polygon

#### OshiUIHolographic — Phase 4: Spatial Experiences
- `OshiHolographicCanvas`: 3D parallax canvas with hover-driven rotation
- `OshiVolumetricPanel`: Floating glass control panel for spatial interfaces

#### OshiUISynapse — Phase 4: AI/LLM Interfaces
- `OshiStreamingText`: High-performance token-by-token text renderer
- `OshiStreamCursorStyle`: `.pulse`, `.block`, `.none` cursor animations
- `.oshiStreamCursor(_:)`: Environment-based cursor style modifier
- `OshiThinkingParticles`: Neural-inspired particle "thinking" indicator
- `OshiThinkingStyle`: `.neural`, `.pulse`, `.spiral` visual styles
- `OshiChatView`: Role-based chat interface with async send callback
- `OshiChatMessage`: Identifiable chat message model with `.user`, `.assistant`, `.system` roles

#### OshiUICanvas — Phase 5: Flexible Workspaces
- `OshiResizableWidget`: Drag-handle resizable container with min/max constraints
- `OshiWidgetSize`: `.small`, `.medium`, `.large`, `.custom(CGFloat)` size presets
- `OshiSnapGrid`: LazyVGrid-based grid layout with configurable columns
- `OshiSnapGridProxy`: Grid intersection snap-point calculator

#### Testing
- Swift Testing suite with `@Suite` and `@Test` annotations for all 8 modules
- Design token value assertions for colors, typography, spacing
- Spring preset physics verification
- Chat message model and thinking style behavioral tests
- Widget size and snap grid proxy geometry tests

---

## [1.0.0] — TBD

### Planned
- Snapshot/visual regression testing infrastructure
- `OshiSnapGrid` drag-to-snap gesture integration
- `OshiModel3D`: RealityKit Model3D wrapper (Holographic)
- `OshiTextField`: Neon-themed text input with focus ring (Core)
- `OshiToggle`: Styled toggle with haptic feedback (Core)
- `.oshiStreamMarkdown()`: Markdown rendering for streaming text (Synapse)
- Complete DocC tutorial articles for all 8 modules
- Demo catalog application
- DocC CI generation and GitHub Pages deployment
- Code coverage enforcement (70%+ per module)
- Memory leak audit for animated components
- Performance benchmarks for Canvas rendering
- API freeze and v1.0.0 release
