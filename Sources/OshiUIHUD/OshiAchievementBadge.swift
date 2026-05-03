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
                Circle()
                    .fill(isUnlocked ? tier.color.opacity(0.15) : OshiColor.surfaceElevated)
                    .frame(width: 64, height: 64)

                Circle()
                    .stroke(
                        isUnlocked ? tier.color.opacity(0.6) : OshiColor.textTertiary,
                        lineWidth: 2
                    )
                    .frame(width: 64, height: 64)

                Image(systemName: tier.icon)
                    .font(.title2)
                    .foregroundStyle(isUnlocked ? tier.color : OshiColor.textTertiary)
            }
            .shadow(
                color: isUnlocked ? tier.color.opacity(glowPulse ? 0.4 : 0.15) : .clear,
                radius: glowPulse ? 16 : 8
            )
            .onAppear {
                guard isUnlocked else { return }
                withAnimation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
                ) {
                    glowPulse = true
                }
            }

            Text(title)
                .font(OshiTypography.caption)
                .foregroundStyle(isUnlocked ? OshiColor.textPrimary : OshiColor.textTertiary)
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
