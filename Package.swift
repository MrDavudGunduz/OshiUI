// swift-tools-version: 6.0
// ╔══════════════════════════════════════════════════════════════════╗
// ║  OshiUI — Next-Generation UI Framework for Apple Platforms      ║
// ║  Copyright © 2026 Davud Gunduz. All rights reserved.           ║
// ╚══════════════════════════════════════════════════════════════════╝

import PackageDescription

let package = Package(
    name: "OshiUI",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .visionOS(.v2)
    ],
    products: [
        // ── Umbrella Product ──────────────────────────────────────
        .library(name: "OshiUI", targets: ["OshiUI"]),

        // ── Granular Module Products ──────────────────────────────
        .library(name: "OshiUICore",        targets: ["OshiUICore"]),
        .library(name: "OshiUISpatial",     targets: ["OshiUISpatial"]),
        .library(name: "OshiUIKinetic",     targets: ["OshiUIKinetic"]),
        .library(name: "OshiUINoir",        targets: ["OshiUINoir"]),
        .library(name: "OshiUIHUD",         targets: ["OshiUIHUD"]),
        .library(name: "OshiUIHolographic", targets: ["OshiUIHolographic"]),
        .library(name: "OshiUISynapse",     targets: ["OshiUISynapse"]),
        .library(name: "OshiUICanvas",      targets: ["OshiUICanvas"]),
    ],
    dependencies: [],
    targets: [
        // ── Umbrella ──────────────────────────────────────────────
        .target(
            name: "OshiUI",
            dependencies: [
                "OshiUICore",
                "OshiUISpatial",
                "OshiUIKinetic",
                "OshiUINoir",
                "OshiUIHUD",
                "OshiUIHolographic",
                "OshiUISynapse",
                "OshiUICanvas",
            ],
            resources: [.process("PrivacyInfo.xcprivacy")]
        ),

        // ── Phase 1: Atomic Foundation ────────────────────────────
        .target(
            name: "OshiUICore",
            dependencies: []
        ),

        // ── Phase 2: Depth & Physics ──────────────────────────────
        .target(
            name: "OshiUISpatial",
            dependencies: ["OshiUICore"]
        ),
        .target(
            name: "OshiUIKinetic",
            dependencies: ["OshiUICore"]
        ),

        // ── Phase 3: Identity & Gamification ──────────────────────
        .target(
            name: "OshiUINoir",
            dependencies: ["OshiUICore", "OshiUIKinetic"]
        ),
        .target(
            name: "OshiUIHUD",
            dependencies: ["OshiUICore", "OshiUIKinetic"]
        ),

        // ── Phase 4: Spatial & AI ─────────────────────────────────
        .target(
            name: "OshiUIHolographic",
            dependencies: ["OshiUICore", "OshiUISpatial"]
        ),
        .target(
            name: "OshiUISynapse",
            dependencies: ["OshiUICore", "OshiUIKinetic"]
        ),

        // ── Phase 5: Flexible Workspaces ──────────────────────────
        .target(
            name: "OshiUICanvas",
            dependencies: ["OshiUICore", "OshiUISpatial"]
        ),

        // ── Test Targets ──────────────────────────────────────────
        .testTarget(name: "OshiUICoreTests",        dependencies: ["OshiUICore"]),
        .testTarget(name: "OshiUISpatialTests",     dependencies: ["OshiUISpatial"]),
        .testTarget(name: "OshiUIKineticTests",     dependencies: ["OshiUIKinetic"]),
        .testTarget(name: "OshiUINoirTests",        dependencies: ["OshiUINoir"]),
        .testTarget(name: "OshiUIHUDTests",         dependencies: ["OshiUIHUD"]),
        .testTarget(name: "OshiUIHolographicTests", dependencies: ["OshiUIHolographic"]),
        .testTarget(name: "OshiUISynapseTests",     dependencies: ["OshiUISynapse"]),
        .testTarget(name: "OshiUICanvasTests",      dependencies: ["OshiUICanvas"]),
    ],
    swiftLanguageModes: [.v6]
)
