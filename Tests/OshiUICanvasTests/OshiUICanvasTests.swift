//
//  OshiUICanvasTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
@testable import OshiUICanvas

@Suite("OshiUICanvas — Module Integrity")
struct OshiUICanvasModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUICanvas.version
        #expect(!version.isEmpty)
    }
}
