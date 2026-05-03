//
//  OshiRadarChart.swift
//  OshiUI — HUD Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A multi-axis radar (spider) chart for visualizing comparative statistics.
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
        self.data = data.map { min(max($0, 0), 1) }
        self.axes = axes
        self.accentColor = accentColor
    }

    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            let radius = size * 0.35
            let count = max(data.count, 3)

            ZStack {
                // Grid rings
                ForEach(1...4, id: \.self) { ring in
                    radarPath(
                        values: Array(repeating: Double(ring) / 4.0, count: count),
                        center: center,
                        radius: radius
                    )
                    .stroke(OshiColor.textTertiary.opacity(0.3), lineWidth: 0.5)
                }

                // Axis lines
                ForEach(0..<count, id: \.self) { index in
                    let angle = angleFor(index: index, total: count)
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
                    values: animatedData.isEmpty ? data.map { _ in 0.0 } : animatedData,
                    center: center,
                    radius: radius
                )
                .fill(accentColor.opacity(0.15))

                radarPath(
                    values: animatedData.isEmpty ? data.map { _ in 0.0 } : animatedData,
                    center: center,
                    radius: radius
                )
                .stroke(accentColor, lineWidth: 1.5)

                // Data points
                ForEach(0..<count, id: \.self) { index in
                    let value = animatedData.isEmpty ? 0 : animatedData[index]
                    let angle = angleFor(index: index, total: count)
                    let pos = point(center: center, radius: radius, angle: angle, value: value)

                    Circle()
                        .fill(accentColor)
                        .frame(width: 6, height: 6)
                        .position(pos)
                        .shadow(color: accentColor.opacity(0.4), radius: 4)
                }

                // Axis labels
                ForEach(0..<min(axes.count, count), id: \.self) { index in
                    let angle = angleFor(index: index, total: count)
                    let labelPos = point(
                        center: center, radius: radius + 20,
                        angle: angle, value: 1.0
                    )

                    Text(axes[index])
                        .font(OshiTypography.codeSmall)
                        .foregroundStyle(OshiColor.textSecondary)
                        .position(labelPos)
                }
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                animatedData = data
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Radar chart with \(axes.count) axes")
        .accessibilityValue(accessibilityDescription)
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
