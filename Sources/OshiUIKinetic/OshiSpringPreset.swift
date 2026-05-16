//
//  OshiSpringPreset.swift
//  OshiUI — Kinetic Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI

/// Pre-tuned spring animation configurations for consistent motion language.
///
/// `OshiSpringPreset` provides a curated set of spring animations that
/// establish a unified motion identity across all OshiUI components.
///
/// ## Usage
///
/// ```swift
/// withAnimation(OshiSpringPreset.snappy.animation) {
///     isExpanded.toggle()
/// }
///
/// content
///     .animation(OshiSpringPreset.bouncy.animation, value: isActive)
/// ```
public enum OshiSpringPreset: String, Sendable, CaseIterable {

    /// Quick, precise motion — minimal overshoot. For UI toggles and small transitions.
    case snappy

    /// Playful, elastic motion — visible overshoot. For celebrations and reveals.
    case bouncy

    /// Weighty, deliberate motion — slow settling. For large panels and modals.
    case heavy

    /// Subtle, gentle motion — for micro-interactions and hover states.
    case gentle

    /// The SwiftUI `Animation` for this preset.
    public var animation: Animation {
        switch self {
        case .snappy:
            .spring(response: 0.3, dampingFraction: 0.8)
        case .bouncy:
            .spring(response: 0.5, dampingFraction: 0.5)
        case .heavy:
            .spring(response: 0.7, dampingFraction: 0.75)
        case .gentle:
            .spring(response: 0.4, dampingFraction: 0.9)
        }
    }

    /// The response duration in seconds.
    public var response: Double {
        switch self {
        case .snappy: 0.3
        case .bouncy: 0.5
        case .heavy: 0.7
        case .gentle: 0.4
        }
    }

    /// The damping fraction (0 = no damping, 1 = critical damping).
    public var dampingFraction: Double {
        switch self {
        case .snappy: 0.8
        case .bouncy: 0.5
        case .heavy: 0.75
        case .gentle: 0.9
        }
    }

    /// An eased fallback animation for use when **Reduce Motion** is enabled.
    ///
    /// The duration is calibrated to this preset's `response` value so that
    /// the perceived timing remains consistent even without spring overshoot.
    ///
    /// ```swift
    /// let anim = reduceMotion
    ///     ? OshiSpringPreset.snappy.reducedMotionAnimation
    ///     : OshiSpringPreset.snappy.animation
    /// ```
    public var reducedMotionAnimation: Animation {
        .easeInOut(duration: response)
    }
}
