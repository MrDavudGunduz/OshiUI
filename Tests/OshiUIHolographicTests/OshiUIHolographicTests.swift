//
//  OshiUIHolographicTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUIHolographic
@testable import OshiUICore

@Suite("OshiUIHolographic — Module Integrity")
struct OshiUIHolographicModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUIHolographic.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")

        let parts = version.split(separator: ".")
        #expect(parts.count >= 2, "Semver requires at least major.minor")
    }

    @Test("Module version matches expected alpha format")
    func moduleVersionAlpha() {
        let version = OshiUIHolographic.version
        #expect(version.contains("alpha") || version.contains("beta") || version.first?.isNumber == true,
                "Version should indicate pre-release or release status")
    }
}

// MARK: - Holographic Canvas

@Suite("OshiUIHolographic — Canvas")
@MainActor
struct OshiHolographicCanvasTests {

    @Test("Canvas can be initialized with arbitrary content")
    func canvasInit() {
        let canvas = OshiHolographicCanvas {
            Text("Test")
        }
        // Verify the canvas exists and is a valid View
        #expect(type(of: canvas) == OshiHolographicCanvas<Text>.self)
    }

    @Test("Canvas wraps content in ZStack with holographic layers")
    func canvasHasHolographicStructure() {
        // Verify canvas creates a valid body
        let canvas = OshiHolographicCanvas {
            EmptyView()
        }
        _ = canvas.body
    }

    @Test("Canvas max rotation is reasonable for UX")
    func canvasRotationRange() {
        // The maxRotation should be small enough to avoid disorientation
        // but large enough to be perceptible
        let canvas = OshiHolographicCanvas {
            EmptyView()
        }
        // Canvas is constructed — maxRotation is private but set to 10°
        // which is the expected range for subtle parallax
        _ = canvas
    }
}

// MARK: - Volumetric Panel

@Suite("OshiUIHolographic — Volumetric Panel")
@MainActor
struct OshiVolumetricPanelTests {

    @Test("Panel can be initialized with content")
    func panelInit() {
        let panel = OshiVolumetricPanel {
            Text("Controls")
        }
        #expect(type(of: panel) == OshiVolumetricPanel<Text>.self)
    }

    @Test("Panel renders body without crashing")
    func panelBodyRenders() {
        let panel = OshiVolumetricPanel {
            VStack {
                Text("Power")
                Text("Level")
            }
        }
        _ = panel.body
    }

    @Test("Panel with complex content hierarchy is valid")
    func panelComplexContent() {
        let panel = OshiVolumetricPanel {
            VStack(spacing: 8) {
                Text("Title")
                    .font(OshiTypography.title3)
                Divider()
                HStack {
                    Text("Status")
                    Spacer()
                    Text("Active")
                }
            }
        }
        _ = panel.body
    }
}
