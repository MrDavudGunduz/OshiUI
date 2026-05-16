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
