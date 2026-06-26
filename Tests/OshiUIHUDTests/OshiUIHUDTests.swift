//
//  OshiUIHUDTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUIHUD
@testable import OshiUICore

@Suite("OshiUIHUD — Module Integrity")
struct OshiUIHUDModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUIHUD.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

// MARK: - Achievement Tiers

@Suite("OshiUIHUD — Achievement Tiers")
struct OshiAchievementTierTests {

    @Test("All tier cases exist")
    func allTierCases() {
        let tiers = OshiAchievementTier.allCases
        #expect(tiers.count == 4)
    }

    @Test("All tiers have non-empty icon names")
    func tiersHaveIcons() {
        for tier in OshiAchievementTier.allCases {
            #expect(!tier.icon.isEmpty, "\(tier.rawValue) must have an icon")
        }
    }

    @Test("Tiers have distinct colors")
    func tiersHaveDistinctColors() {
        let colors = OshiAchievementTier.allCases.map { $0.color }
        for i in 0..<colors.count {
            for j in (i + 1)..<colors.count {
                #expect(colors[i] != colors[j],
                        "Tier colors should be distinct")
            }
        }
    }

    @Test("Tier raw values are lowercase")
    func tierRawValues() {
        for tier in OshiAchievementTier.allCases {
            #expect(tier.rawValue == tier.rawValue.lowercased(),
                    "Tier raw values should be lowercase")
        }
    }

    @Test("All tiers use SF Symbol icon names")
    func tierIconsAreSFSymbols() {
        for tier in OshiAchievementTier.allCases {
            let icon = tier.icon
            #expect(icon.contains("."),
                    "\(tier.rawValue) icon should be a valid SF Symbol name")
        }
    }
}

// MARK: - Progress Bar

@Suite("OshiUIHUD — Progress Bar")
@MainActor
struct OshiProgressTests {

    @Test("Progress value is clamped to 0-1 — above 1.0")
    func progressClampingAbove() {
        let bar = OshiProgressBar(value: 1.5)
        #expect(bar.value == 1.0, "Values above 1.0 should be clamped")
    }

    @Test("Progress value is clamped to 0-1 — below 0.0")
    func progressClampingBelow() {
        let bar = OshiProgressBar(value: -0.3)
        #expect(bar.value == 0.0, "Values below 0.0 should be clamped")
    }

    @Test("Normal progress values are preserved")
    func normalValues() {
        let bar = OshiProgressBar(value: 0.5)
        #expect(bar.value == 0.5)
    }

    @Test("Boundary values are preserved exactly")
    func boundaryValues() {
        let zero = OshiProgressBar(value: 0.0)
        let one = OshiProgressBar(value: 1.0)
        #expect(zero.value == 0.0)
        #expect(one.value == 1.0)
    }

    @Test("Default style is kinetic")
    func defaultStyle() {
        let bar = OshiProgressBar(value: 0.5)
        #expect(bar.style == .kinetic)
    }

    @Test("Default accent color is neon cyan")
    func defaultAccentColor() {
        let bar = OshiProgressBar(value: 0.5)
        #expect(bar.accentColor == OshiColor.neonCyan)
    }

    @Test("Custom accent color is preserved")
    func customAccentColor() {
        let bar = OshiProgressBar(value: 0.5, accentColor: OshiColor.neonLime)
        #expect(bar.accentColor == OshiColor.neonLime)
    }

    @Test("Custom style is preserved")
    func customStyle() {
        let standard = OshiProgressBar(value: 0.5, style: .standard)
        let instant = OshiProgressBar(value: 0.5, style: .instant)
        #expect(standard.style == .standard)
        #expect(instant.style == .instant)
    }
}

// MARK: - Progress Style

@Suite("OshiUIHUD — Progress Styles")
struct OshiProgressStyleTests {

    @Test("Standard style has eased animation")
    func standardHasAnimation() {
        let animation = OshiProgressStyle.standard.animation
        #expect(animation != nil, "Standard style should have an animation")
    }

    @Test("Kinetic style has spring animation")
    func kineticHasSpringAnimation() {
        let animation = OshiProgressStyle.kinetic.animation
        #expect(animation != nil, "Kinetic style should have a spring animation")
    }

    @Test("Instant style has no animation")
    func instantHasNoAnimation() {
        let animation = OshiProgressStyle.instant.animation
        #expect(animation == nil, "Instant style should have no animation")
    }

    @Test("Progress styles are Equatable")
    func stylesEquatable() {
        #expect(OshiProgressStyle.kinetic == OshiProgressStyle.kinetic)
        #expect(OshiProgressStyle.standard == OshiProgressStyle.standard)
        #expect(OshiProgressStyle.instant == OshiProgressStyle.instant)
        #expect(OshiProgressStyle.kinetic != OshiProgressStyle.standard)
    }
}

// MARK: - Radar Chart

