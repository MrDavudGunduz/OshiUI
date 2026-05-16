//
//  OshiResizableWidget.swift
//  OshiUI — Canvas Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A modular container that users can drag edges to resize.
///
/// `OshiResizableWidget` provides a handle at the bottom edge that users
/// can drag vertically to adjust the content height within min/max bounds.
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
            content()
                .frame(maxWidth: .infinity)
                .frame(height: currentHeight)
                .clipped()

            // Resize handle
            resizeHandle
        }
        .background(
            RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                .fill(OshiColor.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                .stroke(OshiColor.textTertiary.opacity(0.2), lineWidth: 0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium))
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
        RoundedRectangle(cornerRadius: 2)
            .fill(OshiColor.textTertiary)
            .frame(width: 36, height: 4)
            .padding(.vertical, OshiSpacing.xs)
            .contentShape(Rectangle().size(width: 60, height: 24))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isDragging {
                            dragStartHeight = currentHeight
                            isDragging = true
                        }
                        currentHeight = min(
                            max(dragStartHeight + value.translation.height, minSize.height),
                            maxSize.height
                        )
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
public enum OshiWidgetSize: Sendable {
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
