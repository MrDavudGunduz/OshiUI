//
//  OshiVolumetricButton.swift
//  OshiUI — Spatial Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A button style with Z-axis depth that physically depresses on press.
///
/// `OshiVolumetricButtonStyle` simulates a physical 3D button with a raised state,
/// press-down animation, specular highlight shift, and shadow compression.
/// Built as a proper `ButtonStyle` for full accessibility, keyboard focus,
/// and VoiceOver support.
///
/// ## Usage
///
/// ```swift
/// Button("Launch") { startMission() }
///     .buttonStyle(.oshiVolumetric())
///
/// Button("Delete") { deleteItem() }
///     .buttonStyle(.oshiVolumetric(color: OshiColor.neonCoral))
/// ```
public struct OshiVolumetricButtonStyle: ButtonStyle {

    /// The button's accent color.
    public let color: Color

    /// Creates a volumetric button style.
    ///
    /// - Parameter color: Accent color. Defaults to ``OshiColor/neonCyan``.
    public init(color: Color = OshiColor.neonCyan) {
        self.color = color
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(OshiTypography.bodyBold)
            .foregroundStyle(.white)
            .padding(.horizontal, OshiSpacing.xl)
            .padding(.vertical, OshiSpacing.md)
            .background(
                ZStack {
                    // Bottom layer (depth)
                    RoundedRectangle(cornerRadius: OshiSpacing.radiusSmall)
                        .fill(color.opacity(0.6))
                        .offset(y: configuration.isPressed ? 1 : 4)

                    // Top layer (face)
                    RoundedRectangle(cornerRadius: OshiSpacing.radiusSmall)
                        .fill(color)
                        .overlay(
                            // Specular highlight
                            RoundedRectangle(cornerRadius: OshiSpacing.radiusSmall)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(configuration.isPressed ? 0.05 : 0.2),
                                            .clear
                                        ],
                                        startPoint: .top,
                                        endPoint: .center
                                    )
                                )
                        )
                        .offset(y: configuration.isPressed ? 2 : 0)
                }
            )
            .shadow(
                color: color.opacity(configuration.isPressed ? 0.1 : 0.3),
                radius: configuration.isPressed ? 4 : 12,
                y: configuration.isPressed ? 2 : 6
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - ButtonStyle Extension

extension ButtonStyle where Self == OshiVolumetricButtonStyle {

    /// A volumetric 3D button style with Z-axis depth and press-down physics.
    ///
    /// - Parameter color: Accent color. Defaults to ``OshiColor/neonCyan``.
    /// - Returns: An `OshiVolumetricButtonStyle` instance.
    public static func oshiVolumetric(
        color: Color = OshiColor.neonCyan
    ) -> OshiVolumetricButtonStyle {
        OshiVolumetricButtonStyle(color: color)
    }
}

// MARK: - Convenience View

/// A volumetric 3D button with Z-axis depth that physically depresses on press.
///
/// This is a convenience wrapper around `Button` with ``OshiVolumetricButtonStyle``.
///
/// ## Usage
///
/// ```swift
/// OshiVolumetricButton("Launch") {
///     startMission()
/// }
///
/// OshiVolumetricButton("Delete", color: OshiColor.neonCoral) {
///     deleteItem()
/// }
/// ```
public struct OshiVolumetricButton: View {

    /// The button label text.
    public let title: String

    /// The button's accent color.
    public let color: Color

    /// The action to perform on tap.
    public let action: () -> Void

    /// Creates a volumetric button.
    ///
    /// - Parameters:
    ///   - title: The button label.
    ///   - color: Accent color. Defaults to ``OshiColor/neonCyan``.
    ///   - action: The tap action closure.
    public init(
        _ title: String,
        color: Color = OshiColor.neonCyan,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.color = color
        self.action = action
    }

    public var body: some View {
        Button(title, action: action)
            .buttonStyle(.oshiVolumetric(color: color))
            .accessibilityLabel(title)
    }
}

// MARK: - Previews

#Preview("Volumetric Button — Default") {
    VStack(spacing: 20) {
        OshiVolumetricButton("Launch") { }
        OshiVolumetricButton("Delete", color: OshiColor.neonCoral) { }
        OshiVolumetricButton("Accept", color: OshiColor.neonLime) { }
    }
    .padding(40)
    .background(OshiColor.surfaceDeep)
}

#Preview("Volumetric ButtonStyle") {
    VStack(spacing: 20) {
        Button("Save Changes") { }
            .buttonStyle(.oshiVolumetric())

        Button {
        } label: {
            Label("Download", systemImage: "arrow.down.circle.fill")
        }
        .buttonStyle(.oshiVolumetric(color: OshiColor.neonViolet))
    }
    .padding(40)
    .background(OshiColor.surfaceDeep)
}