@Suite("OshiUIHUD — Radar Chart")
@MainActor
struct OshiRadarChartTests {

    @Test("Data values are clamped to 0-1")
    func dataClamping() {
        let chart = OshiRadarChart(
            data: [1.5, -0.5, 0.5],
            axes: ["A", "B", "C"]
        )
        for value in chart.data {
            #expect(value >= 0.0 && value <= 1.0, "Data values must be in [0, 1]")
        }
    }

    @Test("Default accent color is neon cyan")
    func defaultAccent() {
        let chart = OshiRadarChart(data: [0.5], axes: ["A"])
        #expect(chart.accentColor == OshiColor.neonCyan)
    }

    @Test("Custom accent color is preserved")
    func customAccent() {
        let chart = OshiRadarChart(
            data: [0.5],
            axes: ["A"],
            accentColor: OshiColor.neonLime
        )
        #expect(chart.accentColor == OshiColor.neonLime)
    }

    @Test("Data with fewer than 3 values is padded to minimum polygon size")
    func dataPaddedToMinimum() {
        let single = OshiRadarChart(data: [0.8], axes: ["A"])
        #expect(single.data.count >= 3, "Data must be padded to at least 3 for valid polygon")
        #expect(single.data[0] == 0.8, "Original value must be preserved")
        #expect(single.data[1] == 0.0, "Padded values should be zero")
        #expect(single.data[2] == 0.0, "Padded values should be zero")
    }

    @Test("Data with exactly 2 values is padded to 3")
    func twoValuesPadded() {
        let chart = OshiRadarChart(data: [0.5, 0.7], axes: ["A", "B"])
        #expect(chart.data.count == 3)
        #expect(chart.data[0] == 0.5)
        #expect(chart.data[1] == 0.7)
        #expect(chart.data[2] == 0.0)
    }

    @Test("Data with 3+ values is not modified in count")
    func threeOrMoreUnchanged() {
        let chart = OshiRadarChart(data: [0.1, 0.2, 0.3, 0.4], axes: ["A", "B", "C", "D"])
        #expect(chart.data.count == 4)
    }

    @Test("Empty data is padded to 3 zeros")
    func emptyDataPadded() {
        let chart = OshiRadarChart(data: [], axes: [])
        #expect(chart.data.count == 3)
        for value in chart.data {
            #expect(value == 0.0)
        }
    }

    @Test("Single value chart renders body without crash")
    func singleValueBodyRenders() {
        let chart = OshiRadarChart(data: [0.5], axes: ["A"])
        _ = chart.body
    }
}

// MARK: - Radar Chart Edge Cases

@Suite("OshiUIHUD — Radar Chart Edge Cases")
@MainActor
struct OshiRadarChartEdgeCaseTests {

    @Test("Mismatched data and axes counts — more data than axes")
    func moreDataThanAxes() {
        let chart = OshiRadarChart(
            data: [0.5, 0.6, 0.7, 0.8, 0.9],
            axes: ["A", "B", "C"]
        )
        // Extra data values are present but rendered without labels
        #expect(chart.data.count == 5)
    }

    @Test("Mismatched data and axes counts — more axes than data")
    func moreAxesThanData() {
        let chart = OshiRadarChart(
            data: [0.5],
            axes: ["A", "B", "C", "D", "E"]
        )
        // Data is padded to at least 3 elements
        #expect(chart.data.count >= 3)
    }

    @Test("All-zero data renders without crash")
    func allZeroData() {
        let chart = OshiRadarChart(
            data: [0.0, 0.0, 0.0, 0.0],
            axes: ["A", "B", "C", "D"]
        )
        for value in chart.data {
            #expect(value == 0.0)
        }
        _ = chart.body
    }

    @Test("All-one data renders without crash")
    func allOneData() {
        let chart = OshiRadarChart(
            data: [1.0, 1.0, 1.0, 1.0],
            axes: ["A", "B", "C", "D"]
        )
        for value in chart.data {
            #expect(value == 1.0)
        }
        _ = chart.body
    }

    @Test("Extreme clamping preserves count")
    func extremeClampingPreservesCount() {
        let chart = OshiRadarChart(
            data: [-100, 200, -0.001, 1.001],
            axes: ["A", "B", "C", "D"]
        )
        #expect(chart.data.count == 4)
        #expect(chart.data[0] == 0.0, "Large negative clamped to 0")
        #expect(chart.data[1] == 1.0, "Large positive clamped to 1")
        #expect(chart.data[2] == 0.0, "Small negative clamped to 0")
        #expect(chart.data[3] == 1.0, "Slightly above 1 clamped to 1")
    }

    @Test("Large axis count renders body without crash")
    func largeAxisCount() {
        let data = Array(repeating: 0.5, count: 20)
        let axes = (0..<20).map { "Axis \($0)" }
        let chart = OshiRadarChart(data: data, axes: axes)
        #expect(chart.data.count == 20)
        _ = chart.body
    }
}
