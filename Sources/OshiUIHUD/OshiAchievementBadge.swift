//
//  OshiAchievementBadge.swift
//  OshiUI — HUD Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A glowing achievement badge with tier-based colors and unlock animations.
///
/// ## Usage
///
/// ```swift
/// OshiAchievementBadge(title: "First Launch", tier: .gold, isUnlocked: true)
/// OshiAchievementBadge(title: "Speed Run", tier: .platinum, isUnlocked: false)
/// ```
public struct OshiAchievementBadge: View {

    /// The achievement title.
    public let title: String

    /// The achievement tier determining color scheme.
    public let tier: OshiAchievementTier

    /// Whether the achievement is unlocked.
    public let isUnlocked: Bool

    @State private var glowPulse = false

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    /// Creates an achievement badge.
    ///
    /// - Parameters:
    ///   - title: The achievement name.
    ///   - tier: The color tier.
    ///   - isUnlocked: Whether the achievement is unlocked.
    public init(title: String, tier: OshiAchievementTier, isUnlocked: Bool) {
        self.title = title
        self.tier = tier
        self.isUnlocked = isUnlocked
    }

    public var body: some View {
        VStack(spacing: OshiSpacing.sm) {
            ZStack {
                // Outer decorative ring — dashed border
                if isUnlocked {
                    Circle()
                        .stroke(
                            tier.color.opacity(0.2),
                            style: StrokeStyle(lineWidth: 1, dash: [3, 4])
                        )
                        .frame(width: 76, height: 76)
                }

                // Ambient glow ring
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                isUnlocked ? tier.color.opacity(0.12) : .clear,
                                .clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 44
                        )
                    )
                    .frame(width: 88, height: 88)

                // Main circle — gradient fill
                Circle()
                    .fill(
                        isUnlocked
                            ? AnyShapeStyle(
                                LinearGradient(
                                    colors: [
                                        tier.color.opacity(0.2),
                                        tier.color.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            : AnyShapeStyle(OshiColor.surfaceElevated)
                    )
                    .frame(width: 64, height: 64)

                // Inner stroke ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: isUnlocked
                                ? [tier.color.opacity(0.8), tier.color.opacity(0.3)]
                                : [OshiColor.textTertiary.opacity(0.3), OshiColor.textTertiary.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 64, height: 64)

                // Icon with subtle shadow
                Image(systemName: tier.icon)
                    .font(.title2)
                    .foregroundStyle(isUnlocked ? tier.color : OshiColor.textTertiary)
                    .shadow(color: isUnlocked ? tier.color.opacity(0.4) : .clear, radius: 4)
            }
            .shadow(
                color: isUnlocked ? tier.color.opacity(glowPulse ? 0.4 : 0.1) : .clear,
                radius: glowPulse ? 20 : 8
            )
            .onAppear {
                guard isUnlocked, !reduceMotion else { return }
                withAnimation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
                ) {
                    glowPulse = true
                }
            }

            // Title + tier label
            VStack(spacing: 2) {
                Text(title)
                    .font(OshiTypography.caption)
                    .foregroundStyle(isUnlocked ? OshiColor.textPrimary : OshiColor.textTertiary)
                Text(tier.rawValue.uppercased())
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .tracking(1.5)
                    .foregroundStyle(isUnlocked ? tier.color.opacity(0.6) : OshiColor.textTertiary.opacity(0.5))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(tier.rawValue) tier")
        .accessibilityValue(isUnlocked ? "Unlocked" : "Locked")
        .accessibilityAddTraits(isUnlocked ? .isSelected : [])
    }
}

// MARK: - Achievement Tier

/// The tier level for an ``OshiAchievementBadge``, determining color and icon.
public enum OshiAchievementTier: String, Sendable, CaseIterable {
    /// Bronze tier — entry-level achievements.
    case bronze
    /// Silver tier — intermediate achievements.
    case silver
    /// Gold tier — advanced achievements.
    case gold
    /// Platinum tier — elite achievements.
    case platinum

    /// The tier's accent color.
    public var color: Color {
        switch self {
        case .bronze: Color(hue: 0.08, saturation: 0.65, brightness: 0.70)
        case .silver: Color(hue: 0.0, saturation: 0.0, brightness: 0.78)
        case .gold: OshiColor.neonAmber
        case .platinum: OshiColor.neonCyan
        }
    }

    /// The SF Symbol icon for the tier.
    public var icon: String {
        switch self {
        case .bronze: "shield.fill"
        case .silver: "star.fill"
        case .gold: "crown.fill"
        case .platinum: "diamond.fill"
        }
    }
}

// MARK: - Previews

#Preview("Achievement Badges — All Tiers") {
    HStack(spacing: 24) {
        OshiAchievementBadge(title: "First Steps", tier: .bronze, isUnlocked: true)
        OshiAchievementBadge(title: "Explorer", tier: .silver, isUnlocked: true)
        OshiAchievementBadge(title: "Champion", tier: .gold, isUnlocked: true)
        OshiAchievementBadge(title: "Legendary", tier: .platinum, isUnlocked: false)
    }
    .padding(32)
    .background(OshiColor.surfaceDeep)
}
