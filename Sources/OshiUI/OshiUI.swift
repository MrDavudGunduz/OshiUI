//
//  OshiUI.swift
//  OshiUI — Umbrella Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUI
///
/// The umbrella module that re-exports all OshiUI sub-modules.
///
/// Import `OshiUI` to gain access to the full component library,
/// or import individual modules for granular dependency control.
///
/// ## Usage
///
/// ```swift
/// import OshiUI
///
/// struct MyView: View {
///     var body: some View {
///         OshiButton("Get Started", style: .kineticImpact) {
///             // Action
///         }
///         .oshiGlassmorphism()
///     }
/// }
/// ```
///
/// ## Modules
///
/// | Module | Purpose |
/// |--------|---------|
/// | ``OshiUICore`` | Design tokens, color engine, typography |
/// | ``OshiUISpatial`` | Glassmorphism, 3D depth effects |
/// | ``OshiUIKinetic`` | Physics animations, haptic feedback |
/// | ``OshiUINoir`` | Cyberpunk aesthetics, toast notifications |
/// | ``OshiUIHUD`` | Progress bars, badges, radar charts |
/// | ``OshiUIHolographic`` | RealityKit bridge, volumetric UI |
/// | ``OshiUISynapse`` | AI/LLM streaming interfaces |
/// | ``OshiUICanvas`` | Snap grids, resizable widgets |

@_exported import OshiUICore
@_exported import OshiUISpatial
@_exported import OshiUIKinetic
@_exported import OshiUINoir
@_exported import OshiUIHUD
@_exported import OshiUIHolographic
@_exported import OshiUISynapse
@_exported import OshiUICanvas
