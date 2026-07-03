//
//  OshiColor.swift
//  OshiUI — Core Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI

/// The OshiUI color engine — futuristic neon-glow palettes with depth-aware luminosity.
///
/// `OshiColor` provides a curated palette of colors designed for dark-first,
/// neon-accented interfaces. Every color includes matching glow and gradient
/// variants optimized for the OshiUI aesthetic.
///
/// ## Usage
///
/// ```swift
/// Text("Neon Title")
///     .foregroundStyle(OshiColor.neonCyan)
///
/// RoundedRectangle(cornerRadius: 12)
///     .fill(OshiColor.gradient(.neonCyan, .neonMagenta))
/// ```
///
/// ## Color Categories
///
/// | Category | Purpose |
/// |----------|---------|
/// | **Neon** | Interactive accents, glows, highlights |
/// | **Surface** | Backgrounds, cards, elevated layers |
/// | **Text** | Content hierarchy with opacity scaling |
public enum OshiColor: Sendable {

    // MARK: - Neon Palette

    /// Electric cyan — primary interactive accent.
    public static let neonCyan = Color(
        hue: 0.52, saturation: 0.95, brightness: 0.95
    )

    /// Vivid magenta — secondary accent for highlights.
    public static let neonMagenta = Color(
        hue: 0.83, saturation: 0.90, brightness: 0.92
    )

    /// Acid lime — success and positive feedback.
    public static let neonLime = Color(
        hue: 0.25, saturation: 0.85, brightness: 0.90
    )

    /// Solar amber — warnings and attention.
    public static let neonAmber = Color(
        hue: 0.10, saturation: 0.90, brightness: 0.95
    )

    /// Plasma violet — premium and spatial elements.
    public static let neonViolet = Color(
        hue: 0.75, saturation: 0.80, brightness: 0.85
    )

    /// Hot coral — destructive actions and critical alerts.
    public static let neonCoral = Color(
        hue: 0.02, saturation: 0.85, brightness: 0.95
    )

    // MARK: - Surface Colors

    /// Deep obsidian — primary dark background.
    public static let surfaceDeep = Color(
        hue: 0.67, saturation: 0.15, brightness: 0.08
    )

    /// Elevated surface — cards and raised content.
    public static let surfaceElevated = Color(
        hue: 0.67, saturation: 0.12, brightness: 0.14
    )

    /// Floating surface — modals and floating panels.
    public static let surfaceFloating = Color(
        hue: 0.67, saturation: 0.10, brightness: 0.20
    )

    // MARK: - Text Colors

    /// Primary text — high contrast body content.
    public static let textPrimary = Color.white.opacity(0.95)

    /// Secondary text — reduced emphasis.
    public static let textSecondary = Color.white.opacity(0.60)

    /// Tertiary text — metadata and hints.
    public static let textTertiary = Color.white.opacity(0.35)

    // MARK: - Adaptive Surface Colors

    /// Color-scheme-adaptive deep background.
    ///
    /// Uses the standard ``surfaceDeep`` in dark mode and a light
    /// neutral surface in light mode. Prefer this over ``surfaceDeep``
    /// when your interface supports both appearances.
    public static let adaptiveSurfaceDeep = adaptiveColor(
        light: Color(hue: 0.67, saturation: 0.03, brightness: 0.96),
        dark: surfaceDeep
    )

    /// Color-scheme-adaptive elevated surface.
    ///
    /// Uses the standard ``surfaceElevated`` in dark mode and a
    /// light elevated variant in light mode.
    public static let adaptiveSurfaceElevated = adaptiveColor(
        light: Color(hue: 0.67, saturation: 0.02, brightness: 0.92),
        dark: surfaceElevated
    )

    /// Color-scheme-adaptive floating surface.
    ///
    /// Uses the standard ``surfaceFloating`` in dark mode and a
    /// light floating variant in light mode.
    public static let adaptiveSurfaceFloating = adaptiveColor(
        light: Color(hue: 0.67, saturation: 0.02, brightness: 0.88),
        dark: surfaceFloating
    )

    // MARK: - Adaptive Text Colors

    /// Color-scheme-adaptive primary text.
    public static let adaptiveTextPrimary = adaptiveColor(
        light: Color.black.opacity(0.88),
        dark: textPrimary
    )

    /// Color-scheme-adaptive secondary text.
    public static let adaptiveTextSecondary = adaptiveColor(
        light: Color.black.opacity(0.55),
        dark: textSecondary
    )

    /// Color-scheme-adaptive tertiary text.
    public static let adaptiveTextTertiary = adaptiveColor(
        light: Color.black.opacity(0.30),
        dark: textTertiary
    )

