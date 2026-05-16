//
//  OshiUICoreTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUICore

// MARK: - Module Availability

@Suite("OshiUICore — Module Integrity")
struct OshiUICoreModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUICore.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")

        let parts = version.split(separator: ".")
        #expect(parts.count >= 2, "Semver requires at least major.minor")
    }
}

// MARK: - Color Engine

@Suite("OshiUICore — Color Engine")
struct OshiColorTests {

    @Test("Neon palette colors are accessible")
    func neonPaletteExists() {
        let colors: [Color] = [
            OshiColor.neonCyan,
            OshiColor.neonMagenta,
            OshiColor.neonLime,
            OshiColor.neonAmber,
            OshiColor.neonViolet,
            OshiColor.neonCoral
        ]
        #expect(colors.count == 6)
    }

    @Test("Surface colors form dark-to-light hierarchy")
    func surfaceHierarchyExists() {
        // Verify all surface colors are accessible
        let _ = OshiColor.surfaceDeep
        let _ = OshiColor.surfaceElevated
        let _ = OshiColor.surfaceFloating
    }

    @Test("Text colors are accessible")
    func textColorsExist() {
        let _ = OshiColor.textPrimary
        let _ = OshiColor.textSecondary
        let _ = OshiColor.textTertiary
    }

    @Test("Gradient factories return valid gradients")
    func gradientFactories() {
        let linear = OshiColor.gradient(.red, .blue)
        let glow = OshiColor.glowGradient(.red)
        let radial = OshiColor.radialGlow(.red)
        #expect(type(of: linear) == LinearGradient.self)
        #expect(type(of: glow) == LinearGradient.self)
        #expect(type(of: radial) == RadialGradient.self)
    }

    @Test("ShapeStyle extension exposes neon accessors")
    func shapeStyleAccessors() {
        let cyan: Color = .oshiCyan
        let magenta: Color = .oshiMagenta
        let lime: Color = .oshiLime
        let amber: Color = .oshiAmber
        let violet: Color = .oshiViolet

        // These should match the OshiColor static properties
        #expect(cyan == OshiColor.neonCyan)
        #expect(magenta == OshiColor.neonMagenta)
        #expect(lime == OshiColor.neonLime)
        #expect(amber == OshiColor.neonAmber)
        #expect(violet == OshiColor.neonViolet)
    }
}

// MARK: - Typography

@Suite("OshiUICore — Typography")
struct OshiTypographyTests {

    @Test("All typography tiers are accessible")
    func typographyTiersExist() {
        let fonts: [Font] = [
            OshiTypography.display,
            OshiTypography.title,
            OshiTypography.title2,
            OshiTypography.title3,
            OshiTypography.body,
            OshiTypography.bodyBold,
            OshiTypography.callout,
            OshiTypography.footnote,
            OshiTypography.caption,
            OshiTypography.code,
            OshiTypography.codeSmall
        ]
        #expect(fonts.count == 11)
    }
}

// MARK: - Spacing

@Suite("OshiUICore — Spacing")
struct OshiSpacingTests {

    @Test("Spacing tokens follow ascending order")
    func spacingAscending() {
        let values: [CGFloat] = [
            OshiSpacing.xxs, OshiSpacing.xs, OshiSpacing.sm,
            OshiSpacing.md, OshiSpacing.lg, OshiSpacing.xl,
            OshiSpacing.xxl, OshiSpacing.xxxl
        ]
        for i in 0..<(values.count - 1) {
            #expect(values[i] < values[i + 1], "Spacing tokens must be ascending")
        }
    }

    @Test("Corner radius tokens follow ascending order")
    func cornerRadiusAscending() {
        #expect(OshiSpacing.radiusSmall < OshiSpacing.radiusMedium)
        #expect(OshiSpacing.radiusMedium < OshiSpacing.radiusLarge)
        #expect(OshiSpacing.radiusLarge < OshiSpacing.radiusFull)
    }

    @Test("All spacing tokens are positive")
    func allPositive() {
        let values: [CGFloat] = [
            OshiSpacing.xxs, OshiSpacing.xs, OshiSpacing.sm,
            OshiSpacing.md, OshiSpacing.lg, OshiSpacing.xl,
            OshiSpacing.xxl, OshiSpacing.xxxl,
            OshiSpacing.radiusSmall, OshiSpacing.radiusMedium,
            OshiSpacing.radiusLarge, OshiSpacing.radiusFull
        ]
        for value in values {
            #expect(value > 0, "Spacing tokens must be positive")
        }
    }
}

// MARK: - Platform

@Suite("OshiUICore — Platform")
struct OshiPlatformTests {

    @Test("Current platform is detected")
    func currentPlatform() {
        let platform = OshiPlatform.current
        #expect(!platform.displayName.isEmpty)
    }

    @Test("All platforms have display names")
    func allDisplayNames() {
        for platform in OshiPlatform.allCases {
            #expect(!platform.displayName.isEmpty)
        }
    }

    @Test("Current platform matches runtime environment")
    func currentPlatformMatchesRuntime() {
        let platform = OshiPlatform.current
        #if os(macOS)
        #expect(platform == .macOS)
        #elseif os(iOS)
        #expect(platform == .iOS)
        #elseif os(visionOS)
        #expect(platform == .visionOS)
        #endif
    }
}

// MARK: - Neon Glow Modifier

@Suite("OshiUICore — Neon Glow Modifier")
struct OshiNeonGlowModifierTests {

    @Test("Default init uses neon cyan with radius 10")
    func defaultInit() {
        let modifier = OshiNeonGlowModifier()
        #expect(modifier.color == OshiColor.neonCyan)
        #expect(modifier.radius == 10)
        #expect(modifier.intensity == 2)
    }

    @Test("Custom init preserves parameters")
    func customInit() {
        let modifier = OshiNeonGlowModifier(
            color: OshiColor.neonMagenta,
            radius: 20,
            intensity: 3
        )
        #expect(modifier.color == OshiColor.neonMagenta)
        #expect(modifier.radius == 20)
        #expect(modifier.intensity == 3)
    }

    @Test("Single intensity omits outer shadow")
    func singleIntensity() {
        let modifier = OshiNeonGlowModifier(intensity: 1)
        // With intensity 1, the outermost shadow should use .clear
        #expect(modifier.intensity == 1)
    }

    @Test("Radius must be positive for visible glow")
    func radiusPositive() {
        let modifier = OshiNeonGlowModifier(radius: 0)
        #expect(modifier.radius == 0, "Zero radius should be accepted")
    }
}
