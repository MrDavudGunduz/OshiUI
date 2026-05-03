//
//  OshiTypography.swift
//  OshiUI — Core Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI

/// The OshiUI typography system — dynamic type scales that respect accessibility.
///
/// `OshiTypography` provides a structured type scale built on top of Apple's
/// Dynamic Type system. Every style automatically adapts to the user's preferred
/// content size while maintaining the OshiUI visual identity.
///
/// ## Usage
///
/// ```swift
/// Text("Headline")
///     .font(OshiTypography.title)
///     .foregroundStyle(OshiColor.textPrimary)
///
/// Text("Supporting info")
///     .font(OshiTypography.caption)
///     .foregroundStyle(OshiColor.textSecondary)
/// ```
public enum OshiTypography: Sendable {

    // MARK: - Display

    /// Large display — hero text and splash screens.
    ///
    /// Maps to `.largeTitle` with bold weight and rounded design.
    public static let display: Font = .system(
        .largeTitle, design: .rounded, weight: .bold
    )

    // MARK: - Titles

    /// Primary title — screen headers and section titles.
    public static let title: Font = .system(
        .title, design: .rounded, weight: .semibold
    )

    /// Secondary title — subsection headers.
    public static let title2: Font = .system(
        .title2, design: .rounded, weight: .semibold
    )

    /// Tertiary title — card headers and list group titles.
    public static let title3: Font = .system(
        .title3, design: .rounded, weight: .medium
    )

    // MARK: - Body

    /// Primary body — main content text.
    public static let body: Font = .system(
        .body, design: .default, weight: .regular
    )

    /// Emphasized body — inline emphasis within body text.
    public static let bodyBold: Font = .system(
        .body, design: .default, weight: .semibold
    )

    // MARK: - Supporting

    /// Callout — supporting explanations and descriptions.
    public static let callout: Font = .system(
        .callout, design: .default, weight: .regular
    )

    /// Footnote — metadata, timestamps, and supplementary info.
    public static let footnote: Font = .system(
        .footnote, design: .default, weight: .regular
    )

    /// Caption — smallest text for labels and badges.
    public static let caption: Font = .system(
        .caption, design: .default, weight: .medium
    )

    // MARK: - Monospaced

    /// Monospaced code font — for code snippets and technical data.
    public static let code: Font = .system(
        .body, design: .monospaced, weight: .regular
    )

    /// Monospaced caption — small technical readouts.
    public static let codeSmall: Font = .system(
        .caption, design: .monospaced, weight: .regular
    )
}

// MARK: - View Extension

extension View {

    /// Applies OshiUI typography styling with automatic color hierarchy.
    ///
    /// - Parameters:
    ///   - font: The `OshiTypography` font to apply.
    ///   - color: The text color. Defaults to ``OshiColor/textPrimary``.
    /// - Returns: A view with the specified typography applied.
    public func oshiText(
        _ font: Font,
        color: Color = OshiColor.textPrimary
    ) -> some View {
        self
            .font(font)
            .foregroundStyle(color)
    }
}
