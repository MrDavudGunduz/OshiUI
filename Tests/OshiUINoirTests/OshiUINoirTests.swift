//
//  OshiUINoirTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUINoir

@Suite("OshiUINoir — Module Integrity")
struct OshiUINoirModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUINoir.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

@Suite("OshiUINoir — Toast Configuration")
struct OshiToastConfigurationTests {

    @Test("Default configuration uses top edge")
    func defaultEdge() {
        let config = OshiToastConfiguration.default
        #expect(config.edge == .top)
    }

    @Test("Default configuration uses 3-second duration")
    func defaultDuration() {
        let config = OshiToastConfiguration.default
        #expect(config.duration == .seconds(3))
    }

    @Test("Custom configuration preserves values")
    func customConfiguration() {
        let config = OshiToastConfiguration(edge: .bottom, duration: .seconds(5))
        #expect(config.edge == .bottom)
        #expect(config.duration == .seconds(5))
    }

    @Test("All edges are valid presentation positions")
    func allEdgesValid() {
        let edges: [Edge] = [.top, .bottom, .leading, .trailing]
        for edge in edges {
            let config = OshiToastConfiguration(edge: edge)
            #expect(config.edge == edge)
        }
    }
}
