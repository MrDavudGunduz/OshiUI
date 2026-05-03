//
//  OshiUICore.swift
//  OshiUI — Core Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUICore
///
/// The atomic foundation layer of the OshiUI design system.
///
/// `OshiUICore` provides the fundamental design tokens that power every component
/// across the framework. It establishes a consistent visual language through:
///
/// - **Color Engine**: Futuristic neon-glow colors and `ShapeStyle` primitives
///   with built-in depth and luminosity
/// - **Typography System**: A dynamic type scale that respects accessibility
///   settings while maintaining the OshiUI aesthetic
/// - **Spacing Tokens**: A harmonious spacing scale based on an 8pt grid
/// - **Platform Abstractions**: Compile-time utilities for multi-platform adaptation
///
/// ## Architecture Rules
///
/// > Important: All collection views **must** use `Identifiable`-based data.
/// > Hardcoded index access (`items[i]`) is architecturally prohibited.
///
/// ```swift
/// // ✅ Correct — Identifiable-first
/// ForEach(items) { item in
///     OshiCard(item: item)
/// }
///
/// // ❌ Prohibited — index-based access
/// ForEach(0..<items.count, id: \.self) { i in
///     OshiCard(item: items[i])
/// }
/// ```
///
/// ## Topics
///
/// ### Design Tokens
/// - ``OshiColor``
/// - ``OshiTypography``
/// - ``OshiSpacing``
///
/// ### Platform
/// - ``OshiPlatform``

import SwiftUI

// MARK: - Module Namespace

/// The `OshiUICore` namespace.
///
/// This enum serves as a namespace anchor for the Core module.
/// It does not contain cases — use the module's public types directly.
public enum OshiUICore {

    /// The semantic version of the OshiUICore module.
    public static let version = "1.0.0-alpha"
}
