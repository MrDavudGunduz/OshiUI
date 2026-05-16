//
//  OshiUIHolographic.swift
//  OshiUI — Holographic Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUIHolographic
///
/// Spatial depth simulations and volumetric UI for visionOS-ready experiences.
///
/// `OshiUIHolographic` brings spatial depth and holographic aesthetics to
/// standard SwiftUI views through parallax rotation, glow effects, and
/// volumetric panel styling. On non-visionOS platforms, components gracefully
/// degrade to 2.5D representations using hover-driven and gyroscope-driven
/// parallax.
///
/// ## Components
///
/// - **Holographic Canvas**: A container that renders content with 3D parallax
///   depth effects driven by hover position (macOS) or device motion (iOS).
///   Supports rotation clamping, glow borders, and holographic sheen overlays.
/// - **Volumetric Control Panels**: Floating glass-styled control surfaces
///   with neon borders, optimized for spatial interfaces on visionOS.
///
/// ## Platform Behavior
///
/// | Platform | Rendering |
/// |----------|-----------|
/// | **visionOS** | Full volumetric with depth |
/// | **iOS** | Gyroscope-driven parallax |
/// | **macOS** | Hover-driven parallax |
///
/// ## Usage
///
/// ```swift
/// import OshiUIHolographic
///
/// // Holographic 3D canvas with parallax
/// OshiHolographicCanvas {
///     Image(systemName: "globe")
///         .font(.system(size: 60))
///         .foregroundStyle(OshiColor.neonCyan)
/// }
/// .frame(height: 300)
///
/// // Volumetric control panel
/// OshiVolumetricPanel {
///     Toggle("Shields", isOn: $shieldsActive)
///     Slider(value: $power, in: 0...100)
/// }
/// ```
///
/// ## Topics
///
/// ### 3D Content
/// - ``OshiHolographicCanvas``
///
/// ### visionOS
/// - ``OshiVolumetricPanel``

import SwiftUI
import OshiUICore
import OshiUISpatial

// MARK: - Module Namespace

/// The `OshiUIHolographic` namespace.
public enum OshiUIHolographic {

    /// The semantic version of the OshiUIHolographic module.
    public static let version = "1.0.0-alpha"
}
