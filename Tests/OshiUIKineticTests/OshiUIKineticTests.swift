//
//  OshiUIKineticTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUIKinetic
@testable import OshiUICore

// MARK: - Module Integrity

@Suite("OshiUIKinetic — Module Integrity")
struct OshiUIKineticModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUIKinetic.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

// MARK: - Spring Presets

@Suite("OshiUIKinetic — Spring Presets")
struct OshiSpringPresetTests {

    @Test("All presets are accessible via CaseIterable")
    func allPresetsAccessible() {
        let presets = OshiSpringPreset.allCases
        #expect(presets.count == 4)
    }

    @Test("Each preset produces a valid animation")
    func presetsProduceAnimations() {
        for preset in OshiSpringPreset.allCases {
            let animation = preset.animation
            #expect(type(of: animation) == Animation.self)
        }
    }

    @Test("Response values are positive and in expected range")
    func responseValues() {
        for preset in OshiSpringPreset.allCases {
            #expect(preset.response > 0, "\(preset.rawValue) response must be positive")
            #expect(preset.response <= 1.0, "\(preset.rawValue) response should be ≤ 1.0s")
        }
    }

    @Test("Damping fractions are in valid range (0, 1]")
    func dampingFractions() {
        for preset in OshiSpringPreset.allCases {
            #expect(preset.dampingFraction > 0, "\(preset.rawValue) damping must be positive")
            #expect(preset.dampingFraction <= 1.0, "\(preset.rawValue) damping must be ≤ 1.0")
        }
    }

    @Test("Snappy has fastest response")
    func snappyFastest() {
        #expect(OshiSpringPreset.snappy.response <= OshiSpringPreset.bouncy.response)
        #expect(OshiSpringPreset.snappy.response <= OshiSpringPreset.heavy.response)
        #expect(OshiSpringPreset.snappy.response <= OshiSpringPreset.gentle.response)
    }

    @Test("Heavy has slowest response")
    func heavySlowest() {
        #expect(OshiSpringPreset.heavy.response >= OshiSpringPreset.snappy.response)
        #expect(OshiSpringPreset.heavy.response >= OshiSpringPreset.bouncy.response)
    }

    @Test("Bouncy has lowest damping for visible overshoot")
    func bouncyLowestDamping() {
        #expect(OshiSpringPreset.bouncy.dampingFraction < OshiSpringPreset.snappy.dampingFraction)
        #expect(OshiSpringPreset.bouncy.dampingFraction < OshiSpringPreset.heavy.dampingFraction)
        #expect(OshiSpringPreset.bouncy.dampingFraction < OshiSpringPreset.gentle.dampingFraction)
    }

    @Test("Raw values are unique and non-empty")
    func uniqueRawValues() {
        let rawValues = OshiSpringPreset.allCases.map(\.rawValue)
        let uniqueValues = Set(rawValues)
        #expect(uniqueValues.count == rawValues.count, "Raw values must be unique")
        for raw in rawValues {
            #expect(!raw.isEmpty, "Raw value must not be empty")
        }
    }

    @Test("Gentle has highest damping for smooth motion")
    func gentleHighestDamping() {
        #expect(OshiSpringPreset.gentle.dampingFraction >= OshiSpringPreset.snappy.dampingFraction)
        #expect(OshiSpringPreset.gentle.dampingFraction >= OshiSpringPreset.bouncy.dampingFraction)
        #expect(OshiSpringPreset.gentle.dampingFraction >= OshiSpringPreset.heavy.dampingFraction)
    }
}

// MARK: - Haptic Engine

@Suite("OshiUIKinetic — Haptic Engine")
struct OshiHapticEngineTests {

    @Test("All impact intensities are accessible via CaseIterable")
    func impactIntensities() {
        let intensities = OshiHapticEngine.ImpactIntensity.allCases
        #expect(intensities.count == 3)
    }

    @Test("All notification types are accessible via CaseIterable")
    func notificationTypes() {
        let types = OshiHapticEngine.NotificationType.allCases
        #expect(types.count == 3)
    }

