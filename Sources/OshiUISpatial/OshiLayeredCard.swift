//
//  OshiLayeredCard.swift
//  OshiUI — Spatial Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

// MARK: - Depth Level (Top-Level)

/// The depth level for a layered card's shadow system.
///
/// Use `.lightweight` in `ScrollView` or `List` contexts with many cards
/// to avoid shadow stacking performance issues.
public enum OshiCardDepthLevel: Sendable {

    /// Subtle floating effect with minimal shadow.
    case shallow

    /// Default depth with balanced shadow.
    case standard

    /// Pronounced depth for hero cards.
    case deep

    /// Single-pass shadow optimized for lists and grids.
    ///
    /// Use this when rendering 10+ cards simultaneously to avoid
    /// GPU overhead from stacked shadow layers.
    case lightweight

    /// The blur radius for the depth shadow.
    public var shadowRadius: CGFloat {
        switch self {
        case .shallow: 8
        case .standard: 16
        case .deep: 30
        case .lightweight: 4
        }
    }

    /// The Y-offset for the depth shadow.
    public var shadowOffset: CGFloat {
        switch self {
        case .shallow: 4
        case .standard: 8
        case .deep: 16
        case .lightweight: 2
        }
    }

    /// The opacity of the depth shadow.
    public var shadowOpacity: Double {
        switch self {
        case .shallow: 0.15
        case .standard: 0.25
        case .deep: 0.4
        case .lightweight: 0.12
        }
    }
}

// MARK: - Layered Card

/// A 3D parallax card with layered shadow and highlight effects.
///
/// `OshiLayeredCard` creates a floating card sensation by applying depth
/// through layered shadows, specular highlights, and a subtle scale effect
/// on hover/press interactions.
///
/// Automatically respects the **Reduce Motion** accessibility setting
/// by disabling hover scale animations.
///
/// ## Usage
///
/// ```swift
/// OshiLayeredCard {
///     VStack {
///         Image(systemName: "cube.fill")
///             .font(.largeTitle)
///         Text("Spatial Card")
///     }
///     .padding()
/// }
///
/// OshiLayeredCard(depth: .deep, accentColor: .oshiMagenta) {
///     Text("Deep card")
/// }
/// ```
public struct OshiLayeredCard<Content: View>: View {

    /// The depth level affecting shadow intensity and offset.
    public let depth: OshiCardDepthLevel

    /// Optional neon accent color for the card border.
    public let accentColor: Color?

    /// The card content.
    @ViewBuilder public let content: () -> Content

    @State private var isHovered = false

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    /// Creates a layered 3D card.
    ///
    /// - Parameters:
    ///   - depth: The shadow depth level. Defaults to `.standard`.
    ///   - accentColor: Optional neon border accent. Defaults to `nil`.
    ///   - content: The card's content builder.
    public init(
        depth: OshiCardDepthLevel = .standard,
        accentColor: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.depth = depth
        self.accentColor = accentColor
        self.content = content
    }

    public var body: some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                    .fill(OshiColor.surfaceElevated)
            )
            .overlay(
                RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                    .stroke(
                        accentColor?.opacity(0.4) ?? .white.opacity(0.08),
                        lineWidth: accentColor != nil ? 1 : 0.5
                    )
            )
            .overlay(alignment: .topLeading) {
                // Specular highlight
                RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.08), .clear],
                            startPoint: .topLeading,
                            endPoint: .center
                        )
                    )
                    .allowsHitTesting(false)
            }
            .clipShape(RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium))
            .shadow(
                color: .black.opacity(depth.shadowOpacity),
                radius: depth.shadowRadius,
                y: depth.shadowOffset
            )
            .shadow(
                color: (accentColor ?? .clear).opacity(isHovered ? 0.15 : 0),
                radius: 20
            )
            .scaleEffect(reduceMotion ? 1.0 : (isHovered ? 1.02 : 1.0))
            .animation(
                reduceMotion ? nil : .spring(response: 0.4, dampingFraction: 0.7),
                value: isHovered
            )
            .onHover { hovering in
                isHovered = hovering
            }
            .accessibilityElement(children: .contain)
    }
}

// MARK: - Backward Compatibility Typealias

extension OshiLayeredCard {

    /// Backward-compatible type alias for ``OshiCardDepthLevel``.
    ///
    /// - Note: Prefer using `OshiCardDepthLevel` directly for cleaner type signatures.
    @available(*, deprecated, renamed: "OshiCardDepthLevel",
               message: "Use the top-level OshiCardDepthLevel instead.")
    public typealias DepthLevel = OshiCardDepthLevel
}

// MARK: - Previews

#Preview("Layered Card — Depths") {
    HStack(spacing: 24) {
        OshiLayeredCard(depth: .shallow) {
            VStack {
                Text("Shallow")
                    .font(OshiTypography.bodyBold)
                    .foregroundStyle(OshiColor.textPrimary)
            }
            .frame(width: 100, height: 80)
        }

        OshiLayeredCard(depth: .standard, accentColor: OshiColor.neonCyan) {
            VStack {
                Text("Standard")
                    .font(OshiTypography.bodyBold)
                    .foregroundStyle(OshiColor.textPrimary)
            }
            .frame(width: 100, height: 80)
        }

        OshiLayeredCard(depth: .deep, accentColor: OshiColor.neonMagenta) {
            VStack {
                Text("Deep")
                    .font(OshiTypography.bodyBold)
                    .foregroundStyle(OshiColor.textPrimary)
            }
            .frame(width: 100, height: 80)
        }
    }
    .padding(40)
    .background(OshiColor.surfaceDeep)
}
