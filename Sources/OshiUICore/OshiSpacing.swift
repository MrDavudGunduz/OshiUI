//
//  OshiSpacing.swift
//  OshiUI — Core Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI

/// The OshiUI spacing system — harmonious layout tokens on an 8pt grid.
///
/// `OshiSpacing` provides a consistent spatial rhythm across all components.
/// Values follow a modular scale based on an 8-point grid, ensuring visual
/// harmony and alignment precision.
///
/// ## Usage
///
/// ```swift
/// VStack(spacing: OshiSpacing.md) {
///     Text("Title")
///     Text("Subtitle")
/// }
/// .padding(OshiSpacing.lg)
/// ```
///
/// ## Scale
///
/// | Token | Value | Use Case |
/// |-------|-------|----------|
/// | `xxs` | 2pt | Hairline gaps, icon padding |
/// | `xs` | 4pt | Tight element spacing |
/// | `sm` | 8pt | Compact layouts |
/// | `md` | 12pt | Default content spacing |
/// | `lg` | 16pt | Section padding |
/// | `xl` | 24pt | Card insets, group spacing |
/// | `xxl` | 32pt | Major section breaks |
/// | `xxxl` | 48pt | Screen-level margins |
public enum OshiSpacing: Sendable {

    /// 2pt — hairline gaps and micro-adjustments.
    public static let xxs: CGFloat = 2

    /// 4pt — tight element spacing.
    public static let xs: CGFloat = 4

    /// 8pt — compact layout spacing.
    public static let sm: CGFloat = 8

    /// 12pt — default content spacing.
    public static let md: CGFloat = 12

    /// 16pt — section padding and comfortable gaps.
    public static let lg: CGFloat = 16

    /// 24pt — card insets and group separation.
    public static let xl: CGFloat = 24

    /// 32pt — major section breaks.
    public static let xxl: CGFloat = 32

    /// 48pt — screen-level margins and hero spacing.
    public static let xxxl: CGFloat = 48

    // MARK: - Corner Radius

    /// Small corner radius — buttons and badges (8pt).
    public static let radiusSmall: CGFloat = 8

    /// Medium corner radius — cards and panels (12pt).
    public static let radiusMedium: CGFloat = 12

    /// Large corner radius — modals and sheets (20pt).
    public static let radiusLarge: CGFloat = 20

    /// Full corner radius — pills and circular elements (9999pt).
    public static let radiusFull: CGFloat = 9999
}
