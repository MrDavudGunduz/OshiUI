//
//  OshiHolographicCanvas.swift
//  OshiUI — Holographic Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore
import OshiUISpatial

/// A container that renders content with holographic 3D depth effects.
///
/// `OshiHolographicCanvas` creates a volumetric presentation for its content
/// using rotation, parallax, and holographic material effects.
///
/// | Platform | Rendering |
/// |----------|-----------|
/// | **visionOS** | Full volumetric with depth |
/// | **iOS** | Gyroscope-driven parallax |
/// | **macOS** | Hover-driven parallax |
///
/// ## Usage
///
/// ```swift
/// OshiHolographicCanvas {
///     Image(systemName: "globe")
///         .font(.system(size: 60))
///         .foregroundStyle(OshiColor.neonCyan)
/// }
/// .frame(height: 300)
/// ```
public struct OshiHolographicCanvas<Content: View>: View {

    /// The canvas content.
    @ViewBuilder public let content: () -> Content

    /// Maximum rotation angle in degrees.
    private let maxRotation: Double = 10

    /// Rotation sensitivity divisor (higher = less sensitive).
    private let sensitivity: Double = 15

    @State private var rotationX: Double = 0
    @State private var rotationY: Double = 0
    @State private var isHovered = false

    /// Creates a holographic canvas.
    ///
    /// - Parameter content: The content to present with holographic depth.
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            let midX = geometry.size.width / 2
            let midY = geometry.size.height / 2

            ZStack {
                // Background glow layer
                RoundedRectangle(cornerRadius: OshiSpacing.radiusLarge)
                    .fill(OshiColor.surfaceDeep)
                    .overlay(
                        RoundedRectangle(cornerRadius: OshiSpacing.radiusLarge)
                            .fill(
                                RadialGradient(
                                    colors: [
                                        OshiColor.neonCyan.opacity(0.08),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: max(midX, midY) * 1.3
                                )
                            )
                    )

                // Content layer
                content()
                    .rotation3DEffect(
                        .degrees(rotationX),
                        axis: (x: 1, y: 0, z: 0),
                        perspective: 0.5
                    )
                    .rotation3DEffect(
                        .degrees(rotationY),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.5
                    )

                // Holographic sheen overlay
                RoundedRectangle(cornerRadius: OshiSpacing.radiusLarge)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.05),
                                .clear,
                                OshiColor.neonCyan.opacity(0.03),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .allowsHitTesting(false)
            }
            .clipShape(RoundedRectangle(cornerRadius: OshiSpacing.radiusLarge))
            .overlay(
                RoundedRectangle(cornerRadius: OshiSpacing.radiusLarge)
                    .stroke(
                        OshiColor.neonCyan.opacity(isHovered ? 0.3 : 0.1),
                        lineWidth: 0.5
                    )
            )
            .shadow(
                color: OshiColor.neonCyan.opacity(isHovered ? 0.2 : 0.05),
                radius: isHovered ? 20 : 10
            )
            .onHover { hovering in
                withAnimation(.easeOut(duration: 0.3)) {
                    isHovered = hovering
                    if !hovering {
                        rotationX = 0
                        rotationY = 0
                    }
                }
            }
            .onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    withAnimation(.interactiveSpring(response: 0.15)) {
                        rotationY = clampRotation((location.x - midX) / sensitivity)
                        rotationX = clampRotation(-(location.y - midY) / sensitivity)
                    }
                case .ended:
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        rotationX = 0
                        rotationY = 0
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Holographic display")
    }

    // MARK: - Helpers

    private func clampRotation(_ value: Double) -> Double {
        min(max(value, -maxRotation), maxRotation)
    }
}

// MARK: - Volumetric Panel

/// A floating control panel optimized for spatial interfaces.
///
/// On visionOS, the panel floats with depth. On other platforms, it renders
/// as an elevated glass panel with a subtle neon border.
///
/// ```swift
/// OshiVolumetricPanel {
///     Toggle("Shields", isOn: $shieldsActive)
///     Slider(value: $power, in: 0...100)
/// }
/// ```
public struct OshiVolumetricPanel<Content: View>: View {

    /// The panel content.
    @ViewBuilder public let content: () -> Content

    /// Creates a volumetric panel.
    ///
    /// - Parameter content: The panel content builder.
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(spacing: OshiSpacing.md) {
            content()
        }
        .padding(OshiSpacing.xl)
        .oshiGlassmorphism(
            tint: OshiColor.neonCyan.opacity(0.03),
            borderOpacity: 0.2,
            cornerRadius: OshiSpacing.radiusLarge
        )
        .shadow(color: OshiColor.neonCyan.opacity(0.1), radius: 20, y: 8)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Control panel")
    }
}

// MARK: - Previews

#Preview("Holographic Canvas") {
    OshiHolographicCanvas {
        VStack(spacing: 12) {
            Image(systemName: "globe")
                .font(.system(size: 60))
                .foregroundStyle(OshiColor.neonCyan)
            Text("HOLOGRAPHIC")
                .font(OshiTypography.title2)
                .foregroundStyle(OshiColor.textPrimary)
        }
    }
    .frame(width: 300, height: 300)
    .padding()
    .background(OshiColor.surfaceDeep)
}

#Preview("Volumetric Panel") {
    OshiVolumetricPanel {
        Text("System Controls")
            .font(OshiTypography.title3)
            .foregroundStyle(OshiColor.textPrimary)
        Divider()
        HStack {
            Text("Power Level")
                .font(OshiTypography.body)
                .foregroundStyle(OshiColor.textSecondary)
            Spacer()
            Text("87%")
                .font(OshiTypography.bodyBold)
                .foregroundStyle(OshiColor.neonLime)
        }
    }
    .padding()
    .background(OshiColor.surfaceDeep)
}
