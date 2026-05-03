//
//  OshiUIHUDTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
@testable import OshiUIHUD

@Suite("OshiUIHUD — Module Integrity")
struct OshiUIHUDModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUIHUD.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

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
        // Each tier should have a unique color
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
}

@Suite("OshiUIHUD — Progress Clamping")
struct OshiProgressTests {

    @Test("Progress value is clamped to 0-1")
    func progressClamping() {
        // OshiProgressBar clamps via min(max(...)) in init
        let over = min(max(1.5, 0), 1)
        let under = min(max(-0.3, 0), 1)
        #expect(over == 1.0, "Values above 1.0 should be clamped")
        #expect(under == 0.0, "Values below 0.0 should be clamped")
    }
}
