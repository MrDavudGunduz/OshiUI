//
//  OshiPlatform.swift
//  OshiUI — Core Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI

/// Compile-time platform abstractions for multi-platform OshiUI components.
///
/// `OshiPlatform` eliminates scattered `#if os()` checks in view code by
/// providing centralized platform detection and capability queries.
///
/// ## Usage
///
/// ```swift
/// if OshiPlatform.supportsHaptics {
///     triggerHaptic()
/// }
///
/// Text("Current: \(OshiPlatform.current.displayName)")
/// ```
///
/// > Important: Never use raw `#if os()` in view code.
/// > Use `OshiPlatform` abstractions instead.
public enum OshiPlatform: String, Sendable, CaseIterable {

    /// Apple iOS (iPhone, iPad).
    case iOS

    /// Apple macOS.
    case macOS

    /// Apple visionOS (Apple Vision Pro).
    case visionOS

    // MARK: - Current Platform

    /// The platform this code is currently running on.
    public static var current: OshiPlatform {
        #if os(iOS)
        return .iOS
        #elseif os(macOS)
        return .macOS
        #elseif os(visionOS)
        return .visionOS
        #endif
    }

    /// A human-readable display name for the platform.
    public var displayName: String {
        switch self {
        case .iOS: "iOS"
        case .macOS: "macOS"
        case .visionOS: "visionOS"
        }
    }

    // MARK: - Capability Queries

    /// Whether the current platform supports UIKit haptic feedback.
    public static var supportsHaptics: Bool {
        #if os(iOS)
        return true
        #elseif os(macOS)
        return true
        #elseif os(visionOS)
        return false
        #endif
    }

    /// Whether the current platform supports touch-based interactions.
    public static var isTouchBased: Bool {
        #if os(iOS) || os(visionOS)
        return true
        #else
        return false
        #endif
    }

    /// Whether the current platform supports spatial/volumetric content.
    public static var supportsSpatial: Bool {
        #if os(visionOS)
        return true
        #else
        return false
        #endif
    }

    /// Whether the current platform uses pointer-based interaction (mouse/trackpad).
    public static var isPointerBased: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
}
