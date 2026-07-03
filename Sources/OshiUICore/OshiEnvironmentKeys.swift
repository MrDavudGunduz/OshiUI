//
//  OshiEnvironmentKeys.swift
//  OshiUI — Core Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI

// MARK: - Reduced Effects

extension EnvironmentValues {

    /// Hints that child components should reduce GPU-intensive effects.
    ///
    /// When `true`, components should minimize shadow layers, disable
    /// hover glows, and prefer single-pass rendering. This is useful
    /// in performance-sensitive contexts such as `ScrollView` or `List`
    /// with many child components.
    ///
    /// Unlike `accessibilityReduceMotion`, this key is an **opt-in
    /// performance hint** set by the developer — not a system-wide
    /// accessibility preference.
    ///
    /// ```swift
    /// // Wrap a scroll context to reduce effects
    /// ScrollView {
    ///     LazyVStack {
    ///         ForEach(items) { item in
    ///             OshiLayeredCard { ItemRow(item) }
    ///         }
    ///     }
    /// }
    /// .oshiReducedEffects()
    /// ```
    @Entry public var oshiReducedEffects: Bool = false
}

// MARK: - View Extension

extension View {

    /// Enables reduced visual effects for child OshiUI components.
    ///
    /// Components that read this environment value will automatically
    /// downgrade to lighter rendering paths. For example,
    /// ``OshiLayeredCard`` switches to ``OshiCardDepthLevel/lightweight``
    /// shadow rendering.
    ///
    /// - Parameter reduced: Whether to reduce effects. Defaults to `true`.
    /// - Returns: A view with the reduced effects hint set.
    public func oshiReducedEffects(_ reduced: Bool = true) -> some View {
        environment(\.oshiReducedEffects, reduced)
    }
}
