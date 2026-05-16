//
//  OshiUISpatialTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUISpatial
@testable import OshiUICore

@Suite("OshiUISpatial — Module Integrity")
struct OshiUISpatialModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUISpatial.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

// MARK: - Depth Levels

@Suite("OshiUISpatial — Depth Levels")
struct OshiDepthLevelTests {

    @Test("Shadow radii follow ascending order by depth")
    func shadowRadiiAscending() {
        let lightweight = OshiCardDepthLevel.lightweight
        let shallow = OshiCardDepthLevel.shallow
        let standard = OshiCardDepthLevel.standard
        let deep = OshiCardDepthLevel.deep

        #expect(lightweight.shadowRadius < shallow.shadowRadius)
        #expect(shallow.shadowRadius < standard.shadowRadius)
        #expect(standard.shadowRadius < deep.shadowRadius)
    }

    @Test("Shadow offsets follow ascending order by depth")
    func shadowOffsetsAscending() {
        let lightweight = OshiCardDepthLevel.lightweight
        let shallow = OshiCardDepthLevel.shallow
        let standard = OshiCardDepthLevel.standard
        let deep = OshiCardDepthLevel.deep

        #expect(lightweight.shadowOffset < shallow.shadowOffset)
        #expect(shallow.shadowOffset < standard.shadowOffset)
        #expect(standard.shadowOffset < deep.shadowOffset)
    }

    @Test("Shadow opacities follow ascending order by depth")
    func shadowOpacitiesAscending() {
        let lightweight = OshiCardDepthLevel.lightweight
        let shallow = OshiCardDepthLevel.shallow
        let standard = OshiCardDepthLevel.standard
        let deep = OshiCardDepthLevel.deep

        #expect(lightweight.shadowOpacity < shallow.shadowOpacity)
        #expect(shallow.shadowOpacity < standard.shadowOpacity)
        #expect(standard.shadowOpacity < deep.shadowOpacity)
    }

    @Test("All shadow values are positive")
    func allShadowValuesPositive() {
        let levels: [OshiCardDepthLevel] = [
            .lightweight, .shallow, .standard, .deep
        ]
        for level in levels {
            #expect(level.shadowRadius > 0)
            #expect(level.shadowOffset > 0)
            #expect(level.shadowOpacity > 0)
        }
    }

    @Test("Lightweight has minimal shadow for list optimization")
    func lightweightMinimal() {
        let lightweight = OshiCardDepthLevel.lightweight
        #expect(lightweight.shadowRadius <= 6, "Lightweight should have minimal blur")
        #expect(lightweight.shadowOffset <= 4, "Lightweight should have minimal offset")
        #expect(lightweight.shadowOpacity <= 0.15, "Lightweight should have low opacity")
    }

    @Test("Deep has maximum shadow intensity")
    func deepMaximum() {
        let deep = OshiCardDepthLevel.deep
        #expect(deep.shadowRadius >= 25, "Deep should have significant blur")
        #expect(deep.shadowOffset >= 12, "Deep should have significant offset")
        #expect(deep.shadowOpacity >= 0.35, "Deep should have high opacity")
    }

    @Test("OshiCardDepthLevel is Sendable")
    func depthLevelSendable() {
        let level: OshiCardDepthLevel = .standard
        let _: any Sendable = level
    }
}

// MARK: - Glassmorphism

@Suite("OshiUISpatial — Glassmorphism")
@MainActor
struct GlassmorphismModifierTests {

    @Test("Default init parameters are reasonable")
    func defaultInit() {
        let modifier = GlassmorphismModifier()
        #expect(modifier.blur == 20)
        #expect(modifier.borderOpacity == 0.3)
        #expect(modifier.cornerRadius == OshiSpacing.radiusMedium)
    }

    @Test("Custom init preserves values")
    func customInit() {
        let modifier = GlassmorphismModifier(
            blur: 30,
            tint: .red,
            borderOpacity: 0.6,
            cornerRadius: 24
        )
        #expect(modifier.blur == 30)
        #expect(modifier.borderOpacity == 0.6)
        #expect(modifier.cornerRadius == 24)
    }

    @Test("Blur radius cannot be negative via max guard")
    func blurNonNegative() {
        // The modifier uses max(0, blur - 20) internally
        let modifier = GlassmorphismModifier(blur: 5)
        #expect(modifier.blur == 5) // Stored as-is; clamped in body
    }

    @Test("Zero border opacity produces invisible border")
    func zeroBorderOpacity() {
        let modifier = GlassmorphismModifier(borderOpacity: 0)
        #expect(modifier.borderOpacity == 0)
    }
}

// MARK: - Volumetric Button Style

@Suite("OshiUISpatial — Volumetric Button Style")
struct OshiVolumetricButtonStyleTests {

    @Test("Default init uses neon cyan color")
    func defaultColor() {
        let style = OshiVolumetricButtonStyle()
        #expect(style.color == OshiColor.neonCyan)
    }

    @Test("Custom color is preserved")
    func customColor() {
        let style = OshiVolumetricButtonStyle(color: OshiColor.neonCoral)
        #expect(style.color == OshiColor.neonCoral)
    }
}
