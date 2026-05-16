//
//  OshiUIKinetic.swift
//  OshiUI — Kinetic Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUIKinetic
///
/// Motion, physics, and tactile feedback for interactive SwiftUI components.
///
/// `OshiUIKinetic` brings physical weight and responsiveness to every interaction.
/// Components don't just animate — they *react* with spring physics, haptic pulses,
/// and organic morphing transitions.
///
/// ## Components
///
/// - **Kinetic Impact Button Styles**: Press-responsive buttons with configurable
///   spring damping, haptic intensity, and scale physics. The button "pushes back."
/// - **Morphing Flow Animations**: Smooth shape-shifting transitions where components
///   organically transform between states without hard cuts.
/// - **Spring Physics Engine**: Reusable spring configuration presets
///   (`snappy`, `bouncy`, `heavy`) for consistent motion language.
///
/// ## Usage
///
/// ```swift
/// import OshiUIKinetic
///
/// // Kinetic Impact button — spring + haptic on press
/// Button("Save Changes") { save() }
///     .buttonStyle(.oshiKineticImpact(intensity: .heavy))
///
/// // Morphing transition between states
/// OshiMorphView(isExpanded: $isExpanded) {
///     CompactView()
/// } expanded: {
///     DetailView()
/// }
/// ```
///
/// ## Haptic Feedback
///
/// Haptic feedback automatically adapts to platform capabilities:
/// - **iOS**: `UIImpactFeedbackGenerator` with configurable intensity
/// - **macOS**: `NSHapticFeedbackManager` alignment feedback
/// - **visionOS**: Spatial haptic events (when available)
///
/// ## Topics
///
/// ### Button Styles
/// - ``KineticImpactButtonStyle``
///
/// ### Animations
/// - ``OshiMorphView``
/// - ``OshiSpringPreset``
///
/// ### Haptics
/// - ``OshiHapticEngine``

import SwiftUI
import OshiUICore

// MARK: - Module Namespace

/// The `OshiUIKinetic` namespace.
public enum OshiUIKinetic {

    /// The semantic version of the OshiUIKinetic module.
    public static let version = "1.0.0-alpha"
}
