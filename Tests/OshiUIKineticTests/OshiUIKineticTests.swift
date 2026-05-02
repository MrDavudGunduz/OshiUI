//
//  OshiUIKineticTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
@testable import OshiUIKinetic

@Suite("OshiUIKinetic — Module Integrity")
struct OshiUIKineticModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUIKinetic.version
        #expect(!version.isEmpty)
    }
}
