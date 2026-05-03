//
//  KineticImpactButtonStyle.swift
//  OshiUI — Kinetic Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A button style that applies spring physics and haptic feedback on press.
///
/// The button physically "pushes back" with configurable spring damping,
/// scale reduction, and haptic intensity. It creates a tactile, responsive
/// interaction that feels weighted and deliberate.
///
/// ## Usage
///
/// ```swift
/// Button("Save Changes") { save() }
///     .buttonStyle(KineticImpactButtonStyle())
///
/// Button("Submit") { submit() }
///     .buttonStyle(.kineticImpact(intensity: .heavy, accentColor: .oshiLime))
/// ```
///
/// - Parameter intensity: The haptic feedback intensity. Default is `.medium`.
public struct KineticImpactButtonStyle: ButtonStyle {

    /// The haptic feedback intensity on press.
    public let intensity: OshiHapticEngine.ImpactIntensity

    /// The button's accent color.
    public let accentColor: Color

    /// The spring preset for the press animation.
    public let spring: OshiSpringPreset

    /// Creates a kinetic impact button style.
    ///
    /// - Parameters:
    ///   - intensity: Haptic intensity. Defaults to `.medium`.
    ///   - accentColor: Accent color. Defaults to ``OshiColor/neonCyan``.
    ///   - spring: Spring preset. Defaults to `.snappy`.
    public init(
        intensity: OshiHapticEngine.ImpactIntensity = .medium,
        accentColor: Color = OshiColor.neonCyan,
        spring: OshiSpringPreset = .snappy
    ) {
        self.intensity = intensity
        self.accentColor = accentColor
        self.spring = spring
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(OshiTypography.bodyBold)
            .foregroundStyle(.white)
            .padding(.horizontal, OshiSpacing.xl)
            .padding(.vertical, OshiSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: OshiSpacing.radiusSmall)
                    .fill(accentColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: OshiSpacing.radiusSmall)
                            .fill(.white.opacity(configuration.isPressed ? 0 : 0.1))
                    )
            )
            .shadow(
                color: accentColor.opacity(configuration.isPressed ? 0.15 : 0.35),
                radius: configuration.isPressed ? 4 : 12,
                y: configuration.isPressed ? 2 : 6
            )
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(spring.animation, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    OshiHapticEngine.impact(intensity)
                }
            }
    }
}

// MARK: - ButtonStyle Extension

extension ButtonStyle where Self == KineticImpactButtonStyle {

    /// A kinetic impact button style with spring physics and haptic feedback.
    ///
    /// - Parameters:
    ///   - intensity: Haptic intensity. Defaults to `.medium`.
    ///   - accentColor: Accent color. Defaults to ``OshiColor/neonCyan``.
    /// - Returns: A `KineticImpactButtonStyle` instance.
    public static func kineticImpact(
        intensity: OshiHapticEngine.ImpactIntensity = .medium,
        accentColor: Color = OshiColor.neonCyan
    ) -> KineticImpactButtonStyle {
        KineticImpactButtonStyle(intensity: intensity, accentColor: accentColor)
    }
}

// MARK: - Previews

#Preview("Kinetic Impact — Variants") {
    VStack(spacing: 16) {
        Button("Light Impact") { }
            .buttonStyle(.kineticImpact(intensity: .light))

        Button("Medium Impact") { }
            .buttonStyle(.kineticImpact())

        Button("Heavy Impact") { }
            .buttonStyle(.kineticImpact(intensity: .heavy, accentColor: OshiColor.neonCoral))

        Button("Lime Accent") { }
            .buttonStyle(.kineticImpact(accentColor: OshiColor.neonLime))
    }
    .padding(40)
    .background(OshiColor.surfaceDeep)
}
