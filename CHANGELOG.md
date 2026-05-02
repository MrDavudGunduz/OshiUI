# Changelog

All notable changes to OshiUI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- SPM package manifest with 8 modular targets
- Project documentation (README, CONTRIBUTING, CHANGELOG, LICENSE)
- Apple Privacy Manifest (`PrivacyInfo.xcprivacy`)
- DocC documentation catalogs for all modules
- Module architecture: Core, Spatial, Kinetic, Noir, HUD, Holographic, Synapse, Canvas
- Swift 6 strict concurrency configuration
- Multi-platform support: iOS 18+, macOS 15+, visionOS 2+

## [1.0.0] — TBD

### Planned — Phase 1: Foundation (Weeks 1-2)
- `OshiUICore`: Neon color engine, dynamic typography system, spacing tokens
- Identifiable-first data architecture (no hardcoded indices)
- Catalog demo application

### Planned — Phase 2: Depth & Physics (Weeks 3-4)
- `OshiUISpatial`: Glassmorphism modifier, 3D layered cards, volumetric buttons
- `OshiUIKinetic`: Kinetic Impact button styles, spring physics, morphing animations

### Planned — Phase 3: Identity & Gamification (Weeks 5-6)
- `OshiUINoir`: Cyberpunk toast capsules, neon-highlighted components
- `OshiUIHUD`: Kinetic progress bars, glowing achievement badges, radar charts

### Planned — Phase 4: Spatial & AI (Weeks 7-9)
- `OshiUIHolographic`: RealityKit bridge, spatial drag-and-drop, volumetric panels
- `OshiUISynapse`: Streaming text renderer, particle thinking animations

### Planned — Phase 5: Flexible Workspaces (Weeks 10-11)
- `OshiUICanvas`: Magnetic snap grids, resizable modular widgets

### Planned — Phase 6: Polish & Release (Week 12)
- Complete DocC documentation with articles and code examples
- Memory leak audits for spatial and animated components
- Public release on Swift Package Index
