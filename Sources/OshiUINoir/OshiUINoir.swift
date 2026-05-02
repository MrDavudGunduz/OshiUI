//
//  OshiUINoir.swift
//  OshiUI — Noir Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUINoir
///
/// High-contrast cyberpunk aesthetics and disruptive notification systems.
///
/// `OshiUINoir` replaces boring system alerts with cinematic, edge-of-screen
/// toast capsules animated with futuristic entrance effects. Every component
/// is designed for dark backgrounds with sharp neon accents.
///
/// ## Components
///
/// - **Toast Capsules**: Futuristic notification banners that slide in from
///   screen edges with glow trails. Configurable position, duration, and haptic.
/// - **Neon-Highlighted Components**: Cards, labels, and dividers with sharp
///   edges and neon border glows on dark backgrounds.
/// - **Cyberpunk Alerts**: Full-screen modal overlays with scan-line effects
///   and glitch-style transitions.
///
/// ## Usage
///
/// ```swift
/// import OshiUINoir
///
/// // Present a futuristic toast notification
/// OshiToast("Mission Complete", icon: .checkmark, glow: .cyan)
///     .oshiToastEdge(.top)
///     .oshiToastDuration(.seconds(3))
///
/// // Neon-highlighted card
/// OshiNoirCard(accentColor: .magenta) {
///     Text("SYSTEM STATUS: ONLINE")
///         .oshiNoirText()
/// }
/// ```
///
/// ## Topics
///
/// ### Notifications
/// - ``OshiToast``
/// - ``OshiToastConfiguration``
///
/// ### Components
/// - ``OshiNoirCard``
/// - ``OshiNoirDivider``

import SwiftUI
import OshiUICore
import OshiUIKinetic

// MARK: - Module Namespace

/// The `OshiUINoir` namespace.
public enum OshiUINoir {

    /// The semantic version of the OshiUINoir module.
    public static let version = "1.0.0-alpha"
}
