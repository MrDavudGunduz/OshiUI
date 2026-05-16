//
//  OshiMorphView.swift
//  OshiUI — Kinetic Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A container that organically morphs between two states with spring physics.
///
/// `OshiMorphView` provides smooth shape-shifting transitions between a compact
/// and expanded state without hard cuts. The transition uses spring physics for
/// organic, weighted motion.
///
/// ## Usage
///
/// ```swift
/// OshiMorphView(isExpanded: $isExpanded) {
///     CompactView()
/// } expanded: {
///     DetailView()
/// }
///
/// OshiMorphView(isExpanded: $isOpen, spring: .bouncy) {
///     Label("Tap to expand", systemImage: "chevron.down")
/// } expanded: {
///     DetailPanel()
/// }
/// ```
public struct OshiMorphView<Compact: View, Expanded: View>: View {

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    /// Whether the view is in expanded state.
    @Binding public var isExpanded: Bool

    /// The spring preset for the morph animation.
    public let spring: OshiSpringPreset

    /// The compact state content.
    @ViewBuilder public let compact: () -> Compact

    /// The expanded state content.
    @ViewBuilder public let expanded: () -> Expanded

    /// Creates a morphing view.
    ///
    /// - Parameters:
    ///   - isExpanded: Binding to the expansion state.
    ///   - spring: Spring preset for the morph animation. Defaults to `.snappy`.
    ///   - compact: The compact state content builder.
    ///   - expanded: The expanded state content builder.
    public init(
        isExpanded: Binding<Bool>,
        spring: OshiSpringPreset = .snappy,
        @ViewBuilder compact: @escaping () -> Compact,
        @ViewBuilder expanded: @escaping () -> Expanded
    ) {
        self._isExpanded = isExpanded
        self.spring = spring
        self.compact = compact
        self.expanded = expanded
    }

    // MARK: - Resolved Animation

    /// Resolves the morph animation — falls back to a simple eased transition
    /// when the user has enabled **Reduce Motion** in accessibility settings.
    private var resolvedAnimation: Animation {
        reduceMotion
            ? .easeInOut(duration: 0.25)
            : spring.animation
    }

    /// Resolves the transition — disables scale effects when Reduce Motion is on.
    private var resolvedTransitionIn: AnyTransition {
        reduceMotion
            ? .opacity
            : .scale(scale: 0.95).combined(with: .opacity)
    }

    private var resolvedTransitionOut: AnyTransition {
        reduceMotion
            ? .opacity
            : .scale(scale: 1.02).combined(with: .opacity)
    }

    public var body: some View {
        VStack(spacing: 0) {
            if isExpanded {
                expanded()
                    .transition(
                        .asymmetric(
                            insertion: resolvedTransitionIn,
                            removal: resolvedTransitionIn
                        )
                    )
            } else {
                compact()
                    .transition(
                        .asymmetric(
                            insertion: resolvedTransitionOut,
                            removal: resolvedTransitionOut
                        )
                    )
            }
        }
        .animation(resolvedAnimation, value: isExpanded)
        .contentShape(Rectangle())
        .onTapGesture {
            isExpanded.toggle()
            // Haptic selection is @MainActor-isolated via SwiftUI's gesture context
            OshiHapticEngine.selection()
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand")
        .accessibilityValue(isExpanded ? "Expanded" : "Collapsed")
    }
}

// MARK: - Previews

#Preview("Morph View") {
    @Previewable @State var isExpanded = false

    OshiMorphView(isExpanded: $isExpanded) {
        HStack {
            Image(systemName: "chevron.down.circle.fill")
                .foregroundStyle(OshiColor.neonCyan)
            Text("Tap to expand")
                .font(OshiTypography.bodyBold)
                .foregroundStyle(OshiColor.textPrimary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(OshiColor.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium))
    } expanded: {
        VStack(alignment: .leading, spacing: 12) {
            Text("Expanded Content")
                .font(OshiTypography.title3)
                .foregroundStyle(OshiColor.textPrimary)
            Text("This panel morphed open with spring physics.")
                .font(OshiTypography.body)
                .foregroundStyle(OshiColor.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(OshiColor.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium))
    }
    .padding()
    .background(OshiColor.surfaceDeep)
}

