//
//  OshiUISpatialTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUISpatial

@Suite("OshiUISpatial — Module Integrity")
struct OshiUISpatialModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUISpatial.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

@Suite("OshiUISpatial — Depth Levels")
struct OshiDepthLevelTests {

    @Test("Shadow radii follow ascending order by depth")
    func shadowRadiiAscending() {
        let shallow = OshiLayeredCard<EmptyView>.DepthLevel.shallow
        let standard = OshiLayeredCard<EmptyView>.DepthLevel.standard
        let deep = OshiLayeredCard<EmptyView>.DepthLevel.deep

        #expect(shallow.shadowRadius < standard.shadowRadius)
        #expect(standard.shadowRadius < deep.shadowRadius)
    }

    @Test("Shadow offsets follow ascending order by depth")
    func shadowOffsetsAscending() {
        let shallow = OshiLayeredCard<EmptyView>.DepthLevel.shallow
        let standard = OshiLayeredCard<EmptyView>.DepthLevel.standard
        let deep = OshiLayeredCard<EmptyView>.DepthLevel.deep

        #expect(shallow.shadowOffset < standard.shadowOffset)
        #expect(standard.shadowOffset < deep.shadowOffset)
    }

    @Test("Shadow opacities follow ascending order by depth")
    func shadowOpacitiesAscending() {
        let shallow = OshiLayeredCard<EmptyView>.DepthLevel.shallow
        let standard = OshiLayeredCard<EmptyView>.DepthLevel.standard
        let deep = OshiLayeredCard<EmptyView>.DepthLevel.deep

        #expect(shallow.shadowOpacity < standard.shadowOpacity)
        #expect(standard.shadowOpacity < deep.shadowOpacity)
    }

    @Test("All shadow values are positive")
    func allShadowValuesPositive() {
        let levels: [OshiLayeredCard<EmptyView>.DepthLevel] = [.shallow, .standard, .deep]
        for level in levels {
            #expect(level.shadowRadius > 0)
            #expect(level.shadowOffset > 0)
            #expect(level.shadowOpacity > 0)
        }
    }
}
