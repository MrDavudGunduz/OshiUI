//
//  GlassmorphismModifier.swift
//  OshiUI — Spatial Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A view modifier that applies a frosted glass (glassmorphism) effect.
///
/// `GlassmorphismModifier` creates a translucent, blurred background with
/// an optional tint color and luminous border. The effect automatically
/// respects the **Reduce Transparency** accessibility setting, gracefully
/// falling back to a solid surface.
///
/// ## Usage
///
/// ```swift
/// Text("Frosted Panel")
///     .padding()
///     .oshiGlassmorphism()
///
/// // Customized glass
/// content
///     .oshiGlassmorphism(blur: 25, tint: .blue.opacity(0.1), borderOpacity: 0.4)
/// ```
public struct GlassmorphismModifier: ViewModifier {

    /// The blur radius for the frosted effect.
    public let blur: CGFloat

    /// Optional tint color overlaid on the blur.
    public let tint: Color

    /// The opacity of the luminous border.
    public let borderOpacity: Double

    /// The corner radius of the glass shape.
    public let cornerRadius: CGFloat

    @Environment(\.accessibilityReduceTransparency)
    private var reduceTransparency

    /// Creates a glassmorphism modifier.
    ///
    /// - Parameters:
    ///   - blur: Blur radius. Defaults to `20`.
    ///   - tint: Tint color overlay. Defaults to white at 5% opacity.
    ///   - borderOpacity: Border glow opacity. Defaults to `0.3`.
    ///   - cornerRadius: Corner radius. Defaults to ``OshiSpacing/radiusMedium``.
    public init(
        blur: CGFloat = 20,
        tint: Color = .white.opacity(0.05),
        borderOpacity: Double = 0.3,
        cornerRadius: CGFloat = OshiSpacing.radiusMedium
    ) {
        self.blur = blur
        self.tint = tint
        self.borderOpacity = borderOpacity
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        content
            .background {
                if reduceTransparency {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(OshiColor.surfaceElevated)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                        .blur(radius: max(0, blur - 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(tint)
                        )
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(borderOpacity),
                                .white.opacity(borderOpacity * 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - View Extension

extension View {

    /// Applies a glassmorphism (frosted glass) effect to the view.
    ///
    /// Automatically respects `accessibilityReduceTransparency`.
    ///
    /// - Parameters:
    ///   - blur: Blur radius. Defaults to `20`.
    ///   - tint: Tint color overlay. Defaults to white at 5% opacity.
    ///   - borderOpacity: Border glow opacity. Defaults to `0.3`.
    ///   - cornerRadius: Corner radius. Defaults to ``OshiSpacing/radiusMedium``.
    /// - Returns: A view with frosted glass styling.
    public func oshiGlassmorphism(
        blur: CGFloat = 20,
        tint: Color = .white.opacity(0.05),
        borderOpacity: Double = 0.3,
        cornerRadius: CGFloat = OshiSpacing.radiusMedium
    ) -> some View {
        modifier(
            GlassmorphismModifier(
                blur: blur,
                tint: tint,
                borderOpacity: borderOpacity,
                cornerRadius: cornerRadius
            )
        )
    }
}

// MARK: - Previews

#Preview("Glassmorphism — Default") {
    ZStack {
        LinearGradient(
            colors: [OshiColor.neonCyan.opacity(0.3), OshiColor.neonMagenta.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        VStack(spacing: 16) {
            Text("Frosted Glass")
                .font(OshiTypography.title2)
                .foregroundStyle(OshiColor.textPrimary)
            Text("Glassmorphism with luminous border")
                .font(OshiTypography.callout)
                .foregroundStyle(OshiColor.textSecondary)
        }
        .padding(24)
        .oshiGlassmorphism()
    }
    .frame(width: 350, height: 250)
}

#Preview("Glassmorphism — Custom Tint") {
    ZStack {
        OshiColor.surfaceDeep

        Text("Custom Glass")
            .font(OshiTypography.title3)
            .foregroundStyle(OshiColor.textPrimary)
            .padding(24)
            .oshiGlassmorphism(
                blur: 30,
                tint: OshiColor.neonViolet.opacity(0.1),
                borderOpacity: 0.5,
                cornerRadius: OshiSpacing.radiusLarge
            )
    }
    .frame(width: 350, height: 200)
}