    // MARK: - Adaptive Color Factory

    /// Creates a color that adapts to the current color scheme.
    ///
    /// On iOS/visionOS uses `UIColor` dynamic provider; on macOS uses
    /// `NSColor` appearance resolution. Falls back to the dark variant
    /// on unsupported platforms.
    ///
    /// - Parameters:
    ///   - light: The color used in light appearance.
    ///   - dark: The color used in dark appearance.
    /// - Returns: A `Color` that resolves dynamically based on the system appearance.
    private static func adaptiveColor(light: Color, dark: Color) -> Color {
        #if canImport(UIKit)
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
        #elseif canImport(AppKit)
        Color(NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(dark)
                : NSColor(light)
        })
        #else
        dark
        #endif
    }


    // MARK: - Gradient Factories

    /// Creates a diagonal linear gradient between two colors.
    ///
    /// - Parameters:
    ///   - from: The starting color (top-leading).
    ///   - to: The ending color (bottom-trailing).
    /// - Returns: A `LinearGradient` from top-leading to bottom-trailing.
    public static func gradient(_ from: Color, _ to: Color) -> LinearGradient {
        LinearGradient(
            colors: [from, to],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Creates a vertical glow gradient for neon border effects.
    ///
    /// - Parameter color: The base neon color to fade.
    /// - Returns: A `LinearGradient` fading from 80% to 30% opacity.
    public static func glowGradient(_ color: Color) -> LinearGradient {
        LinearGradient(
            colors: [color.opacity(0.8), color.opacity(0.3)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Creates a radial glow effect emanating from the center.
    ///
    /// - Parameter color: The neon color for the glow.
    /// - Returns: A `RadialGradient` centered with fading opacity.
    public static func radialGlow(_ color: Color) -> RadialGradient {
        RadialGradient(
            colors: [color.opacity(0.6), color.opacity(0.0)],
            center: .center,
            startRadius: 0,
            endRadius: 120
        )
    }
}

// MARK: - ShapeStyle Extensions

extension ShapeStyle where Self == Color {

    /// OshiUI neon cyan accent color.
    public static var oshiCyan: Color { OshiColor.neonCyan }

    /// OshiUI neon magenta accent color.
    public static var oshiMagenta: Color { OshiColor.neonMagenta }

    /// OshiUI neon lime accent color.
    public static var oshiLime: Color { OshiColor.neonLime }

    /// OshiUI neon amber accent color.
    public static var oshiAmber: Color { OshiColor.neonAmber }

    /// OshiUI neon violet accent color.
    public static var oshiViolet: Color { OshiColor.neonViolet }

    /// OshiUI neon coral accent color.
    public static var oshiCoral: Color { OshiColor.neonCoral }
}

// MARK: - Previews

#Preview("OshiColor — Full Palette") {
    ScrollView {
        VStack(alignment: .leading, spacing: OshiSpacing.xl) {
            Text("Neon Palette")
                .font(OshiTypography.title3)
                .foregroundStyle(OshiColor.textPrimary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: OshiSpacing.md) {
                colorSwatch("Cyan", OshiColor.neonCyan)
                colorSwatch("Magenta", OshiColor.neonMagenta)
                colorSwatch("Lime", OshiColor.neonLime)
                colorSwatch("Amber", OshiColor.neonAmber)
                colorSwatch("Violet", OshiColor.neonViolet)
                colorSwatch("Coral", OshiColor.neonCoral)
            }

            Text("Surfaces")
                .font(OshiTypography.title3)
                .foregroundStyle(OshiColor.textPrimary)

            HStack(spacing: OshiSpacing.md) {
                colorSwatch("Deep", OshiColor.surfaceDeep)
                colorSwatch("Elevated", OshiColor.surfaceElevated)
                colorSwatch("Floating", OshiColor.surfaceFloating)
            }

            Text("Gradients")
                .font(OshiTypography.title3)
                .foregroundStyle(OshiColor.textPrimary)

            RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                .fill(OshiColor.gradient(OshiColor.neonCyan, OshiColor.neonMagenta))
                .frame(height: 60)
        }
        .padding(OshiSpacing.xl)
    }
    .background(OshiColor.surfaceDeep)
}

// MARK: - Preview Helpers

@ViewBuilder
fileprivate func colorSwatch(_ name: String, _ color: Color) -> some View {
    VStack(spacing: OshiSpacing.xs) {
        RoundedRectangle(cornerRadius: OshiSpacing.radiusSmall)
            .fill(color)
            .frame(width: 60, height: 40)
        Text(name)
            .font(OshiTypography.codeSmall)
            .foregroundStyle(OshiColor.textSecondary)
    }
}

