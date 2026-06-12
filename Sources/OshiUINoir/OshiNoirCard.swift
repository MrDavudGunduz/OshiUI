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
                        // Scan-line effect — dense horizontal stripes
                        RoundedRectangle(cornerRadius: OshiSpacing.xs)
                            .fill(scanLinePattern)
                    )
                    .overlay(
                        // Inner glow — radial accent tint
                        RoundedRectangle(cornerRadius: OshiSpacing.xs)
                            .fill(
                                RadialGradient(
                                    colors: [
                                        accentColor.opacity(0.06),
                                        .clear
                                    ],
                                    center: .topLeading,
                                    startRadius: 0,
                                    endRadius: 200
                                )
                            )
                    )
            )
            .overlay(
                // Gradient neon border — bright at top, fading toward bottom
                RoundedRectangle(cornerRadius: OshiSpacing.xs)
                    .stroke(
                        LinearGradient(
                            colors: [
                                accentColor.opacity(0.7),
                                accentColor.opacity(0.2),
                                accentColor.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .overlay(alignment: .topLeading) {
                // Top-left corner accent — horizontal bar
                HStack(spacing: 3) {
                    Rectangle()
                        .fill(accentColor)
                        .frame(width: 20, height: 2)
                    Rectangle()
                        .fill(accentColor.opacity(0.4))
                        .frame(width: 6, height: 2)
                }
                .offset(x: OshiSpacing.xs, y: 0)
            }
            .overlay(alignment: .topLeading) {
                // Top-left corner accent — vertical bar
                Rectangle()
                    .fill(accentColor)
                    .frame(width: 2, height: 12)
                    .offset(x: 0, y: OshiSpacing.xs)
            }
            .overlay(alignment: .bottomTrailing) {
                // Bottom-right corner accent — mirrored
                HStack(spacing: 3) {
                    Rectangle()
                        .fill(accentColor.opacity(0.4))
                        .frame(width: 6, height: 2)
                    Rectangle()
                        .fill(accentColor.opacity(0.6))
                        .frame(width: 14, height: 2)
                }
                .offset(x: -OshiSpacing.xs, y: 0)
            }
            .shadow(color: accentColor.opacity(0.15), radius: 20, y: 8)
            .shadow(color: accentColor.opacity(0.08), radius: 4, y: 1)
            .accessibilityElement(children: .contain)
    }

    private var scanLinePattern: some ShapeStyle {
        LinearGradient(
            stops: [
                .init(color: .white.opacity(0.025), location: 0.0),
                .init(color: .clear, location: 0.02),
                .init(color: .white.opacity(0.015), location: 0.04),
                .init(color: .clear, location: 0.06),
                .init(color: .white.opacity(0.02), location: 0.08),
                .init(color: .clear, location: 0.10),
                .init(color: .white.opacity(0.015), location: 0.50),
                .init(color: .clear, location: 0.52),
                .init(color: .white.opacity(0.02), location: 1.0)
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
        HStack(spacing: OshiSpacing.xs) {
            // Leading accent dot
            Circle()
                .fill(color.opacity(0.8))
                .frame(width: 3, height: 3)
                .shadow(color: color.opacity(0.4), radius: 3)

            // Solid accent bar
            Rectangle()
                .fill(color.opacity(0.6))
                .frame(width: 20, height: 1)

            // Gradient fade line
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            color.opacity(0.4),
                            color.opacity(0.1),
                            color.opacity(0.03)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 0.5)

            // Trailing fade dot
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 2, height: 2)
        }
        .shadow(color: color.opacity(0.2), radius: 4)
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
