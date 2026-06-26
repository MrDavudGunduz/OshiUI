//
//  OshiResizableWidget.swift
//  OshiUI — Canvas Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A modular container with a bottom drag handle for vertical resizing.
///
/// `OshiResizableWidget` provides a handle at the bottom edge that users
/// can drag vertically to adjust the content height within min/max bounds.
/// Horizontal resize is not currently supported — width always fills
/// the available space.
///
/// ## Usage
///
/// ```swift
/// OshiResizableWidget(minSize: .small, maxSize: .large) {
///     ChartView(data: metrics)
/// }
/// ```
public struct OshiResizableWidget<Content: View>: View {

    /// The minimum allowed size.
    public let minSize: OshiWidgetSize

    /// The maximum allowed size.
    public let maxSize: OshiWidgetSize

    /// The widget content.
    @ViewBuilder public let content: () -> Content

    @State private var currentHeight: CGFloat = 0
    @State private var dragStartHeight: CGFloat = 0
    @State private var isDragging = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Creates a resizable widget.
    ///
    /// - Parameters:
    ///   - minSize: Minimum size constraint. Defaults to `.small`.
    ///   - maxSize: Maximum size constraint. Defaults to `.large`.
    ///   - content: The widget content builder.
    public init(
        minSize: OshiWidgetSize = .small,
        maxSize: OshiWidgetSize = .large,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.minSize = minSize
        self.maxSize = maxSize
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Top accent bar
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            OshiColor.neonCyan.opacity(0.3),
                            OshiColor.neonCyan.opacity(0.05),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)

            content()
                .frame(maxWidth: .infinity)
                .frame(height: currentHeight)
                .clipped()

            // Resize handle
            resizeHandle
        }
        .background(
            RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                .fill(
                    LinearGradient(
                        colors: [
                            OshiColor.surfaceElevated,
                            OshiColor.surfaceElevated.opacity(0.95)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            // Specular highlight — subtle top glow
            RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.04), .clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .allowsHitTesting(false)
        )
        .overlay(
            RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                .stroke(
                    LinearGradient(
                        colors: [
                            OshiColor.textTertiary.opacity(isDragging ? 0.35 : 0.15),
                            OshiColor.textTertiary.opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 0.5
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium))
        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        .onAppear { currentHeight = minSize.height }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Resizable widget")
        .accessibilityValue("Height \(Int(currentHeight)) points")
        .accessibilityAdjustableAction { direction in
            let step: CGFloat = 40
            switch direction {
            case .increment:
                currentHeight = min(currentHeight + step, maxSize.height)
            case .decrement:
                currentHeight = max(currentHeight - step, minSize.height)
            @unknown default:
                break
            }
        }
    }

    // MARK: - Resize Handle

    @ViewBuilder
    private var resizeHandle: some View {
        VStack(spacing: 0) {
            // Separator line
            Rectangle()
                .fill(OshiColor.textTertiary.opacity(isDragging ? 0.15 : 0.08))
                .frame(height: 0.5)

            // Multi-dot handle pattern
            HStack(spacing: 4) {
                ForEach(ResizeHandleDot.dots) { _ in
                    Circle()
                        .fill(OshiColor.textTertiary.opacity(isDragging ? 0.6 : 0.35))
                        .frame(width: 4, height: 4)
                }
            }
            .animation(.easeOut(duration: 0.2), value: isDragging)
        }
        // Hit area — 44pt minimum per Apple HIG
        .frame(maxWidth: .infinity, minHeight: 44)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !isDragging {
                        dragStartHeight = currentHeight
                        isDragging = true
                    }
                    let newHeight = dragStartHeight + value.translation.height
                    withAnimation(reduceMotion ? nil : .interactiveSpring) {
                        currentHeight = min(
                            max(newHeight, minSize.height),
                            maxSize.height
                        )
                    }
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
        .accessibilityHidden(true)
    }
}

// MARK: - Widget Size

/// Preset sizes for ``OshiResizableWidget``.
public enum OshiWidgetSize: Sendable, Equatable, Hashable {
    /// Compact widget — 120pt.
    case small
    /// Standard widget — 200pt.
    case medium
    /// Expanded widget — 320pt.
    case large
    /// Custom height.
    case custom(CGFloat)

    /// The height in points for this size preset.
    public var height: CGFloat {
        switch self {
        case .small: 120
        case .medium: 200
        case .large: 320
        case .custom(let h): h
        }
    }
}

// MARK: - Resize Handle Dot (Identifiable)

/// An identifiable dot index for the resize handle's ``ForEach``.
///
/// Follows the OshiUI "Identifiable-first" architectural rule —
/// no `ForEach(0..<N, id: \.self)` in view code.
private struct ResizeHandleDot: Identifiable {
    let id: Int

    /// The three dots used in the resize handle.
    static let dots = (0..<3).map { ResizeHandleDot(id: $0) }
}

// MARK: - Previews

#Preview("Resizable Widget — Small to Large") {
    OshiResizableWidget(minSize: .small, maxSize: .large) {
        VStack {
            Image(systemName: "chart.bar.fill")
                .font(.largeTitle)
                .foregroundStyle(OshiColor.neonCyan)
            Text("Drag handle to resize")
                .font(OshiTypography.caption)
                .foregroundStyle(OshiColor.textSecondary)
        }
    }
    .padding()
    .background(OshiColor.surfaceDeep)
}
