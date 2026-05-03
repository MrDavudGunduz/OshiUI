//
//  OshiHapticEngine.swift
//  OshiUI — Kinetic Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// Platform-adaptive haptic feedback engine for tactile interactions.
///
/// `OshiHapticEngine` provides a unified haptic API that automatically
/// adapts to the current platform's capabilities:
///
/// | Platform | Backend |
/// |----------|---------|
/// | **iOS** | `UIImpactFeedbackGenerator` |
/// | **macOS** | `NSHapticFeedbackManager` |
/// | **visionOS** | No-op (silent) |
///
/// ## Usage
///
/// ```swift
/// OshiHapticEngine.impact(.medium)
/// OshiHapticEngine.notification(.success)
/// OshiHapticEngine.selection()
/// ```
@MainActor
public enum OshiHapticEngine: Sendable {

    /// The intensity of an impact haptic.
    public enum ImpactIntensity: Sendable {
        /// Light tap — subtle confirmation.
        case light
        /// Medium tap — standard interaction feedback.
        case medium
        /// Heavy tap — significant action confirmation.
        case heavy
    }

    /// The type of notification haptic.
    public enum NotificationType: Sendable {
        /// Positive outcome.
        case success
        /// Neutral alert.
        case warning
        /// Negative outcome.
        case error
    }

    // MARK: - Impact

    /// Triggers an impact haptic with the specified intensity.
    ///
    /// - Parameter intensity: The impact strength. Defaults to `.medium`.
    public static func impact(_ intensity: ImpactIntensity = .medium) {
        #if os(iOS)
        let style: UIImpactFeedbackGenerator.FeedbackStyle = switch intensity {
        case .light: .light
        case .medium: .medium
        case .heavy: .heavy
        }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(
            .alignment,
            performanceTime: .default
        )
        #endif
    }

    // MARK: - Notification

    /// Triggers a notification haptic for state feedback.
    ///
    /// - Parameter type: The notification category.
    public static func notification(_ type: NotificationType) {
        #if os(iOS)
        let feedbackType: UINotificationFeedbackGenerator.FeedbackType = switch type {
        case .success: .success
        case .warning: .warning
        case .error: .error
        }
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(
            .levelChange,
            performanceTime: .default
        )
        #endif
    }

    // MARK: - Selection

    /// Triggers a light selection haptic for picker/toggle changes.
    public static func selection() {
        #if os(iOS)
        UISelectionFeedbackGenerator().selectionChanged()
        #elseif os(macOS)
        NSHapticFeedbackManager.defaultPerformer.perform(
            .generic,
            performanceTime: .default
        )
        #endif
    }
}
