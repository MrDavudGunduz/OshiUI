//
//  OshiNeonGlowModifier.swift
//  OshiUI — Core Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI

// MARK: - Neon Glow Modifier

/// A view modifier that applies a neon glow effect around a view.
///
/// The glow is rendered as a layered shadow with configurable color,
/// radius, and intensity. Automatically respects the following
/// accessibility settings:
///
/// - **Reduce Motion**: Disables multi-layer glow, falling back to a single
///   subtle shadow for reduced visual complexity.
///
/// ```swift
/// Text("ONLINE")
///     .oshiNeonGlow(.oshiCyan, radius: 12)
///
/// // Or using the modifier directly
/// Text("STATUS")
///     .modifier(OshiNeonGlowModifier(color: .oshiCyan, radius: 12))
/// ```
public struct OshiNeonGlowModifier: ViewModifier {

    /// The glow color.
    public let color: Color

    /// The blur radius of the glow.
    public let radius: CGFloat

    /// The intensity multiplier (number of shadow layers).
    public let intensity: Int

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    /// Creates a neon glow modifier.
    ///
    /// - Parameters:
    ///   - color: The glow color. Defaults to ``OshiColor/neonCyan``.
    ///   - radius: The blur radius. Defaults to `10`.
    ///   - intensity: The number of shadow layers. Defaults to `2`.
    public init(
        color: Color = OshiColor.neonCyan,
        radius: CGFloat = 10,
        intensity: Int = 2
    ) {
        self.color = color
        self.radius = radius
        self.intensity = intensity
    }

    public func body(content: Content) -> some View {
        if reduceMotion {
            // Single subtle shadow for users who prefer reduced motion
            content
                .shadow(color: color.opacity(0.3), radius: radius / 2)
        } else {
            content
                .shadow(color: color.opacity(0.6), radius: radius / 2)
                .shadow(color: color.opacity(0.3), radius: radius)
                .shadow(
                    color: intensity > 1 ? color.opacity(0.15) : .clear,
                    radius: radius * 1.5
                )
        }
    }
}

// MARK: - View Extension

extension View {

    /// Applies a neon glow effect around the view.
    ///
    /// Automatically reduces glow intensity when the user has enabled
    /// **Reduce Motion** in accessibility settings.
    ///
    /// - Parameters:
    ///   - color: The glow color. Defaults to ``OshiColor/neonCyan``.
    ///   - radius: The blur radius. Defaults to `10`.
    /// - Returns: A view wrapped in a neon glow.
    public func oshiNeonGlow(
        _ color: Color = OshiColor.neonCyan,
        radius: CGFloat = 10
    ) -> some View {
        modifier(OshiNeonGlowModifier(color: color, radius: radius))
    }
}
