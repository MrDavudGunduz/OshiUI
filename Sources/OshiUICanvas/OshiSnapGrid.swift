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
///
/// Use `OshiSnapGridProxy` to calculate snap positions when implementing
/// custom drag-to-snap interactions within an ``OshiSnapGrid``.
///
/// ## Usage
///
/// ```swift
/// let proxy = OshiSnapGridProxy(columns: 4, spacing: 12, gridWidth: 400)
/// let snappedPosition = proxy.snap(currentDragPosition)
/// ```
///
/// > Note: This utility is designed for manual drag integration.
/// > Built-in drag-to-snap gesture support is planned for a future release.
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
    ///
    /// The calculation accounts for the leading `spacing` offset before the
    /// first column, ensuring snap positions align with actual cell origins.
    public func snap(_ point: CGPoint) -> CGPoint {
        let cellWidth = (gridWidth - spacing * CGFloat(columns + 1)) / CGFloat(columns)
        let step = cellWidth + spacing
        // Translate into grid-local coordinates (remove leading spacing offset),
        // snap to nearest step, then translate back.
        let snappedX = round((point.x - spacing) / step) * step + spacing
        let snappedY = round((point.y - spacing) / step) * step + spacing
        return CGPoint(x: snappedX, y: snappedY)
    }
}

// MARK: - Preview Model

/// An identifiable grid cell model for preview demonstrations.
private struct PreviewGridCell: Identifiable {
    let id: Int
    var label: String { "\(id + 1)" }
}

// MARK: - Previews

#Preview("Snap Grid — 4 Columns") {
    let cells = (0..<8).map { PreviewGridCell(id: $0) }

    OshiSnapGrid(columns: 4, spacing: 12) {
        ForEach(cells) { cell in
            RoundedRectangle(cornerRadius: OshiSpacing.radiusSmall)
                .fill(OshiColor.surfaceElevated)
                .frame(height: 80)
                .overlay(
                    Text(cell.label)
                        .font(OshiTypography.bodyBold)
                        .foregroundStyle(OshiColor.neonCyan)
                )
        }
    }
    .background(OshiColor.surfaceDeep)
}
