//
//  OshiSnapGrid.swift
//  OshiUI — Canvas Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore
import OshiUISpatial

/// A magnetic snap grid layout for draggable components.
///
/// ## Usage
///
/// ```swift
/// OshiSnapGrid(columns: 4, spacing: 12) {
///     ForEach(widgets) { widget in
///         OshiResizableWidget { widget.content }
///     }
/// }
/// ```
public struct OshiSnapGrid<Content: View>: View {

    public let columns: Int
    public let spacing: CGFloat
    @ViewBuilder public let content: () -> Content

    public init(
        columns: Int = 4,
        spacing: CGFloat = OshiSpacing.md,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.columns = max(1, columns)
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns),
            spacing: spacing
        ) {
            content()
        }
        .padding(spacing)
    }
}

/// Provides snap-point calculation for ``OshiSnapGrid`` children.
public struct OshiSnapGridProxy: Sendable {
    public let columns: Int
    public let spacing: CGFloat
    public let gridWidth: CGFloat

    public init(columns: Int, spacing: CGFloat, gridWidth: CGFloat) {
        self.columns = columns
        self.spacing = spacing
        self.gridWidth = gridWidth
    }

    /// Snaps a point to the nearest grid intersection.
    public func snap(_ point: CGPoint) -> CGPoint {
        let cellWidth = (gridWidth - spacing * CGFloat(columns + 1)) / CGFloat(columns)
        let step = cellWidth + spacing
        return CGPoint(x: round(point.x / step) * step, y: round(point.y / step) * step)
    }
}

// MARK: - Previews

#Preview("Snap Grid — 4 Columns") {
    OshiSnapGrid(columns: 4, spacing: 12) {
        ForEach(0..<8, id: \.self) { index in
            RoundedRectangle(cornerRadius: OshiSpacing.radiusSmall)
                .fill(OshiColor.surfaceElevated)
                .frame(height: 80)
                .overlay(
                    Text("\(index + 1)")
                        .font(OshiTypography.bodyBold)
                        .foregroundStyle(OshiColor.neonCyan)
                )
        }
    }
    .background(OshiColor.surfaceDeep)
}

