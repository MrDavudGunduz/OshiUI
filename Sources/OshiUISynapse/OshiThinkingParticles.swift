//
//  OshiThinkingParticles.swift
//  OshiUI — Synapse Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A particle-based "thinking" indicator with neural-network-inspired visuals.
///
/// Replaces boring spinners with organic, animated particle visualizations
/// that convey active computation.
///
/// ## Usage
///
/// ```swift
/// if model.isProcessing {
///     OshiThinkingParticles(style: .neural)
///         .frame(width: 60, height: 60)
/// }
/// ```
public struct OshiThinkingParticles: View {

    /// The visual style of the particle animation.
    public let style: OshiThinkingStyle

    /// The accent color for the particles.
    public let color: Color

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    @State private var staticPulse = false
    @State private var isActive = true

    /// Creates a thinking particle animation.
    ///
    /// - Parameters:
    ///   - style: The visual style. Defaults to `.neural`.
    ///   - color: The particle color. Defaults to ``OshiColor/neonCyan``.
    public init(
        style: OshiThinkingStyle = .neural,
        color: Color = OshiColor.neonCyan
    ) {
        self.style = style
        self.color = color
    }

    public var body: some View {
        if reduceMotion {
            reducedMotionView
        } else {
            particleCanvas
        }
    }

    // MARK: - Reduced Motion Fallback

    /// A static pulsing indicator shown when Reduce Motion is enabled.
    @ViewBuilder
    private var reducedMotionView: some View {
        Circle()
            .fill(color)
            .frame(width: 12, height: 12)
            .opacity(staticPulse ? 1.0 : 0.4)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    staticPulse = true
                }
            }
            .accessibilityLabel("Processing")
            .accessibilityAddTraits(.updatesFrequently)
    }

    // MARK: - Particle Canvas

    @ViewBuilder
    private var particleCanvas: some View {
        TimelineView(.animation(paused: !isActive)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let particleCount = style.particleCount

                for i in 0..<particleCount {
                    let progress = Double(i) / Double(particleCount)
                    let angle = progress * .pi * 2 + time * style.speed
                    let radius = style.radius(for: progress, time: time, size: size)
                    let particleSize = style.particleSize(for: progress, time: time)

                    let point = CGPoint(
                        x: center.x + radius * cos(angle),
                        y: center.y + radius * sin(angle)
                    )

                    let opacity = style.opacity(for: progress, time: time)
                    let rect = CGRect(
                        x: point.x - particleSize / 2,
                        y: point.y - particleSize / 2,
                        width: particleSize,
                        height: particleSize
                    )

                    context.opacity = opacity
                    context.fill(
                        Circle().path(in: rect),
                        with: .color(color)
                    )
                }
            }
        }
        .onAppear { isActive = true }
        .onDisappear { isActive = false }
        .accessibilityLabel("Processing")
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Thinking Style

/// The visual style for ``OshiThinkingParticles``.
public enum OshiThinkingStyle: String, Sendable, CaseIterable {

    /// Orbiting particles with varying radii — neural network inspired.
    case neural

    /// Gentle pulsing cluster — minimal and calm.
    case pulse

    /// Fast spiraling particles — high energy computation.
    case spiral

    var particleCount: Int {
        switch self {
        case .neural: 12
        case .pulse: 6
        case .spiral: 16
        }
    }

    var speed: Double {
        switch self {
        case .neural: 1.5
        case .pulse: 0.8
        case .spiral: 3.0
        }
    }

    func radius(for progress: Double, time: Double, size: CGSize) -> CGFloat {
        let base = min(size.width, size.height) * 0.3
        switch self {
        case .neural:
            return base * (0.6 + 0.4 * sin(time * 2 + progress * .pi * 4))
        case .pulse:
            return base * (0.3 + 0.2 * sin(time * 1.5))
        case .spiral:
            return base * (0.2 + progress * 0.8)
        }
    }

    func particleSize(for progress: Double, time: Double) -> CGFloat {
        switch self {
        case .neural:
            return 3 + 2 * sin(time * 3 + progress * .pi * 2)
        case .pulse:
            return 4 + 2 * sin(time * 2)
        case .spiral:
            return 2 + progress * 3
        }
    }

    func opacity(for progress: Double, time: Double) -> Double {
        switch self {
        case .neural:
            return 0.4 + 0.4 * sin(time * 2 + progress * .pi * 3)
        case .pulse:
            return 0.3 + 0.5 * sin(time * 1.5)
        case .spiral:
            return 0.2 + 0.6 * progress
        }
    }
}

// MARK: - Previews

#Preview("Thinking Particles — Styles") {
    HStack(spacing: 32) {
        VStack {
            OshiThinkingParticles(style: .neural)
                .frame(width: 60, height: 60)
            Text("Neural")
                .font(OshiTypography.caption)
                .foregroundStyle(OshiColor.textSecondary)
        }

        VStack {
            OshiThinkingParticles(style: .pulse, color: OshiColor.neonMagenta)
                .frame(width: 60, height: 60)
            Text("Pulse")
                .font(OshiTypography.caption)
                .foregroundStyle(OshiColor.textSecondary)
        }

        VStack {
            OshiThinkingParticles(style: .spiral, color: OshiColor.neonLime)
                .frame(width: 60, height: 60)
            Text("Spiral")
                .font(OshiTypography.caption)
                .foregroundStyle(OshiColor.textSecondary)
        }
    }
    .padding(40)
    .background(OshiColor.surfaceDeep)
}

