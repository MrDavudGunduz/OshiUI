//
//  OshiThemeEngineTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUICore

// MARK: - Theme Protocol Conformance

@Suite("OshiUICore — Theme Engine")
struct OshiThemeEngineTests {

    @Test("Default theme provides standard neon palette")
    func defaultThemePalette() {
        let theme = OshiDefaultTheme()
        #expect(theme.neonCyan == OshiColor.neonCyan)
        #expect(theme.neonMagenta == OshiColor.neonMagenta)
        #expect(theme.neonLime == OshiColor.neonLime)
        #expect(theme.neonAmber == OshiColor.neonAmber)
        #expect(theme.neonViolet == OshiColor.neonViolet)
        #expect(theme.neonCoral == OshiColor.neonCoral)
    }

    @Test("Default theme provides standard surface colors")
    func defaultThemeSurfaces() {
        let theme = OshiDefaultTheme()
        #expect(theme.surfaceDeep == OshiColor.surfaceDeep)
        #expect(theme.surfaceElevated == OshiColor.surfaceElevated)
        #expect(theme.surfaceFloating == OshiColor.surfaceFloating)
    }

    @Test("Default theme provides standard text colors")
    func defaultThemeText() {
        let theme = OshiDefaultTheme()
        #expect(theme.textPrimary == OshiColor.textPrimary)
        #expect(theme.textSecondary == OshiColor.textSecondary)
        #expect(theme.textTertiary == OshiColor.textTertiary)
    }

    @Test("Default theme provides standard typography")
    func defaultThemeTypography() {
        let theme = OshiDefaultTheme()
        #expect(theme.displayFont == OshiTypography.display)
        #expect(theme.titleFont == OshiTypography.title)
        #expect(theme.bodyFont == OshiTypography.body)
        #expect(theme.captionFont == OshiTypography.caption)
    }

    @Test("Default theme provides standard spacing")
    func defaultThemeSpacing() {
        let theme = OshiDefaultTheme()
        #expect(theme.spacingXS == OshiSpacing.xs)
        #expect(theme.spacingSM == OshiSpacing.sm)
        #expect(theme.spacingMD == OshiSpacing.md)
        #expect(theme.spacingLG == OshiSpacing.lg)
        #expect(theme.spacingXL == OshiSpacing.xl)
    }

    @Test("Custom theme can override specific tokens")
    func customThemeOverrides() {
        let custom = TestCustomTheme()
        // Overridden token
        #expect(custom.neonCyan == Color.blue)
        #expect(custom.surfaceDeep == Color.white)
        // Non-overridden tokens fall back to defaults
        #expect(custom.neonMagenta == OshiColor.neonMagenta)
        #expect(custom.surfaceElevated == OshiColor.surfaceElevated)
        #expect(custom.textPrimary == OshiColor.textPrimary)
    }

    @Test("Custom theme preserves Sendable conformance")
    func customThemeIsSendable() {
        let theme: any OshiThemeProviding & Sendable = TestCustomTheme()
        #expect(theme.neonCyan == Color.blue)
    }
}

// MARK: - Environment Key

@Suite("OshiUICore — Theme Environment Key")
struct OshiThemeEnvironmentTests {

    @Test("oshiTheme environment default is OshiDefaultTheme")
    func environmentDefault() {
        let env = EnvironmentValues()
        let theme = env.oshiTheme
        // Default theme should match OshiDefaultTheme
        #expect(theme.neonCyan == OshiColor.neonCyan)
        #expect(theme.surfaceDeep == OshiColor.surfaceDeep)
    }
}

// MARK: - Test Fixtures

/// A custom theme for testing that overrides only `neonCyan` and `surfaceDeep`.
private struct TestCustomTheme: OshiThemeProviding {
    var neonCyan: Color { .blue }
    var surfaceDeep: Color { .white }
}
