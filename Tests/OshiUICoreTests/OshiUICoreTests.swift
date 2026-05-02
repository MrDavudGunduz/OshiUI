//
//  OshiUICoreTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
@testable import OshiUICore

// MARK: - Module Availability

@Suite("OshiUICore — Module Integrity")
struct OshiUICoreModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUICore.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}
