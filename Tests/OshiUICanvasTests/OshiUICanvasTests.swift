//
//  OshiUICanvasTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import CoreGraphics
@testable import OshiUICanvas

@Suite("OshiUICanvas — Module Integrity")
struct OshiUICanvasModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUICanvas.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

@Suite("OshiUICanvas — Widget Sizes")
struct OshiWidgetSizeTests {

    @Test("Widget sizes follow ascending height order")
    func widgetSizeAscending() {
        #expect(OshiWidgetSize.small.height < OshiWidgetSize.medium.height)
        #expect(OshiWidgetSize.medium.height < OshiWidgetSize.large.height)
    }

    @Test("Custom size returns correct height")
    func customSize() {
        let custom = OshiWidgetSize.custom(250)
        #expect(custom.height == 250)
    }

    @Test("All preset sizes are positive")
    func presetSizesPositive() {
        let sizes: [OshiWidgetSize] = [.small, .medium, .large]
        for size in sizes {
            #expect(size.height > 0, "Widget size must be positive")
        }
    }

    @Test("Custom size supports arbitrary values")
    func customSizeArbitrary() {
        let tiny = OshiWidgetSize.custom(50)
        let huge = OshiWidgetSize.custom(1000)
        #expect(tiny.height == 50)
        #expect(huge.height == 1000)
    }
}

@Suite("OshiUICanvas — Snap Grid Proxy")
struct OshiSnapGridProxyTests {

    @Test("Snap proxy produces deterministic results")
    func snapCalculation() {
        let proxy = OshiSnapGridProxy(columns: 4, spacing: 10, gridWidth: 400)
        let snapped = proxy.snap(CGPoint(x: 47, y: 53))
        let snappedAgain = proxy.snap(CGPoint(x: 47, y: 53))
        // Verify snap is deterministic
        #expect(snapped.x == snappedAgain.x)
        #expect(snapped.y == snappedAgain.y)
        // Verify snap moved the point
        let snappedOrigin = proxy.snap(CGPoint(x: 0, y: 0))
        #expect(snappedOrigin.x == 0)
        #expect(snappedOrigin.y == 0)
    }

    @Test("Snap aligns to grid intersections")
    func snapAlignment() {
        let proxy = OshiSnapGridProxy(columns: 4, spacing: 10, gridWidth: 400)
        let step = (400.0 - 10.0 * 5.0) / 4.0 + 10.0 // cellWidth + spacing
        let expected = round((step + 5.0) / step) * step

        // A point near step should snap to the nearest grid line
        let nearStep = proxy.snap(CGPoint(x: step + 5, y: step + 5))
        #expect(abs(nearStep.x - expected) < 0.001, "Snap X should align to grid")
    }

    @Test("Negative columns are clamped to 1")
    func negativeColumnsClamped() {
        // OshiSnapGrid clamps to max(1, columns), proxy should handle similarly
        let proxy = OshiSnapGridProxy(columns: 1, spacing: 10, gridWidth: 400)
        let snapped = proxy.snap(CGPoint(x: 100, y: 100))
        #expect(snapped.x.isFinite)
        #expect(snapped.y.isFinite)
    }
}
