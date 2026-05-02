//
//  OshiUIHUD.swift
//  OshiUI — HUD Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUIHUD
///
/// Dashboard panels, progress indicators, and gamification components.
///
/// `OshiUIHUD` provides heads-up display components that visualize data with
/// kinetic energy. Progress bars fill with physical inertia, badges pulse with
/// achievement glows, and radar charts render stats with precision.
///
/// ## Components
///
/// - **Kinetic Progress Bars**: Progress indicators that fill with simulated
///   physical momentum — they accelerate, decelerate, and overshoot slightly
///   before settling, creating a satisfying "weight" to completion.
/// - **Glowing Achievement Badges**: Circular badges with pulsing glow
///   animations, tier-based color schemes, and unlock animations.
/// - **Radar Stat Charts**: Multi-axis radar/spider charts for displaying
///   comparative statistics with animated data transitions.
///
/// ## Usage
///
/// ```swift
/// import OshiUIHUD
///
/// // Kinetic progress bar with inertia
/// OshiProgressBar(value: downloadProgress, style: .kinetic)
///     .oshiProgressGlow(.green)
///
/// // Achievement badge with unlock animation
/// OshiAchievementBadge(
///     title: "First Launch",
///     tier: .gold,
///     isUnlocked: true
/// )
///
/// // Radar chart for player stats
/// OshiRadarChart(data: playerStats, axes: statLabels)
///     .oshiRadarFill(.gradient(.cyan, .purple))
/// ```
///
/// ## Topics
///
/// ### Progress
/// - ``OshiProgressBar``
/// - ``OshiProgressStyle``
///
/// ### Gamification
/// - ``OshiAchievementBadge``
/// - ``OshiAchievementTier``
///
/// ### Charts
/// - ``OshiRadarChart``

import SwiftUI
import OshiUICore
import OshiUIKinetic

// MARK: - Module Namespace

/// The `OshiUIHUD` namespace.
public enum OshiUIHUD {

    /// The semantic version of the OshiUIHUD module.
    public static let version = "1.0.0-alpha"
}
