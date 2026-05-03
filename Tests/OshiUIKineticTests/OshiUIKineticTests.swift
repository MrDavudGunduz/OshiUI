//
//  OshiUIKineticTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUIKinetic

@Suite("OshiUIKinetic — Module Integrity")
struct OshiUIKineticModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUIKinetic.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

@Suite("OshiUIKinetic — Spring Presets")
struct OshiSpringPresetTests {

    @Test("All presets produce valid animations")
    func allPresetsHaveAnimations() {
        for preset in OshiSpringPreset.allCases {
            let animation = preset.animation
            #expect(type(of: animation) == Animation.self)
        }
    }

    @Test("Damping fractions are within valid range 0-1")
    func dampingFractionsValid() {
        for preset in OshiSpringPreset.allCases {
            #expect(preset.dampingFraction >= 0 && preset.dampingFraction <= 1,
                    "\(preset.rawValue) damping must be 0...1")
        }
    }

    @Test("Response values are positive")
    func responseValuesPositive() {
        for preset in OshiSpringPreset.allCases {
            #expect(preset.response > 0,
                    "\(preset.rawValue) response must be positive")
        }
    }

    @Test("Preset count matches CaseIterable")
    func presetCount() {
        let presets = OshiSpringPreset.allCases
        #expect(presets.count >= 4, "Should have at least 4 spring presets")
    }

    @Test("Snappy preset has shorter response than gentle")
    func snappyFasterThanGentle() {
        #expect(OshiSpringPreset.snappy.response < OshiSpringPreset.gentle.response)
    }
}

@Suite("OshiUIKinetic — Haptic Engine")
struct OshiHapticEngineTests {

    @Test("Impact intensities are defined")
    func impactIntensities() {
        let intensities: [OshiHapticEngine.ImpactIntensity] = [.light, .medium, .heavy]
        #expect(intensities.count == 3)
    }

    @Test("Notification types are defined")
    func notificationTypes() {
        let types: [OshiHapticEngine.NotificationType] = [.success, .warning, .error]
        #expect(types.count == 3)
    }
}
