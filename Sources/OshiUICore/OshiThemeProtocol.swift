//
//  OshiThemeProtocol.swift
//  OshiUI — Core Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI

// MARK: - Theme Protocol

/// A protocol defining the complete visual language for OshiUI components.
///
/// `OshiThemeProviding` is the foundation for the theming engine planned
/// in the v1.1.0 milestone. It defines the color palette, typography scale,
/// and spacing tokens that OshiUI components use for rendering.
///
/// All properties provide **default implementations** that match the current
/// static design tokens. This ensures zero breaking changes for existing
/// consumers while enabling theme customization in a future release.
///
/// > Note: This protocol is a **forward declaration stub**. The full
/// > theming engine — including ``EnvironmentValues`` integration and
/// > runtime theme switching — is planned for v1.1.0.
///
/// ## Future Usage (v1.1.0)
///
/// ```swift
/// struct CyberTheme: OshiThemeProviding {
///     var neonCyan: Color { Color(hue: 0.50, saturation: 0.95, brightness: 1.0) }
///     // Override only the tokens you want to customize.
///     // All other tokens fall back to the default implementation.
/// }
/// ```
public protocol OshiThemeProviding: Sendable {

    // MARK: - Neon Palette

    /// Primary accent — cyan neon.
    var neonCyan: Color { get }
    /// Secondary accent — magenta neon.
    var neonMagenta: Color { get }
    /// Tertiary accent — lime neon.
    var neonLime: Color { get }
    /// Warning accent — amber neon.
    var neonAmber: Color { get }
    /// Highlight accent — violet neon.
    var neonViolet: Color { get }
    /// Danger accent — coral neon.
    var neonCoral: Color { get }

    // MARK: - Surfaces

    /// The deepest background surface.
    var surfaceDeep: Color { get }
    /// An elevated surface for cards and containers.
    var surfaceElevated: Color { get }
    /// A floating surface for popovers and modals.
    var surfaceFloating: Color { get }

    // MARK: - Text

    /// Primary text color.
    var textPrimary: Color { get }
    /// Secondary text color.
    var textSecondary: Color { get }
    /// Tertiary text color.
    var textTertiary: Color { get }

    // MARK: - Typography

    /// The display font.
    var displayFont: Font { get }
    /// The primary title font.
    var titleFont: Font { get }
    /// The body font.
    var bodyFont: Font { get }
    /// The caption font.
    var captionFont: Font { get }

    // MARK: - Spacing

    /// Extra-small spacing token.
    var spacingXS: CGFloat { get }
    /// Small spacing token.
    var spacingSM: CGFloat { get }
    /// Medium spacing token.
    var spacingMD: CGFloat { get }
    /// Large spacing token.
    var spacingLG: CGFloat { get }
    /// Extra-large spacing token.
    var spacingXL: CGFloat { get }
}

// MARK: - Default Implementation

/// Default values matching the current OshiUI design tokens.
///
/// These defaults ensure that adopting `OshiThemeProviding` requires
/// zero overrides — consumers only customize the tokens they need.
extension OshiThemeProviding {

    // Neon Palette
    public var neonCyan: Color { OshiColor.neonCyan }
    public var neonMagenta: Color { OshiColor.neonMagenta }
    public var neonLime: Color { OshiColor.neonLime }
    public var neonAmber: Color { OshiColor.neonAmber }
    public var neonViolet: Color { OshiColor.neonViolet }
    public var neonCoral: Color { OshiColor.neonCoral }

    // Surfaces
    public var surfaceDeep: Color { OshiColor.surfaceDeep }
    public var surfaceElevated: Color { OshiColor.surfaceElevated }
    public var surfaceFloating: Color { OshiColor.surfaceFloating }

    // Text
    public var textPrimary: Color { OshiColor.textPrimary }
    public var textSecondary: Color { OshiColor.textSecondary }
    public var textTertiary: Color { OshiColor.textTertiary }

    // Typography
    public var displayFont: Font { OshiTypography.display }
    public var titleFont: Font { OshiTypography.title }
    public var bodyFont: Font { OshiTypography.body }
    public var captionFont: Font { OshiTypography.caption }

    // Spacing
    public var spacingXS: CGFloat { OshiSpacing.xs }
    public var spacingSM: CGFloat { OshiSpacing.sm }
    public var spacingMD: CGFloat { OshiSpacing.md }
    public var spacingLG: CGFloat { OshiSpacing.lg }
    public var spacingXL: CGFloat { OshiSpacing.xl }
}

// MARK: - Default Theme

/// The built-in OshiUI theme that uses the default neon cyberpunk design tokens.
///
/// This is the theme used when no custom theme is provided.
public struct OshiDefaultTheme: OshiThemeProviding {

    /// Creates the default OshiUI theme.
    public init() {}
}
