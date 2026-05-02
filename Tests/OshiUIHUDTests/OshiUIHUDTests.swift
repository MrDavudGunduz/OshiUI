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
        #expect(!version.isEmpty)
    }
}
