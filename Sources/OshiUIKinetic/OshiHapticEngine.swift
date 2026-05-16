//
//  OshiHapticEngine.swift
//  OshiUI — Kinetic Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

// MARK: - Haptic Provider Protocol

/// A protocol defining the haptic feedback interface.
///
/// Conform to `OshiHapticProviding` to create custom haptic implementations
/// for testing, previews, or alternative feedback mechanisms.
///
/// ```swift
/// // Example: Silent mock for unit tests
/// final class MockHapticProvider: OshiHapticProviding {
///     var lastImpact: OshiHapticEngine.ImpactIntensity?
///     func impact(_ intensity: OshiHapticEngine.ImpactIntensity) {
///         lastImpact = intensity
///     }
///     func notification(_ type: OshiHapticEngine.NotificationType) { }
///     func selection() { }
/// }
/// ```
@MainActor
public protocol OshiHapticProviding: Sendable {
    /// Triggers an impact haptic with the specified intensity.
    func impact(_ intensity: OshiHapticEngine.ImpactIntensity)
    /// Triggers a notification haptic for state feedback.
    func notification(_ type: OshiHapticEngine.NotificationType)
    /// Triggers a light selection haptic for picker/toggle changes.
    func selection()
}

// MARK: - Haptic Engine

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
///
/// ## Testing
///
/// Override the default provider for unit tests:
///
/// ```swift
/// let mock = MockHapticProvider()
/// OshiHapticEngine.provider = mock
/// OshiHapticEngine.impact(.heavy)
/// #expect(mock.lastImpact == .heavy)
/// ```
@MainActor
public enum OshiHapticEngine: Sendable {

    /// The intensity of an impact haptic.
    public enum ImpactIntensity: String, Sendable, CaseIterable {
        /// Light tap — subtle confirmation.
        case light
        /// Medium tap — standard interaction feedback.
        case medium
        /// Heavy tap — significant action confirmation.
        case heavy
    }

    /// The type of notification haptic.
    public enum NotificationType: String, Sendable, CaseIterable {
        /// Positive outcome.
        case success
        /// Neutral alert.
        case warning
        /// Negative outcome.
        case error
    }

    // MARK: - Provider

    /// The current haptic provider.
    ///
    /// Defaults to ``SystemHapticProvider`` which uses platform-native APIs.
    /// This property is `@MainActor`-isolated, which serializes all access
    /// through the main actor and prevents data races.
    ///
    /// > Warning: Direct mutation is supported for backward compatibility,
    /// > but **strongly prefer** ``withProvider(_:operation:)-2v6lm`` for
    /// > test isolation. The scoped pattern guarantees automatic provider
    /// > restoration — even when the test throws — preventing state leaks
    /// > across concurrent test cases.
    public static var provider: any OshiHapticProviding = SystemHapticProvider()

    /// Executes a closure with a temporary haptic provider, restoring the
    /// original provider after completion.
    ///
    /// Use this in tests to safely inject mock providers without affecting
    /// other concurrent test cases.
    ///
    /// ```swift
    /// let mock = MockHapticProvider()
    /// OshiHapticEngine.withProvider(mock) {
    ///     OshiHapticEngine.impact(.heavy)
    ///     #expect(mock.impactCalls.count == 1)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - temporaryProvider: The provider to use during the closure.
    ///   - operation: The test or work closure to execute.
    public static func withProvider(
        _ temporaryProvider: any OshiHapticProviding,
        operation: () throws -> Void
    ) rethrows {
        let original = provider
        provider = temporaryProvider
        defer { provider = original }
        try operation()
    }

    /// Async variant of ``withProvider(_:operation:)-2v6lm`` for use in
    /// async test contexts.
    ///
    /// ```swift
    /// let mock = MockHapticProvider()
    /// await OshiHapticEngine.withProvider(mock) {
    ///     await someAsyncWorkThatTriggersHaptics()
    ///     #expect(mock.impactCalls.count == 1)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - temporaryProvider: The provider to use during the closure.
    ///   - operation: The async test or work closure to execute.
    public static func withProvider(
        _ temporaryProvider: any OshiHapticProviding,
        operation: () async throws -> Void
    ) async rethrows {
        let original = provider
        provider = temporaryProvider
        defer { provider = original }
        try await operation()
    }

    // MARK: - Impact

    /// Triggers an impact haptic with the specified intensity.
    ///
    /// - Parameter intensity: The impact strength. Defaults to `.medium`.
    public static func impact(_ intensity: ImpactIntensity = .medium) {
        provider.impact(intensity)
    }

    // MARK: - Notification

    /// Triggers a notification haptic for state feedback.
    ///
    /// - Parameter type: The notification category.
    public static func notification(_ type: NotificationType) {
        provider.notification(type)
    }

    // MARK: - Selection

    /// Triggers a light selection haptic for picker/toggle changes.
    public static func selection() {
        provider.selection()
    }
}

// MARK: - System Haptic Provider

/// The default platform-adaptive haptic provider.
///
/// Uses native haptic APIs on each platform:
/// - **iOS**: `UIImpactFeedbackGenerator`, `UINotificationFeedbackGenerator`
/// - **macOS**: `NSHapticFeedbackManager`
/// - **visionOS**: No-op (silent)
@MainActor
public final class SystemHapticProvider: OshiHapticProviding {

    public init() {}

    public func impact(_ intensity: OshiHapticEngine.ImpactIntensity) {
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

    public func notification(_ type: OshiHapticEngine.NotificationType) {
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

    public func selection() {
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
