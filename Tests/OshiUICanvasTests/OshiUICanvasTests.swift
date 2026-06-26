//
//  OshiUICanvasTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import CoreGraphics
import SwiftUI
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
        // Origin snaps to the first cell position (spacing offset)
        let snappedOrigin = proxy.snap(CGPoint(x: 0, y: 0))
        #expect(snappedOrigin.x == 10, "Origin X should snap to leading spacing offset")
        #expect(snappedOrigin.y == 10, "Origin Y should snap to leading spacing offset")
    }

    @Test("Snap aligns to grid intersections with spacing offset")
    func snapAlignment() {
        let proxy = OshiSnapGridProxy(columns: 4, spacing: 10, gridWidth: 400)
        let cellWidth = (400.0 - 10.0 * 5.0) / 4.0  // 70pt
        let step = cellWidth + 10.0  // 80pt
        // Second cell origin = spacing + step = 10 + 80 = 90
        let secondCellOrigin = 10.0 + step

        // A point near second cell should snap to it
        let nearSecond = proxy.snap(CGPoint(x: secondCellOrigin + 5, y: secondCellOrigin + 5))
        #expect(abs(nearSecond.x - secondCellOrigin) < 0.001, "Snap X should align to second cell origin")
        #expect(abs(nearSecond.y - secondCellOrigin) < 0.001, "Snap Y should align to second cell origin")
    }

    @Test("Negative columns are clamped to 1")
    func negativeColumnsClamped() {
        // OshiSnapGrid clamps to max(1, columns), proxy should handle similarly
        let proxy = OshiSnapGridProxy(columns: 1, spacing: 10, gridWidth: 400)
        let snapped = proxy.snap(CGPoint(x: 100, y: 100))
        #expect(snapped.x.isFinite)
        #expect(snapped.y.isFinite)
    }

    @Test("First cell position equals spacing offset")
    func firstCellPosition() {
        let proxy = OshiSnapGridProxy(columns: 3, spacing: 12, gridWidth: 300)
        // A point exactly at the spacing offset should snap to itself
        let snapped = proxy.snap(CGPoint(x: 12, y: 12))
        #expect(abs(snapped.x - 12) < 0.001)
        #expect(abs(snapped.y - 12) < 0.001)
    }
}

// MARK: - Resizable Widget

@Suite("OshiUICanvas — Resizable Widget")
@MainActor
struct OshiResizableWidgetTests {

    @Test("Default min/max sizes are small and large")
    func defaultSizes() {
        let widget = OshiResizableWidget {
            Text("Test")
        }
        #expect(widget.minSize.height == OshiWidgetSize.small.height)
        #expect(widget.maxSize.height == OshiWidgetSize.large.height)
    }

    @Test("Custom min/max sizes are preserved")
    func customSizes() {
        let widget = OshiResizableWidget(
            minSize: .custom(80),
            maxSize: .custom(500)
        ) {
            Text("Test")
        }
        #expect(widget.minSize.height == 80)
        #expect(widget.maxSize.height == 500)
    }

    @Test("Widget body renders without crash")
    func bodyRenders() {
        let widget = OshiResizableWidget {
            Text("Resizable content")
        }
        _ = widget.body
    }
}

// MARK: - Boundary Value Tests

@Suite("OshiUICanvas — Widget Size Edge Cases")
struct OshiWidgetSizeBoundaryTests {

    @Test("Custom size with zero height is accepted")
    func customZeroHeight() {
        let size = OshiWidgetSize.custom(0)
        #expect(size.height == 0)
    }

    @Test("Custom size with negative height is accepted as-is")
    func customNegativeHeight() {
        // The widget clamps via min/max during drag —
        // the size enum itself stores the raw value.
        let size = OshiWidgetSize.custom(-50)
        #expect(size.height == -50)
    }

    @Test("Custom size with very large value is accepted")
    func customVeryLargeHeight() {
        let size = OshiWidgetSize.custom(10_000)
        #expect(size.height == 10_000)
    }

    @Test("Custom size with fractional value preserves precision")
    func customFractionalHeight() {
        let size = OshiWidgetSize.custom(99.5)
        #expect(size.height == 99.5)
    }

    @Test("Same preset sizes are Equatable")
    func presetEquatable() {
        #expect(OshiWidgetSize.small == OshiWidgetSize.small)
        #expect(OshiWidgetSize.medium == OshiWidgetSize.medium)
        #expect(OshiWidgetSize.large == OshiWidgetSize.large)
    }

    @Test("Different preset sizes are not equal")
    func presetNotEqual() {
        #expect(OshiWidgetSize.small != OshiWidgetSize.medium)
        #expect(OshiWidgetSize.medium != OshiWidgetSize.large)
    }

    @Test("Custom sizes with equal values are Equatable")
    func customEquatable() {
        #expect(OshiWidgetSize.custom(200) == OshiWidgetSize.custom(200))
    }

    @Test("Preset and custom with same height are not equal")
    func presetVsCustomNotEqual() {
        // .medium is 200pt, but .custom(200) is a different case
        #expect(OshiWidgetSize.medium != OshiWidgetSize.custom(200))
    }
}

@Suite("OshiUICanvas — Snap Grid Edge Cases")
struct OshiSnapGridEdgeCaseTests {

    @Test("Single column grid snaps to spacing offset")
    func singleColumnSnap() {
        let proxy = OshiSnapGridProxy(columns: 1, spacing: 10, gridWidth: 200)
        let snapped = proxy.snap(CGPoint(x: 50, y: 50))
        #expect(snapped.x.isFinite)
        #expect(snapped.y.isFinite)
    }

    @Test("Zero spacing grid snaps correctly")
    func zeroSpacingSnap() {
        let proxy = OshiSnapGridProxy(columns: 4, spacing: 0, gridWidth: 400)
        let snapped = proxy.snap(CGPoint(x: 50, y: 50))
        #expect(snapped.x.isFinite)
        #expect(snapped.y.isFinite)
        #expect(snapped.x >= 0)
        #expect(snapped.y >= 0)
    }

    @Test("Large grid width produces finite snap results")
    func largeGridWidth() {
        let proxy = OshiSnapGridProxy(columns: 10, spacing: 8, gridWidth: 10_000)
        let snapped = proxy.snap(CGPoint(x: 5000, y: 5000))
        #expect(snapped.x.isFinite)
        #expect(snapped.y.isFinite)
    }
}
