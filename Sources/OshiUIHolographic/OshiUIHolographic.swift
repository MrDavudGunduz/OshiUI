//
//  OshiUIHolographic.swift
//  OshiUI — Holographic Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUIHolographic
///
/// Spatial simulations bridging RealityKit and SwiftUI for visionOS-ready experiences.
///
/// `OshiUIHolographic` makes future technologies — volumetric UI, 3D canvases,
/// and spatial interactions — as easy to use as standard SwiftUI views.
/// On non-visionOS platforms, components gracefully degrade to 2.5D representations.
///
/// ## Components
///
/// - **Futuristic 3D Canvas**: A RealityKit-bridged container that renders
///   3D content inline within SwiftUI layouts. Supports lighting, shadows,
///   and camera control.
/// - **Spatial Drag-and-Drop Containers**: Zones where users can drag 3D models
///   and reposition them in space with physics-based settling.
/// - **Volumetric Control Panels**: Floating control surfaces optimized for
///   visionOS, with gaze-responsive hover states and hand-tracking affordances.
///
/// ## Platform Behavior
///
/// | Platform | Rendering |
/// |----------|-----------|
/// | **visionOS** | Full volumetric with RealityKit |
/// | **iOS** | ARKit-backed 3D preview (camera optional) |
/// | **macOS** | SceneKit fallback with mouse interaction |
///
/// ## Usage
///
/// ```swift
/// import OshiUIHolographic
///
/// // Inline 3D canvas
/// OshiHolographicCanvas {
///     OshiModel3D(named: "spacecraft")
///         .oshiRotation(.degrees(45), axis: .y)
/// }
/// .frame(height: 300)
///
/// // Volumetric control panel (visionOS)
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
/// - ``OshiModel3D``
///
/// ### Spatial Interaction
/// - ``OshiSpatialDropZone``
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