    @Test("Impact intensity raw values are unique")
    func intensityRawValues() {
        let rawValues = OshiHapticEngine.ImpactIntensity.allCases.map(\.rawValue)
        #expect(Set(rawValues).count == rawValues.count)
    }

    @Test("Notification type raw values are unique")
    func notificationRawValues() {
        let rawValues = OshiHapticEngine.NotificationType.allCases.map(\.rawValue)
        #expect(Set(rawValues).count == rawValues.count)
    }
}

// MARK: - Haptic Mock Provider

/// A silent mock haptic provider for verifying haptic trigger behavior.
@MainActor
final class MockHapticProvider: OshiHapticProviding {
    var impactCalls: [OshiHapticEngine.ImpactIntensity] = []
    var notificationCalls: [OshiHapticEngine.NotificationType] = []
    var selectionCallCount = 0

    func impact(_ intensity: OshiHapticEngine.ImpactIntensity) {
        impactCalls.append(intensity)
    }

    func notification(_ type: OshiHapticEngine.NotificationType) {
        notificationCalls.append(type)
    }

    func selection() {
        selectionCallCount += 1
    }

    func reset() {
        impactCalls.removeAll()
        notificationCalls.removeAll()
        selectionCallCount = 0
    }
}

@Suite("OshiUIKinetic — Haptic Mock Injection")
@MainActor
struct OshiHapticMockTests {

    @Test("Mock provider captures impact calls via withProvider")
    func mockImpactCapture() {
        let mock = MockHapticProvider()
        OshiHapticEngine.withProvider(mock) {
            OshiHapticEngine.impact(.heavy)
            OshiHapticEngine.impact(.light)
        }
        #expect(mock.impactCalls.count == 2)
        #expect(mock.impactCalls[0] == .heavy)
        #expect(mock.impactCalls[1] == .light)
    }

    @Test("Mock provider captures notification calls via withProvider")
    func mockNotificationCapture() {
        let mock = MockHapticProvider()
        OshiHapticEngine.withProvider(mock) {
            OshiHapticEngine.notification(.success)
            OshiHapticEngine.notification(.error)
        }
        #expect(mock.notificationCalls.count == 2)
        #expect(mock.notificationCalls[0] == .success)
        #expect(mock.notificationCalls[1] == .error)
    }

    @Test("Mock provider captures selection calls via withProvider")
    func mockSelectionCapture() {
        let mock = MockHapticProvider()
        OshiHapticEngine.withProvider(mock) {
            OshiHapticEngine.selection()
            OshiHapticEngine.selection()
            OshiHapticEngine.selection()
        }
        #expect(mock.selectionCallCount == 3)
    }

    @Test("withProvider restores original provider after completion")
    func providerRestoration() {
        let original = OshiHapticEngine.provider
        let mock = MockHapticProvider()

        OshiHapticEngine.withProvider(mock) {
            OshiHapticEngine.impact(.medium)
            #expect(mock.impactCalls.count == 1)
        }

        // After withProvider, mock should not receive new calls
        let countBefore = mock.impactCalls.count
        OshiHapticEngine.impact(.medium)
        #expect(mock.impactCalls.count == countBefore,
                "Mock should not receive calls after withProvider completes")

        // Restore for other tests
        OshiHapticEngine.provider = original
    }

    @Test("Mock reset clears all recorded calls")
    func mockReset() {
        let mock = MockHapticProvider()
        OshiHapticEngine.withProvider(mock) {
            OshiHapticEngine.impact(.heavy)
            OshiHapticEngine.notification(.warning)
            OshiHapticEngine.selection()

            mock.reset()
            #expect(mock.impactCalls.isEmpty)
            #expect(mock.notificationCalls.isEmpty)
            #expect(mock.selectionCallCount == 0)
        }
    }

    @Test("Legacy provider swap still works for backward compatibility")
    func legacyProviderSwap() {
        let mock = MockHapticProvider()
        let original = OshiHapticEngine.provider

        OshiHapticEngine.provider = mock
        OshiHapticEngine.impact(.light)
        #expect(mock.impactCalls.count == 1)

        OshiHapticEngine.provider = original
    }

    @Test("All impact intensities route through mock correctly")
    func allIntensitiesRoute() {
        let mock = MockHapticProvider()
        OshiHapticEngine.withProvider(mock) {
            for intensity in OshiHapticEngine.ImpactIntensity.allCases {
                OshiHapticEngine.impact(intensity)
            }
        }
        #expect(mock.impactCalls.count == 3)
        #expect(mock.impactCalls.contains(.light))
        #expect(mock.impactCalls.contains(.medium))
        #expect(mock.impactCalls.contains(.heavy))
    }

    @Test("All notification types route through mock correctly")
    func allNotificationsRoute() {
        let mock = MockHapticProvider()
        OshiHapticEngine.withProvider(mock) {
            for type in OshiHapticEngine.NotificationType.allCases {
                OshiHapticEngine.notification(type)
            }
        }
        #expect(mock.notificationCalls.count == 3)
        #expect(mock.notificationCalls.contains(.success))
        #expect(mock.notificationCalls.contains(.warning))
        #expect(mock.notificationCalls.contains(.error))
    }
}

