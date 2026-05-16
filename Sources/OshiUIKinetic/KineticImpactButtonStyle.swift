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
/// Automatically respects the **Reduce Motion** accessibility setting by
/// falling back to a simple eased animation without scale overshoot.
///
/// ## Usage
///
/// ```swift
/// Button("Save Changes") { save() }
///     .buttonStyle(KineticImpactButtonStyle())
///
/// Button("Submit") { submit() }
///     .buttonStyle(.oshiKineticImpact(intensity: .heavy, accentColor: .oshiLime))
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
        KineticImpactButtonBody(
            configuration: configuration,
            intensity: intensity,
            accentColor: accentColor,
            spring: spring
        )
    }
}

// MARK: - Inner Body View

/// Private view that reads the Reduce Motion environment for kinetic button rendering.
private struct KineticImpactButtonBody: View {

    let configuration: ButtonStyleConfiguration
    let intensity: OshiHapticEngine.ImpactIntensity
    let accentColor: Color
    let spring: OshiSpringPreset

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    var body: some View {
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
            .scaleEffect(reduceMotion ? 1.0 : (configuration.isPressed ? 0.94 : 1.0))
            .animation(
                reduceMotion
                    ? .easeInOut(duration: 0.15)
                    : spring.animation,
                value: configuration.isPressed
            )
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
    /// This is the primary API following the `.oshi` prefix convention.
    ///
    /// - Parameters:
    ///   - intensity: Haptic intensity. Defaults to `.medium`.
    ///   - accentColor: Accent color. Defaults to ``OshiColor/neonCyan``.
    /// - Returns: A `KineticImpactButtonStyle` instance.
    public static func oshiKineticImpact(
        intensity: OshiHapticEngine.ImpactIntensity = .medium,
        accentColor: Color = OshiColor.neonCyan
    ) -> KineticImpactButtonStyle {
        KineticImpactButtonStyle(intensity: intensity, accentColor: accentColor)
    }

    /// A kinetic impact button style with spring physics and haptic feedback.
    ///
    /// - Parameters:
    ///   - intensity: Haptic intensity. Defaults to `.medium`.
    ///   - accentColor: Accent color. Defaults to ``OshiColor/neonCyan``.
    /// - Returns: A `KineticImpactButtonStyle` instance.
    @available(*, deprecated, renamed: "oshiKineticImpact(intensity:accentColor:)",
               message: "Use .oshiKineticImpact() for consistent naming with the .oshi prefix convention.")
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
            .buttonStyle(.oshiKineticImpact(intensity: .light))

        Button("Medium Impact") { }
            .buttonStyle(.oshiKineticImpact())

        Button("Heavy Impact") { }
            .buttonStyle(.oshiKineticImpact(intensity: .heavy, accentColor: OshiColor.neonCoral))

        Button("Lime Accent") { }
            .buttonStyle(.oshiKineticImpact(accentColor: OshiColor.neonLime))
    }
    .padding(40)
    .background(OshiColor.surfaceDeep)
}
