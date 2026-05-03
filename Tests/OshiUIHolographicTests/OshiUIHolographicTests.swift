//
//  OshiUIHolographicTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
@testable import OshiUIHolographic

@Suite("OshiUIHolographic — Module Integrity")
struct OshiUIHolographicModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUIHolographic.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}