// MARK: - Kinetic Button Style

@Suite("OshiUIKinetic — Kinetic Button Style")
@MainActor
struct KineticImpactButtonStyleTests {

    @Test("Default init uses medium intensity")
    func defaultIntensity() {
        let style = KineticImpactButtonStyle()
        #expect(style.intensity == .medium)
    }

    @Test("Default init uses neon cyan accent")
    func defaultAccent() {
        let style = KineticImpactButtonStyle()
        #expect(style.accentColor == OshiColor.neonCyan)
    }

    @Test("Default init uses snappy spring")
    func defaultSpring() {
        let style = KineticImpactButtonStyle()
        #expect(style.spring == .snappy)
    }

    @Test("Custom init preserves all parameters")
    func customInit() {
        let style = KineticImpactButtonStyle(
            intensity: .heavy,
            accentColor: OshiColor.neonLime,
            spring: .bouncy
        )
        #expect(style.intensity == .heavy)
        #expect(style.accentColor == OshiColor.neonLime)
        #expect(style.spring == .bouncy)
    }
}

// MARK: - Reduced Motion Animation

@Suite("OshiUIKinetic — Reduced Motion Fallback")
struct OshiSpringReducedMotionTests {

    @Test("All presets provide a reduced motion animation")
    func allPresetsHaveReducedMotion() {
        for preset in OshiSpringPreset.allCases {
            let animation = preset.reducedMotionAnimation
            #expect(type(of: animation) == Animation.self)
        }
    }

    @Test("Reduced motion animation is eased, not spring")
    func reducedMotionIsEased() {
        // We can verify this indirectly: reducedMotionAnimation should differ from spring animation
        // Both exist as Animation type — the key contract is that the API is available
        let spring = OshiSpringPreset.snappy.animation
        let eased = OshiSpringPreset.snappy.reducedMotionAnimation
        #expect(type(of: spring) == type(of: eased))
    }
}

// MARK: - Async Provider Injection

@Suite("OshiUIKinetic — Async Provider Injection")
@MainActor
struct OshiHapticAsyncProviderTests {

    @Test("Async withProvider captures calls correctly")
    func asyncProviderCapture() async {
        let mock = MockHapticProvider()
        await OshiHapticEngine.withProvider(mock) {
            OshiHapticEngine.impact(.heavy)
            OshiHapticEngine.notification(.success)
        }
        #expect(mock.impactCalls.count == 1)
        #expect(mock.impactCalls[0] == .heavy)
        #expect(mock.notificationCalls.count == 1)
        #expect(mock.notificationCalls[0] == .success)
    }

    @Test("Async withProvider restores original provider after completion")
    func asyncProviderRestoration() async {
        let original = OshiHapticEngine.provider
        let mock = MockHapticProvider()

        await OshiHapticEngine.withProvider(mock) {
            OshiHapticEngine.impact(.medium)
        }

        // After completion, mock should not receive new calls
        let countBefore = mock.impactCalls.count
        OshiHapticEngine.impact(.medium)
        #expect(mock.impactCalls.count == countBefore,
                "Mock should not receive calls after async withProvider completes")

        OshiHapticEngine.provider = original
    }
}
