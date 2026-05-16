//
//  OshiRadarChart.swift
//  OshiUI — HUD Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

// MARK: - Identifiable Index Wrappers

/// An identifiable axis index for ``OshiRadarChart`` iteration.
private struct RadarAxisIndex: Identifiable {
    let id: Int
}

/// An identifiable ring index for ``OshiRadarChart`` grid rings.
private struct RadarRingIndex: Identifiable {
    let id: Int
}

/// A multi-axis radar (spider) chart for visualizing comparative statistics.
///
/// `OshiRadarChart` respects the **Reduce Motion** accessibility setting
/// by disabling the entry animation when enabled.
///
/// ## Usage
///
/// ```swift
/// OshiRadarChart(
///     data: [0.8, 0.6, 0.9, 0.5, 0.7],
///     axes: ["ATK", "DEF", "SPD", "INT", "LCK"]
/// )
/// .oshiRadarFill(OshiColor.gradient(.oshiCyan, .oshiViolet))
/// ```
public struct OshiRadarChart: View {

    /// Normalized data values (0.0 to 1.0) for each axis.
    public let data: [Double]

    /// Label strings for each axis.
    public let axes: [String]

    /// The accent color for the data polygon.
    public let accentColor: Color

    @State private var animatedData: [Double] = []

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    /// Creates a radar chart.
    ///
    /// - Parameters:
    ///   - data: Normalized values (0.0–1.0), one per axis.
    ///   - axes: Axis label strings.
    ///   - accentColor: Fill/stroke accent. Defaults to ``OshiColor/neonCyan``.
    public init(
        data: [Double],
        axes: [String],
        accentColor: Color = OshiColor.neonCyan
    ) {
        // Pad data to at least 3 values so the radar polygon is always valid.
        // Values beyond the axis count are silently discarded during rendering.
        let clamped = data.map { min(max($0, 0), 1) }
        let resolvedCount = max(clamped.count, 3)
        if clamped.count < resolvedCount {
            self.data = clamped + Array(repeating: 0.0, count: resolvedCount - clamped.count)
        } else {
            self.data = clamped
        }
        self.axes = axes
        self.accentColor = accentColor
    }

    public var body: some View {
        let count = max(data.count, 3)
        let axisIndices = (0..<count).map { RadarAxisIndex(id: $0) }
        let ringIndices = (1...4).map { RadarRingIndex(id: $0) }
        let labelIndices = (0..<min(axes.count, count)).map { RadarAxisIndex(id: $0) }

        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            let radius = size * 0.35

            ZStack {
                // Grid rings
                ForEach(ringIndices) { ring in
                    radarPath(
                        values: Array(repeating: Double(ring.id) / 4.0, count: count),
                        center: center,
                        radius: radius
                    )
                    .stroke(OshiColor.textTertiary.opacity(0.3), lineWidth: 0.5)
                }

                // Axis lines
                ForEach(axisIndices) { axis in
                    let angle = angleFor(index: axis.id, total: count)
                    Path { path in
                        path.move(to: center)
                        path.addLine(to: point(
                            center: center, radius: radius,
                            angle: angle, value: 1.0
                        ))
                    }
                    .stroke(OshiColor.textTertiary.opacity(0.2), lineWidth: 0.5)
                }

                // Data polygon
                radarPath(
                    values: resolvedAnimatedData(count: count),
                    center: center,
                    radius: radius
                )
                .fill(accentColor.opacity(0.15))

                radarPath(
                    values: resolvedAnimatedData(count: count),
                    center: center,
                    radius: radius
                )
                .stroke(accentColor, lineWidth: 1.5)

                // Data points
                ForEach(axisIndices) { axis in
                    let resolved = resolvedAnimatedData(count: count)
                    let value = axis.id < resolved.count ? resolved[axis.id] : 0
                    let angle = angleFor(index: axis.id, total: count)
                    let pos = point(center: center, radius: radius, angle: angle, value: value)

                    Circle()
                        .fill(accentColor)
                        .frame(width: 6, height: 6)
                        .position(pos)
                        .shadow(color: accentColor.opacity(0.4), radius: 4)
                }

                // Axis labels
                ForEach(labelIndices) { axis in
                    let angle = angleFor(index: axis.id, total: count)
                    let labelPos = point(
                        center: center, radius: radius + 20,
                        angle: angle, value: 1.0
                    )

                    Text(axes[axis.id])
                        .font(OshiTypography.codeSmall)
                        .foregroundStyle(OshiColor.textSecondary)
                        .position(labelPos)
                }
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            if reduceMotion {
                animatedData = data
            } else {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                    animatedData = data
                }
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Radar chart with \(axes.count) axes")
        .accessibilityValue(accessibilityDescription)
    }

    // MARK: - Resolved Data

    /// Returns animated data padded to `count` elements, or zero-filled
    /// placeholder values when the entry animation has not yet started.
    private func resolvedAnimatedData(count: Int) -> [Double] {
        if animatedData.isEmpty {
            return Array(repeating: 0.0, count: count)
        }
        if animatedData.count >= count {
            return Array(animatedData.prefix(count))
        }
        return animatedData + Array(repeating: 0.0, count: count - animatedData.count)
    }

    // MARK: - Accessibility

    private var accessibilityDescription: String {
        zip(axes, data)
            .map { "\($0): \(Int($1 * 100))%" }
            .joined(separator: ", ")
    }

    // MARK: - Geometry Helpers

    private func angleFor(index: Int, total: Int) -> Double {
        let step = (2 * .pi) / Double(total)
        return step * Double(index) - .pi / 2
    }

    private func point(
        center: CGPoint, radius: CGFloat,
        angle: Double, value: Double
    ) -> CGPoint {
        CGPoint(
            x: center.x + radius * value * cos(angle),
            y: center.y + radius * value * sin(angle)
        )
    }

    private func radarPath(
        values: [Double], center: CGPoint, radius: CGFloat
    ) -> Path {
        Path { path in
            guard !values.isEmpty else { return }
            let count = values.count
            for (index, value) in values.enumerated() {
                let angle = angleFor(index: index, total: count)
                let pos = point(center: center, radius: radius, angle: angle, value: value)
                if index == 0 {
                    path.move(to: pos)
                } else {
                    path.addLine(to: pos)
                }
            }
            path.closeSubpath()
        }
    }
}

extension View {

    /// Applies a neon fill overlay to a radar chart.
    ///
    /// - Parameter gradient: The gradient to apply.
    /// - Returns: A view with the radar fill styling.
    public func oshiRadarFill(_ gradient: LinearGradient) -> some View {
        self.overlay(gradient.opacity(0.1).allowsHitTesting(false))
    }
}

// MARK: - Previews

#Preview("Radar Chart — Character Stats") {
    OshiRadarChart(
        data: [0.8, 0.6, 0.9, 0.5, 0.7],
        axes: ["ATK", "DEF", "SPD", "INT", "LCK"]
    )
    .frame(width: 280, height: 280)
    .padding()
    .background(OshiColor.surfaceDeep)
}

#Preview("Radar Chart — Performance Metrics") {
    OshiRadarChart(
        data: [0.95, 0.4, 0.7, 0.85, 0.6, 0.3],
        axes: ["CPU", "RAM", "GPU", "NET", "DISK", "BAT"],
        accentColor: OshiColor.neonLime
    )
    .frame(width: 280, height: 280)
    .padding()
    .background(OshiColor.surfaceDeep)
}
