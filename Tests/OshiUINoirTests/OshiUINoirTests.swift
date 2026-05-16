//
//  OshiUINoirTests.swift
//  OshiUI
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import Testing
import SwiftUI
@testable import OshiUINoir
@testable import OshiUICore

@Suite("OshiUINoir — Module Integrity")
struct OshiUINoirModuleTests {

    @Test("Module version is valid semantic version")
    func moduleVersionFormat() {
        let version = OshiUINoir.version
        #expect(!version.isEmpty, "Module version must not be empty")
        #expect(version.contains("."), "Module version must follow semver format")
    }
}

// MARK: - Toast Configuration

@Suite("OshiUINoir — Toast Configuration")
struct OshiToastConfigurationTests {

    @Test("Default configuration uses top edge")
    func defaultEdge() {
        let config = OshiToastConfiguration.default
        #expect(config.edge == .top)
    }

    @Test("Default configuration uses 3-second duration")
    func defaultDuration() {
        let config = OshiToastConfiguration.default
        #expect(config.duration == .seconds(3))
    }

    @Test("Custom configuration preserves values")
    func customConfiguration() {
        let config = OshiToastConfiguration(edge: .bottom, duration: .seconds(5))
        #expect(config.edge == .bottom)
        #expect(config.duration == .seconds(5))
    }

    @Test("All edges are valid presentation positions")
    func allEdgesValid() {
        let edges: [Edge] = [.top, .bottom, .leading, .trailing]
        for edge in edges {
            let config = OshiToastConfiguration(edge: edge)
            #expect(config.edge == edge)
        }
    }

    @Test("Default static instance is consistent across calls")
    func defaultConsistency() {
        let a = OshiToastConfiguration.default
        let b = OshiToastConfiguration.default
        #expect(a.edge == b.edge)
        #expect(a.duration == b.duration)
    }

    @Test("Configuration is Sendable")
    func configSendable() {
        let config = OshiToastConfiguration.default
        let _: any Sendable = config
    }

    @Test("Zero duration is technically valid")
    func zeroDuration() {
        let config = OshiToastConfiguration(edge: .top, duration: .zero)
        #expect(config.duration == .zero)
    }

    @Test("Long duration is accepted")
    func longDuration() {
        let config = OshiToastConfiguration(edge: .bottom, duration: .seconds(30))
        #expect(config.duration == .seconds(30))
    }
}

// MARK: - Toast Model

@Suite("OshiUINoir — Toast Model")
@MainActor
struct OshiToastModelTests {

    @Test("Toast stores message correctly")
    func messageStorage() {
        let toast = OshiToast("Test Message")
        #expect(toast.message == "Test Message")
    }

    @Test("Toast stores optional icon")
    func iconStorage() {
        let withIcon = OshiToast("Test", icon: "checkmark")
        let withoutIcon = OshiToast("Test")
        #expect(withIcon.icon == "checkmark")
        #expect(withoutIcon.icon == nil)
    }

    @Test("Toast uses default glow color when not specified")
    func defaultGlow() {
        let toast = OshiToast("Test")
        #expect(toast.glow == OshiColor.neonCyan)
    }

    @Test("Toast accepts custom glow color")
    func customGlow() {
        let toast = OshiToast("Test", glow: OshiColor.neonCoral)
        #expect(toast.glow == OshiColor.neonCoral)
    }

    @Test("Toast with empty message is valid")
    func emptyMessage() {
        let toast = OshiToast("")
        #expect(toast.message.isEmpty)
    }

    @Test("Toast with all parameters preserves values")
    func fullInit() {
        let toast = OshiToast("Alert", icon: "bell.fill", glow: OshiColor.neonAmber)
        #expect(toast.message == "Alert")
        #expect(toast.icon == "bell.fill")
        #expect(toast.glow == OshiColor.neonAmber)
    }

    @Test("Toast body renders without crashing")
    func toastBodyRenders() {
        let toast = OshiToast("Test", icon: "checkmark.circle.fill", glow: OshiColor.neonLime)
        _ = toast.body
    }
}

// MARK: - Noir Card

@Suite("OshiUINoir — Noir Card")
@MainActor
struct OshiNoirCardTests {

    @Test("Noir card default accent is neon cyan")
    func defaultAccent() {
        let card = OshiNoirCard {
            Text("Test")
        }
        #expect(card.accentColor == OshiColor.neonCyan)
    }

    @Test("Noir card preserves custom accent color")
    func customAccent() {
        let card = OshiNoirCard(accentColor: OshiColor.neonMagenta) {
            Text("Test")
        }
        #expect(card.accentColor == OshiColor.neonMagenta)
    }

    @Test("Noir card body renders without crashing")
    func bodyRenders() {
        let card = OshiNoirCard {
            VStack {
                Text("STATUS")
                Text("ONLINE")
            }
        }
        _ = card.body
    }
}

// MARK: - Noir Divider

@Suite("OshiUINoir — Noir Divider")
@MainActor
struct OshiNoirDividerTests {

    @Test("Divider default color is neon cyan")
    func defaultColor() {
        let divider = OshiNoirDivider()
        #expect(divider.color == OshiColor.neonCyan)
    }

    @Test("Divider preserves custom color")
    func customColor() {
        let divider = OshiNoirDivider(color: OshiColor.neonAmber)
        #expect(divider.color == OshiColor.neonAmber)
    }

    @Test("Divider body renders without crashing")
    func bodyRenders() {
        let divider = OshiNoirDivider()
        _ = divider.body
    }
}

// MARK: - Toast Modifier Integration

@Suite("OshiUINoir — Toast Modifier Integration")
@MainActor
struct OshiToastModifierIntegrationTests {

    @Test("Toast modifier can be constructed with default configuration")
    func toastModifierConstruction() {
        var isPresented = true
        let binding = Binding(get: { isPresented }, set: { isPresented = $0 })
        let modifier = OshiToastModifier(
            isPresented: binding,
            configuration: .default,
            toastContent: { OshiToast("Test Toast") }
        )
        #expect(modifier.configuration.edge == .top)
        #expect(modifier.configuration.duration == .seconds(3))
    }

    @Test("Toast modifier preserves custom configuration")
    func toastModifierCustomConfig() {
        var isPresented = false
        let binding = Binding(get: { isPresented }, set: { isPresented = $0 })
        let config = OshiToastConfiguration(edge: .bottom, duration: .seconds(5))
        let modifier = OshiToastModifier(
            isPresented: binding,
            configuration: config,
            toastContent: { OshiToast("Custom Toast") }
        )
        #expect(modifier.configuration.edge == .bottom)
        #expect(modifier.configuration.duration == .seconds(5))
    }

    @Test("All edge configurations produce valid toast modifiers")
    func allEdgeConfigurations() {
        let edges: [Edge] = [.top, .bottom, .leading, .trailing]
        for edge in edges {
            var isPresented = true
            let binding = Binding(get: { isPresented }, set: { isPresented = $0 })
            let config = OshiToastConfiguration(edge: edge, duration: .seconds(1))
            let modifier = OshiToastModifier(
                isPresented: binding,
                configuration: config,
                toastContent: { OshiToast("Edge: \(edge)") }
            )
            #expect(modifier.configuration.edge == edge)
        }
    }

    @Test("View extension oshiToast applies without crashing")
    func viewExtensionToast() {
        var isPresented = true
        let binding = Binding(get: { isPresented }, set: { isPresented = $0 })
        // Verify the view extension can be called and produces a valid view type
        let view = Text("Content")
            .oshiToast(isPresented: binding) {
                OshiToast("Extension Toast", icon: "checkmark")
            }
        _ = view
    }
}
