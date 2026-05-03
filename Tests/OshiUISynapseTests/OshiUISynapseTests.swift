//
//  OshiUISynapseTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import Foundation
@testable import OshiUISynapse

@Suite("OshiUISynapse — Module Integrity")
struct OshiUISynapseModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUISynapse.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

@Suite("OshiUISynapse — Chat Message")
struct OshiChatMessageTests {

    @Test("Chat message initializes with defaults")
    func defaultInit() {
        let msg = OshiChatMessage(role: .user, content: "Hello")
        #expect(msg.role == .user)
        #expect(msg.content == "Hello")
        #expect(msg.id != UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
    }

    @Test("Chat message preserves explicit ID")
    func explicitID() {
        let id = UUID()
        let msg = OshiChatMessage(id: id, role: .assistant, content: "Hi")
        #expect(msg.id == id)
    }

    @Test("All roles are accessible")
    func allRoles() {
        let roles: [OshiChatMessage.Role] = [.user, .assistant, .system]
        #expect(roles.count == 3)
    }

    @Test("Role accessibility names are human-readable")
    func roleAccessibilityNames() {
        #expect(OshiChatMessage.Role.user.accessibilityName == "You")
        #expect(OshiChatMessage.Role.assistant.accessibilityName == "Assistant")
        #expect(OshiChatMessage.Role.system.accessibilityName == "System")
    }
}

@Suite("OshiUISynapse — Thinking Styles")
struct OshiThinkingStyleTests {

    @Test("All thinking styles are accessible")
    func allStyles() {
        let styles = OshiThinkingStyle.allCases
        #expect(styles.count == 3)
    }

    @Test("Particle counts are positive")
    func particleCountsPositive() {
        for style in OshiThinkingStyle.allCases {
            #expect(style.particleCount > 0, "\(style.rawValue) must have positive particle count")
        }
    }

    @Test("Speed values are positive")
    func speedPositive() {
        for style in OshiThinkingStyle.allCases {
            #expect(style.speed > 0, "\(style.rawValue) must have positive speed")
        }
    }

    @Test("Spiral has highest particle count")
    func spiralMostParticles() {
        #expect(OshiThinkingStyle.spiral.particleCount > OshiThinkingStyle.neural.particleCount)
        #expect(OshiThinkingStyle.spiral.particleCount > OshiThinkingStyle.pulse.particleCount)
    }
}

@Suite("OshiUISynapse — Cursor Styles")
struct OshiStreamCursorTests {

    @Test("All cursor styles have raw values")
    func cursorStyleRawValues() {
        let styles: [OshiStreamCursorStyle] = [.pulse, .block, .none]
        for style in styles {
            #expect(!style.rawValue.isEmpty)
        }
    }
}
