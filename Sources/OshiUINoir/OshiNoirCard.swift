//
//  OshiNoirCard.swift
//  OshiUI — Noir Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A high-contrast cyberpunk card with sharp edges and neon border glows.
///
/// `OshiNoirCard` is designed for dark backgrounds with sharp neon accents,
/// scan-line texture overlays, and a distinctive cyberpunk aesthetic.
///
/// ## Usage
///
/// ```swift
/// OshiNoirCard(accentColor: .oshiMagenta) {
///     Text("SYSTEM STATUS: ONLINE")
///         .oshiNoirText()
/// }
/// ```
public struct OshiNoirCard<Content: View>: View {

    /// The neon accent color for the card border.
    public let accentColor: Color

    /// The card content.
    @ViewBuilder public let content: () -> Content

    /// Creates a noir-styled card.
    ///
    /// - Parameters:
    ///   - accentColor: Neon border color. Defaults to ``OshiColor/neonCyan``.
    ///   - content: The card content builder.
    public init(
        accentColor: Color = OshiColor.neonCyan,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.accentColor = accentColor
        self.content = content
    }

    public var body: some View {
        content()
            .padding(OshiSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: OshiSpacing.xs)
                    .fill(OshiColor.surfaceDeep)
                    .overlay(
                        // Scan-line effect
                        RoundedRectangle(cornerRadius: OshiSpacing.xs)
                            .fill(scanLinePattern)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: OshiSpacing.xs)
                    .stroke(accentColor.opacity(0.6), lineWidth: 1)
            )
            .overlay(alignment: .topLeading) {
                // Corner accent
                Rectangle()
                    .fill(accentColor)
                    .frame(width: 16, height: 2)
                    .offset(x: OshiSpacing.xs, y: 0)
            }
            .shadow(color: accentColor.opacity(0.2), radius: 12, y: 4)
            .accessibilityElement(children: .contain)
    }

    private var scanLinePattern: some ShapeStyle {
        LinearGradient(
            colors: [
                .white.opacity(0.02),
                .clear,
                .white.opacity(0.02),
                .clear
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Noir Divider

/// A neon-accented horizontal divider with a cyberpunk aesthetic.
///
/// ```swift
/// OshiNoirDivider(color: .oshiCyan)
/// ```
public struct OshiNoirDivider: View {

    /// The neon accent color.
    public let color: Color

    /// Creates a noir divider.
    ///
    /// - Parameter color: The accent color. Defaults to ``OshiColor/neonCyan``.
    public init(color: Color = OshiColor.neonCyan) {
        self.color = color
    }

    public var body: some View {
        HStack(spacing: OshiSpacing.sm) {
            Rectangle()
                .fill(color.opacity(0.6))
                .frame(width: 20, height: 1)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.4), color.opacity(0.05)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 0.5)
        }
        .shadow(color: color.opacity(0.3), radius: 4)
        .accessibilityHidden(true)
    }
}

// MARK: - Noir Text Modifier

extension View {

    /// Applies cyberpunk noir text styling — uppercase, tracked, neon-tinted.
    ///
    /// - Parameter color: Neon text color. Defaults to ``OshiColor/neonCyan``.
    /// - Returns: A view with noir text styling.
    public func oshiNoirText(_ color: Color = OshiColor.neonCyan) -> some View {
        self
            .font(OshiTypography.caption)
            .textCase(.uppercase)
            .tracking(2)
            .foregroundStyle(color)
    }
}

// MARK: - Previews

#Preview("Noir Card — Variants") {
    VStack(spacing: 20) {
        OshiNoirCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("SYSTEM STATUS: ONLINE")
                    .oshiNoirText()
                OshiNoirDivider()
                Text("All subsystems operational")
                    .font(OshiTypography.caption)
                    .foregroundStyle(OshiColor.textSecondary)
            }
        }

        OshiNoirCard(accentColor: OshiColor.neonMagenta) {
            Text("ALERT: BREACH DETECTED")
                .oshiNoirText(OshiColor.neonMagenta)
        }

        OshiNoirCard(accentColor: OshiColor.neonAmber) {
            Text("WARNING: LOW POWER")
                .oshiNoirText(OshiColor.neonAmber)
        }
    }
    .padding(24)
    .background(OshiColor.surfaceDeep)
}
