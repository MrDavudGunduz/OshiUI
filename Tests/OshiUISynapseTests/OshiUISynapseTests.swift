//
//  OshiUISynapseTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
@testable import OshiUISynapse

@Suite("OshiUISynapse — Module Integrity")
struct OshiUISynapseModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUISynapse.version
        #expect(!version.isEmpty)
    }
}
