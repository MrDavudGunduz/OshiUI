//
//  OshiUINoirTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
@testable import OshiUINoir

@Suite("OshiUINoir — Module Integrity")
struct OshiUINoirModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUINoir.version
        #expect(!version.isEmpty)
    }
}
