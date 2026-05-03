//
//  OshiToast.swift
//  OshiUI — Noir Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore
import OshiUIKinetic

/// A futuristic toast notification capsule with neon glow trails.
///
/// `OshiToast` replaces bland system alerts with cinematic edge-of-screen
/// capsules animated with slide-in effects and configurable glow colors.
///
/// ## Usage
///
/// ```swift
/// @State private var showToast = false
///
/// content
///     .oshiToast(isPresented: $showToast) {
///         OshiToast("Mission Complete", icon: "checkmark.circle.fill", glow: .oshiLime)
///     }
/// ```
public struct OshiToast: View {

    /// The toast message text.
    public let message: String

    /// Optional SF Symbol icon name.
    public let icon: String?

    /// The neon glow color.
    public let glow: Color

    /// Creates a toast notification.
    ///
    /// - Parameters:
    ///   - message: The notification message.
    ///   - icon: Optional SF Symbol name. Defaults to `nil`.
    ///   - glow: The glow accent color. Defaults to ``OshiColor/neonCyan``.
    public init(
        _ message: String,
        icon: String? = nil,
        glow: Color = OshiColor.neonCyan
    ) {
        self.message = message
        self.icon = icon
        self.glow = glow
    }

    public var body: some View {
        HStack(spacing: OshiSpacing.sm) {
            if let icon {
                Image(systemName: icon)
                    .font(OshiTypography.bodyBold)
                    .foregroundStyle(glow)
            }

            Text(message)
                .font(OshiTypography.callout)
                .foregroundStyle(OshiColor.textPrimary)
        }
        .padding(.horizontal, OshiSpacing.lg)
        .padding(.vertical, OshiSpacing.md)
        .background(
            Capsule()
                .fill(OshiColor.surfaceElevated)
                .overlay(
                    Capsule()
                        .stroke(glow.opacity(0.3), lineWidth: 0.5)
                )
        )
        .shadow(color: glow.opacity(0.25), radius: 16, y: 4)
        .shadow(color: .black.opacity(0.3), radius: 8, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
        .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Toast Configuration

/// Configuration options for toast presentation behavior.
public struct OshiToastConfiguration: Sendable {

    /// The edge from which the toast slides in.
    public let edge: Edge

    /// Duration the toast stays visible.
    public let duration: Duration

    /// Creates a toast configuration.
    ///
    /// - Parameters:
    ///   - edge: Presentation edge. Defaults to `.top`.
    ///   - duration: Display duration. Defaults to 3 seconds.
    public init(edge: Edge = .top, duration: Duration = .seconds(3)) {
        self.edge = edge
        self.duration = duration
    }

    /// Default top-edge configuration with 3-second display.
    public static let `default` = OshiToastConfiguration()
}

// MARK: - Toast Modifier

/// A view modifier that presents a toast notification overlay.
struct OshiToastModifier<ToastContent: View>: ViewModifier {

    @Binding var isPresented: Bool
    let configuration: OshiToastConfiguration
    @ViewBuilder let toastContent: () -> ToastContent

    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment) {
                if isPresented {
                    toastContent()
                        .transition(
                            .move(edge: configuration.edge)
                            .combined(with: .opacity)
                        )
                        .padding(OshiSpacing.xl)
                        .task(id: isPresented) {
                            guard isPresented else { return }
                            try? await Task.sleep(for: configuration.duration)
                            withAnimation(OshiSpringPreset.snappy.animation) {
                                isPresented = false
                            }
                        }
                }
            }
            .animation(OshiSpringPreset.bouncy.animation, value: isPresented)
            .accessibilityAction(named: "Dismiss notification") {
                withAnimation(OshiSpringPreset.snappy.animation) {
                    isPresented = false
                }
            }
    }

    private var alignment: Alignment {
        switch configuration.edge {
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        }
    }
}

extension View {

    /// Presents a toast notification over the view.
    ///
    /// The toast auto-dismisses after the configured duration.
    /// Rapid show/hide cycles are handled safely with automatic task cancellation.
    ///
    /// - Parameters:
    ///   - isPresented: Binding controlling toast visibility.
    ///   - configuration: Toast behavior configuration. Defaults to `.default`.
    ///   - content: The toast content builder.
    /// - Returns: A view with toast overlay capability.
    public func oshiToast<Content: View>(
        isPresented: Binding<Bool>,
        configuration: OshiToastConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            OshiToastModifier(
                isPresented: isPresented,
                configuration: configuration,
                toastContent: content
            )
        )
    }
}

// MARK: - Previews

#Preview("Toast — Variants") {
    VStack(spacing: 20) {
        OshiToast("Mission Complete", icon: "checkmark.circle.fill", glow: OshiColor.neonLime)
        OshiToast("Warning: Low Power", icon: "exclamationmark.triangle.fill", glow: OshiColor.neonAmber)
        OshiToast("Connection Lost", icon: "wifi.slash", glow: OshiColor.neonCoral)
        OshiToast("Syncing…", icon: "arrow.triangle.2.circlepath", glow: OshiColor.neonCyan)
    }
    .padding(40)
    .frame(maxWidth: .infinity)
    .background(OshiColor.surfaceDeep)
}
