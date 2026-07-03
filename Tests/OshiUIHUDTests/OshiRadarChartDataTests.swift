//
//  OshiRadarChartDataTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUIHUD
@testable import OshiUICore

// MARK: - Radar Chart Data Handling

@Suite("OshiUIHUD — Radar Chart Data")
struct OshiRadarChartDataTests {

    @Test("Data values are clamped to 0...1 range")
    func dataIsClamped() {
        let chart = OshiRadarChart(
            data: [-0.5, 0.0, 0.5, 1.0, 1.5],
            axes: ["A", "B", "C", "D", "E"]
        )
        for value in chart.data {
            #expect(value >= 0.0, "Data values must be >= 0")
            #expect(value <= 1.0, "Data values must be <= 1")
        }
    }

    @Test("Data is padded to minimum 3 values")
    func dataPaddedToMinimum() {
        let chart = OshiRadarChart(
            data: [0.5],
            axes: ["A"]
        )
        #expect(chart.data.count >= 3, "Radar chart requires at least 3 data points")
    }

    @Test("Padded values default to zero")
    func paddedValuesAreZero() {
        let chart = OshiRadarChart(
            data: [0.8],
            axes: ["A"]
        )
        // Original value preserved, padded values are 0
        #expect(chart.data[0] == 0.8)
        for i in 1..<chart.data.count {
            #expect(chart.data[i] == 0.0, "Padded value at index \(i) must be 0.0")
        }
    }

    @Test("Matching data and axes counts produce correct count")
    func matchingCounts() {
        let chart = OshiRadarChart(
            data: [0.2, 0.4, 0.6, 0.8, 1.0],
            axes: ["A", "B", "C", "D", "E"]
        )
        #expect(chart.data.count == 5)
    }

    @Test("Empty data produces minimum 3 data points")
    func emptyDataProducesMinimum() {
        let chart = OshiRadarChart(
            data: [],
            axes: []
        )
        #expect(chart.data.count >= 3)
    }

    @Test("Default accent color is neonCyan")
    func defaultAccentColor() {
        let chart = OshiRadarChart(
            data: [0.5, 0.5, 0.5],
            axes: ["A", "B", "C"]
        )
        #expect(chart.accentColor == OshiColor.neonCyan)
    }

    @Test("Custom accent color is preserved")
    func customAccentColor() {
        let chart = OshiRadarChart(
            data: [0.5, 0.5, 0.5],
            axes: ["A", "B", "C"],
            accentColor: OshiColor.neonMagenta
        )
        #expect(chart.accentColor == OshiColor.neonMagenta)
    }
}
