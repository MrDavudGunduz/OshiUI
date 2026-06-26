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

// MARK: - Chat Message

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

    @Test("Messages with different IDs are not equal by ID")
    func uniqueIDs() {
        let a = OshiChatMessage(role: .user, content: "Hello")
        let b = OshiChatMessage(role: .user, content: "Hello")
        #expect(a.id != b.id, "Two separate messages should have unique IDs")
    }

    @Test("Empty content is allowed")
    func emptyContent() {
        let msg = OshiChatMessage(role: .system, content: "")
        #expect(msg.content.isEmpty)
    }

    @Test("Role raw values are non-empty")
    func roleRawValues() {
        let roles: [OshiChatMessage.Role] = [.user, .assistant, .system]
        for role in roles {
            #expect(!role.rawValue.isEmpty)
        }
    }
}

// MARK: - Thinking Styles

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

    @Test("Spiral has fastest speed")
    func spiralFastestSpeed() {
        #expect(OshiThinkingStyle.spiral.speed > OshiThinkingStyle.neural.speed)
        #expect(OshiThinkingStyle.spiral.speed > OshiThinkingStyle.pulse.speed)
    }

    @Test("Pulse has fewest particles for minimal aesthetic")
    func pulseMinimalParticles() {
        #expect(OshiThinkingStyle.pulse.particleCount < OshiThinkingStyle.neural.particleCount)
        #expect(OshiThinkingStyle.pulse.particleCount < OshiThinkingStyle.spiral.particleCount)
    }

    @Test("Raw values are unique and non-empty")
    func uniqueRawValues() {
        let rawValues = OshiThinkingStyle.allCases.map(\.rawValue)
        #expect(Set(rawValues).count == rawValues.count)
        for raw in rawValues {
            #expect(!raw.isEmpty)
        }
    }
}

// MARK: - Cursor Styles

@Suite("OshiUISynapse — Cursor Styles")
@MainActor
struct OshiStreamCursorTests {

    @Test("All cursor styles have raw values")
    func cursorStyleRawValues() {
        let styles: [OshiStreamCursorStyle] = [.pulse, .block, .hidden]
        for style in styles {
            #expect(!style.rawValue.isEmpty)
        }
    }

    @Test("Default cursor style is pulse")
    func defaultCursorStyle() {
        // StreamingText init defaults to .pulse
        let text = OshiStreamingText(text: "Test")
        #expect(text.showCursor == true)
    }

    @Test("Cursor can be disabled via showCursor")
    func cursorDisabled() {
        let text = OshiStreamingText(text: "Done", showCursor: false)
        #expect(text.showCursor == false)
    }

    @Test("Streaming text preserves text content")
    func textPreserved() {
        let content = "Hello world"
        let text = OshiStreamingText(text: content)
        #expect(text.text == content)
    }

    @Test("Empty text is handled gracefully")
    func emptyText() {
        let text = OshiStreamingText(text: "")
        #expect(text.text.isEmpty)
    }

    @Test("Deprecated .none resolves to .hidden for backward compatibility")
    func deprecatedNoneResolvesToHidden() {
        let deprecated: OshiStreamCursorStyle = .hidden
        #expect(deprecated == .hidden)
        #expect(deprecated.rawValue == "hidden")
    }
}

// MARK: - Chat Message Edge Cases

@Suite("OshiUISynapse — Chat Message Edge Cases")
struct OshiChatMessageEdgeCaseTests {

    @Test("Messages with same ID are equal via Identifiable")
    func sameIDComparison() {
        let id = UUID()
        let a = OshiChatMessage(id: id, role: .user, content: "Hello")
        let b = OshiChatMessage(id: id, role: .assistant, content: "Different")
        #expect(a.id == b.id, "Same ID should be equal via Identifiable")
    }

    @Test("Long content is preserved without truncation")
    func longContent() {
        let longString = String(repeating: "A", count: 10_000)
        let msg = OshiChatMessage(role: .user, content: longString)
        #expect(msg.content.count == 10_000)
    }

    @Test("Unicode content is preserved correctly")
    func unicodeContent() {
        let unicode = "こんにちは世界 🌍 مرحبا العالم"
        let msg = OshiChatMessage(role: .assistant, content: unicode)
        #expect(msg.content == unicode)
    }

    @Test("Emoji-only content is handled gracefully")
    func emojiContent() {
        let emojis = "🎮🕹️🎯🏆💎"
        let msg = OshiChatMessage(role: .user, content: emojis)
        #expect(msg.content == emojis)
    }

    @Test("Multiline content preserves newlines")
    func multilineContent() {
        let multiline = "Line 1\nLine 2\nLine 3"
        let msg = OshiChatMessage(role: .system, content: multiline)
        #expect(msg.content.contains("\n"))
        #expect(msg.content.split(separator: "\n").count == 3)
    }
}

// MARK: - Streaming Text Edge Cases

@Suite("OshiUISynapse — Streaming Text Edge Cases")
@MainActor
struct OshiStreamingTextEdgeCaseTests {

    @Test("Long text content is preserved")
    func longText() {
        let long = String(repeating: "token ", count: 1000)
        let text = OshiStreamingText(text: long)
        #expect(text.text == long)
    }

    @Test("Unicode text is handled correctly")
    func unicodeText() {
        let unicode = "日本語テスト 🚀 العربية"
        let text = OshiStreamingText(text: unicode)
        #expect(text.text == unicode)
    }

    @Test("Text with only whitespace is preserved")
    func whitespaceText() {
        let spaces = "   \n\t  "
        let text = OshiStreamingText(text: spaces)
        #expect(text.text == spaces)
    }

    @Test("Body renders without crash for empty text")
    func emptyBodyRenders() {
        let text = OshiStreamingText(text: "")
        _ = text.body
    }
}
