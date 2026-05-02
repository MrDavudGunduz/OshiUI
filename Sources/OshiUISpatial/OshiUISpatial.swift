//
//  OshiUISpatial.swift
//  OshiUI — Spatial Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUISpatial
///
/// Depth, volume, and spatial presence for SwiftUI interfaces.
///
/// `OshiUISpatial` liberates your UI from flat design by introducing physical
/// depth and material properties. Every modifier is GPU-optimized and respects
/// the user's Reduce Transparency accessibility setting.
///
/// ## Components
///
/// - **Glassmorphism Modifier**: A performance-optimized frosted glass effect
///   with customizable blur radius, tint color, and border luminosity.
/// - **3D Layered Cards**: Cards with parallax shadow/highlight layers that
///   respond to device motion, creating a floating-in-air sensation.
/// - **Volumetric Buttons**: Z-axis depth buttons with press-down physics
///   and specular highlight shifts.
///
/// ## Usage
///
/// ```swift
/// import OshiUISpatial
///
/// // Apply glassmorphism to any view
/// Text("Hello, Depth")
///     .padding()
///     .oshiGlassmorphism(blur: 20, tint: .blue.opacity(0.1))
///
/// // Create a floating 3D card
/// OshiLayeredCard {
///     VStack {
///         Image(systemName: "cube.fill")
///         Text("Spatial Card")
///     }
/// }
/// ```
///
/// ## Performance Notes
///
/// All blur and material effects use `Material` and `visualEffect` APIs
/// where available, falling back to `blur(radius:)` only on older platforms.
/// Reduce Transparency is respected automatically.
///
/// ## Topics
///
/// ### Modifiers
/// - ``GlassmorphismModifier``
///
/// ### Views
/// - ``OshiLayeredCard``
/// - ``OshiVolumetricButton``

import SwiftUI
import OshiUICore

// MARK: - Module Namespace

/// The `OshiUISpatial` namespace.
public enum OshiUISpatial {

    /// The semantic version of the OshiUISpatial module.
    public static let version = "1.0.0-alpha"
}
