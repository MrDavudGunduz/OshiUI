//
//  OshiUITests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUI

// MARK: - Umbrella Re-Export Verification

@Suite("OshiUI — Umbrella Re-Export Verification")
@MainActor
struct OshiUIReExportTests {

    @Test("All sub-module types are accessible via umbrella import")
    func allModuleTypesAccessible() {
        // Core
        let _ = OshiColor.neonCyan
        let _ = OshiTypography.body
        let _ = OshiSpacing.md
        let _ = OshiPlatform.current

        // Spatial
        let _ = GlassmorphismModifier(blur: 20)
        let _ = OshiCardDepthLevel.standard

        // Kinetic
        let _ = OshiSpringPreset.snappy
        let _ = OshiHapticEngine.ImpactIntensity.medium

        // Noir
        let _ = OshiToastConfiguration.default

        // HUD
        let _ = OshiAchievementTier.gold
        let _ = OshiProgressStyle.kinetic

        // Synapse
        let _ = OshiChatMessage(role: .user, content: "test")
        let _ = OshiStreamCursorStyle.pulse
        let _ = OshiThinkingStyle.neural

        // Canvas
        let _ = OshiWidgetSize.medium
    }

    @Test("Umbrella import provides access to all convenience view modifiers")
    func viewModifiersAccessible() {
        // Verify extension methods compile — these would fail if re-exports
        // were missing since the extensions are defined in sub-modules.
        let view = Text("Test")
        let _ = view.oshiNeonGlow()
        let _ = view.oshiGlassmorphism()
        let _ = view.oshiText(OshiTypography.body)
        let _ = view.oshiReducedEffects()
        let _ = view.oshiStreamCursor(.pulse)
        let _ = view.oshiProgressGlow(.red)
    }
}

// MARK: - Version Consistency

@Suite("OshiUI — Version Consistency")
struct OshiUIVersionConsistencyTests {

    @Test("OshiUICore version is the single source of truth")
    func coreVersionIsTruth() {
        let version = OshiUICore.version
        #expect(!version.isEmpty, "Core version must not be empty")
        #expect(version.contains("."), "Core version must follow semver format")
    }

    @Test("All sub-module versions match OshiUICore version")
    func allVersionsMatch() {
        let coreVersion = OshiUICore.version

        // Each sub-module's version property delegates to OshiUICore.version.
        // This test catches regressions where a module hard-codes its own value.
        #expect(OshiUISpatial.version == coreVersion,
                "OshiUISpatial version must match Core")
        #expect(OshiUIKinetic.version == coreVersion,
                "OshiUIKinetic version must match Core")
        #expect(OshiUINoir.version == coreVersion,
                "OshiUINoir version must match Core")
        #expect(OshiUIHUD.version == coreVersion,
                "OshiUIHUD version must match Core")
        #expect(OshiUIHolographic.version == coreVersion,
                "OshiUIHolographic version must match Core")
        #expect(OshiUISynapse.version == coreVersion,
                "OshiUISynapse version must match Core")
        #expect(OshiUICanvas.version == coreVersion,
                "OshiUICanvas version must match Core")
    }

    @Test("Version string follows semantic versioning pattern")
    func versionFollowsSemver() {
        let version = OshiUICore.version
        // Allow pre-release tags like "1.0.0-alpha"
        let components = version.split(separator: "-")[0].split(separator: ".")
        #expect(components.count >= 2,
                "Version must have at least major.minor components")
        for component in components {
            #expect(Int(component) != nil,
                    "Version component '\(component)' must be numeric")
        }
    }
}

// MARK: - Adaptive Color Availability

@Suite("OshiUI — Adaptive Color Verification")
struct OshiUIAdaptiveColorTests {

    @Test("All adaptive surface colors are accessible")
    func adaptiveSurfacesAccessible() {
        let _ = OshiColor.adaptiveSurfaceDeep
        let _ = OshiColor.adaptiveSurfaceElevated
        let _ = OshiColor.adaptiveSurfaceFloating
    }

    @Test("All adaptive text colors are accessible")
    func adaptiveTextsAccessible() {
        let _ = OshiColor.adaptiveTextPrimary
        let _ = OshiColor.adaptiveTextSecondary
        let _ = OshiColor.adaptiveTextTertiary
    }

    @Test("Adaptive colors are distinct from static dark-only colors")
    func adaptiveColorsExistAlongsideStatic() {
        // Both static (dark-only) and adaptive (scheme-aware) APIs
        // should coexist for backward compatibility.
        let _ = OshiColor.surfaceDeep
        let _ = OshiColor.adaptiveSurfaceDeep
        let _ = OshiColor.textPrimary
        let _ = OshiColor.adaptiveTextPrimary
    }
}

// MARK: - Cross-Module Integration

@Suite("OshiUI — Cross-Module Integration")
@MainActor
struct OshiUICrossModuleTests {

    @Test("OshiToast initializes with correct parameters")
    func toastInitialization() {
        let toast = OshiToast("Test Message", icon: "checkmark.circle", glow: OshiColor.neonLime)
        #expect(toast.message == "Test Message")
        #expect(toast.icon == "checkmark.circle")
    }

    @Test("OshiChatMessage can be used across module boundaries")
    func chatMessageCrossModule() {
        let message = OshiChatMessage(role: .user, content: "Hello")
        #expect(message.role == .user)
        #expect(message.content == "Hello")
    }

    @Test("OshiRadarChart accepts data from any module context")
    func radarChartCrossModule() {
        let chart = OshiRadarChart(
            data: [0.5, 0.7, 0.3],
            axes: ["A", "B", "C"],
            accentColor: OshiColor.neonViolet
        )
        #expect(chart.data.count == 3)
        #expect(chart.accentColor == OshiColor.neonViolet)
    }

    @Test("Theme environment is accessible via umbrella import")
    func themeEnvironmentAccessible() {
        let env = EnvironmentValues()
        let theme = env.oshiTheme
        #expect(theme.neonCyan == OshiColor.neonCyan)
    }

    @Test("Spring presets are accessible for animation composition")
    func springPresetsAccessible() {
        let presets = OshiSpringPreset.allCases
        #expect(presets.count == 4)
        for preset in presets {
            #expect(preset.response > 0)
            #expect(preset.dampingFraction > 0)
        }
    }
}

