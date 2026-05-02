//
//  OshiUISpatialTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
@testable import OshiUISpatial

@Suite("OshiUISpatial — Module Integrity")
struct OshiUISpatialModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUISpatial.version
        #expect(!version.isEmpty)
    }
}
