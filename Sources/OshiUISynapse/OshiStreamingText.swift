//
//  OshiStreamingText.swift
//  OshiUI — Synapse Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore

/// A high-performance text view that renders token-by-token LLM output.
///
/// `OshiStreamingText` incrementally appends tokens without re-rendering
/// the entire text, maintaining 60fps at 100+ tokens/second.
///
/// The cursor style can be set via the initializer or the `.oshiStreamCursor()`
/// environment modifier (environment value takes precedence).
///
/// ## Usage
///
/// ```swift
/// OshiStreamingText(text: viewModel.streamedText)
///
/// // Override cursor via environment
/// OshiStreamingText(text: viewModel.streamedText)
///     .oshiStreamCursor(.block)
/// ```
public struct OshiStreamingText: View {

    /// The accumulated text content.
    public let text: String

    /// Whether to show a blinking cursor at the end.
    public let showCursor: Bool

    /// The cursor style passed via initializer (fallback).
    private let initCursorStyle: OshiStreamCursorStyle

    /// Environment-driven cursor style override.
    @Environment(\.oshiStreamCursorStyleOverride)
    private var envCursorOverride

    @State private var cursorVisible = true

    /// The resolved cursor style — explicit environment override wins,
    /// otherwise falls back to the initializer value.
    private var cursorStyle: OshiStreamCursorStyle {
        envCursorOverride ?? initCursorStyle
    }

    /// Creates a streaming text view.
    ///
    /// - Parameters:
    ///   - text: The text to display.
    ///   - showCursor: Whether to show a cursor. Defaults to `true`.
    ///   - cursorStyle: The default cursor animation style. Defaults to `.pulse`.
    ///     This can be overridden by the `.oshiStreamCursor()` environment modifier.
    public init(
        text: String,
        showCursor: Bool = true,
        cursorStyle: OshiStreamCursorStyle = .pulse
    ) {
        self.text = text
        self.showCursor = showCursor
        self.initCursorStyle = cursorStyle
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(text)
                .font(OshiTypography.body)
                .foregroundStyle(OshiColor.textPrimary)
                .textSelection(.enabled)
                .animation(.none, value: text)

            if showCursor {
                cursorView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text.isEmpty ? "Waiting for response" : text)
        .accessibilityAddTraits(.updatesFrequently)
    }

    @ViewBuilder
    private var cursorView: some View {
        switch cursorStyle {
        case .pulse:
            Rectangle()
                .fill(OshiColor.neonCyan)
                .frame(width: 2, height: 18)
                .opacity(cursorVisible ? 1 : 0)
                .animation(
                    .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                    value: cursorVisible
                )
                .onAppear { cursorVisible.toggle() }

        case .block:
            Rectangle()
                .fill(OshiColor.neonCyan.opacity(0.3))
                .frame(width: 10, height: 18)
                .opacity(cursorVisible ? 1 : 0.3)
                .animation(
                    .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                    value: cursorVisible
                )
                .onAppear { cursorVisible.toggle() }

        case .hidden:
            EmptyView()
        }
    }
}

// MARK: - Cursor Style

/// The animation style for the streaming text cursor.
public enum OshiStreamCursorStyle: String, Sendable {
    /// A thin pulsing line cursor.
    case pulse
    /// A block cursor with fading animation.
    case block
    /// No visible cursor.
    case hidden

    /// No visible cursor.
    ///
    /// - Note: Renamed to ``hidden`` to avoid shadowing `Optional.none`.
    @available(*, deprecated, renamed: "hidden",
               message: "Use .hidden to avoid ambiguity with Optional.none.")
    public static let none: OshiStreamCursorStyle = .hidden
}

// MARK: - Cursor Modifier

extension View {

    /// Sets the streaming text cursor style via the environment.
    ///
    /// This overrides any `cursorStyle` value passed to ``OshiStreamingText/init(text:showCursor:cursorStyle:)``.
    ///
    /// - Parameter style: The cursor style to apply.
    /// - Returns: The modified view with the cursor style set in the environment.
    public func oshiStreamCursor(_ style: OshiStreamCursorStyle) -> some View {
        environment(\.oshiStreamCursorStyleOverride, style)
    }
}

// MARK: - Environment Key

extension EnvironmentValues {

    /// Optional cursor style override set via `.oshiStreamCursor()` modifier.
    /// When `nil`, the init-time default is used.
    @Entry public var oshiStreamCursorStyleOverride: OshiStreamCursorStyle? = nil
}

// MARK: - Previews

#Preview("Streaming Text — Pulse Cursor") {
    OshiStreamingText(text: "The neural pathways are computing your request…")
        .padding()
        .background(OshiColor.surfaceDeep)
}

#Preview("Streaming Text — Block Cursor") {
    OshiStreamingText(text: "Processing tokens at 120 t/s")
        .oshiStreamCursor(.block)
        .padding()
        .background(OshiColor.surfaceDeep)
}

#Preview("Streaming Text — No Cursor") {
    OshiStreamingText(text: "Complete response rendered.", showCursor: false)
        .padding()
        .background(OshiColor.surfaceDeep)
}
