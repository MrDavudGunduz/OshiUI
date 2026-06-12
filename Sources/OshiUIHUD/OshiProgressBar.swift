//
//  OshiProgressBar.swift
//  OshiUI — HUD Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore
import OshiUIKinetic

/// A kinetic progress bar that fills with physical momentum and overshoot.
///
/// `OshiProgressBar` animates progress with simulated physical inertia —
/// it accelerates, decelerates, and overshoots slightly before settling.
///
/// ## Usage
///
/// ```swift
/// OshiProgressBar(value: downloadProgress, style: .kinetic)
///     .oshiProgressGlow(.oshiLime)
///
/// OshiProgressBar(value: 0.7, style: .standard, accentColor: .oshiMagenta)
/// ```
public struct OshiProgressBar: View {

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    /// The current progress value (0.0 to 1.0).
    public let value: Double

    /// The progress bar style.
    public let style: OshiProgressStyle

    /// The fill accent color.
    public let accentColor: Color

    /// Creates a progress bar.
    ///
    /// - Parameters:
    ///   - value: Progress from `0.0` to `1.0`.
    ///   - style: The progress style. Defaults to `.kinetic`.
    ///   - accentColor: Fill color. Defaults to ``OshiColor/neonCyan``.
    public init(
        value: Double,
        style: OshiProgressStyle = .kinetic,
        accentColor: Color = OshiColor.neonCyan
    ) {
        self.value = min(max(value, 0), 1)
        self.style = style
        self.accentColor = accentColor
    }

    /// Resolves the animation — falls back to `.standard` when Reduce Motion is on
    /// and the requested style is `.kinetic` (spring-based).
    private var resolvedAnimation: Animation? {
        if reduceMotion && style == .kinetic {
            return OshiProgressStyle.standard.animation
        }
        return style.animation
    }

    public var body: some View {
        GeometryReader { geometry in
            let fillWidth = geometry.size.width * value

            ZStack(alignment: .leading) {
                // Track — with inner shadow for depth
                Capsule()
                    .fill(OshiColor.surfaceElevated)
                    .overlay(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .black.opacity(0.15),
                                        .clear,
                                        .white.opacity(0.03)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )

                // Fill — vibrant gradient with specular
                if value > 0 {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    accentColor,
                                    accentColor.opacity(0.85),
                                    accentColor.opacity(0.65)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(fillWidth, 8))
                        .overlay(
                            // Top specular highlight
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(0.35),
                                            .white.opacity(0.1),
                                            .clear
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .padding(.horizontal, 2)
                                .padding(.vertical, 1)
                        )
                        .overlay(alignment: .trailing) {
                            // Glowing tip dot
                            if value < 1 && value > 0.02 {
                                Circle()
                                    .fill(.white.opacity(0.9))
                                    .frame(width: 4, height: 4)
                                    .shadow(color: accentColor, radius: 4)
                                    .shadow(color: accentColor.opacity(0.5), radius: 8)
                                    .padding(.trailing, 3)
                            }
                        }
                        .shadow(color: accentColor.opacity(0.5), radius: 6)
                        .shadow(color: accentColor.opacity(0.2), radius: 2)
                }
            }
        }
        .frame(height: 8)
        .clipShape(Capsule())
        .animation(resolvedAnimation, value: value)
        .accessibilityElement()
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(value * 100)) percent")
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Progress Style

/// The animation style for an ``OshiProgressBar``.
public enum OshiProgressStyle: Sendable, Equatable {

    /// Standard eased animation — smooth and predictable.
    case standard

    /// Kinetic physics — spring-based with slight overshoot.
    case kinetic

    /// Instant — no animation, immediate value change.
    case instant

    var animation: Animation? {
        switch self {
        case .standard: .easeInOut(duration: 0.4)
        case .kinetic: OshiSpringPreset.bouncy.animation
        case .instant: nil
        }
    }
}

// MARK: - Progress Glow Modifier

extension View {

    /// Applies a neon glow effect to a progress bar.
    ///
    /// - Parameter color: The glow color.
    /// - Returns: A view with a progress glow effect.
    public func oshiProgressGlow(_ color: Color) -> some View {
        self.shadow(color: color.opacity(0.3), radius: 8)
    }
}

// MARK: - Previews

#Preview("Progress Bar — Values") {
    VStack(spacing: 24) {
        VStack(alignment: .leading, spacing: 4) {
            Text("Download: 25%")
                .font(OshiTypography.caption)
                .foregroundStyle(OshiColor.textSecondary)
            OshiProgressBar(value: 0.25)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text("Upload: 60%")
                .font(OshiTypography.caption)
                .foregroundStyle(OshiColor.textSecondary)
            OshiProgressBar(value: 0.6, accentColor: OshiColor.neonLime)
                .oshiProgressGlow(OshiColor.neonLime)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text("Processing: 90%")
                .font(OshiTypography.caption)
                .foregroundStyle(OshiColor.textSecondary)
            OshiProgressBar(value: 0.9, accentColor: OshiColor.neonMagenta)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text("Complete: 100%")
                .font(OshiTypography.caption)
                .foregroundStyle(OshiColor.textSecondary)
            OshiProgressBar(value: 1.0, style: .standard, accentColor: OshiColor.neonAmber)
        }
    }
    .padding(24)
    .background(OshiColor.surfaceDeep)
}
