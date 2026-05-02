//
//  OshiUICanvas.swift
//  OshiUI — Canvas Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUICanvas
///
/// User-controlled, customizable workspace layouts with magnetic snapping.
///
/// `OshiUICanvas` hands layout control to the user. Components snap to invisible
/// grids like magnets, widgets resize fluidly based on their content, and the
/// entire workspace persists across sessions.
///
/// ## Components
///
/// - **Magnetic Snap Grid**: An invisible alignment system that components
///   gravitate toward during drag operations. Configurable grid density,
///   snap strength, and alignment guides.
/// - **Resizable Widget Areas**: Modular containers that reshape themselves
///   based on their content. Users can drag edges to resize, and content
///   adapts with fluid layout transitions.
///
/// ## Usage
///
/// ```swift
/// import OshiUICanvas
///
/// // Magnetic snap grid workspace
/// OshiSnapGrid(columns: 4, spacing: 12) { proxy in
///     ForEach(widgets) { widget in
///         OshiResizableWidget(minSize: .init(width: 1, height: 1)) {
///             widget.content
///         }
///         .oshiSnap(to: proxy)
///     }
/// }
///
/// // Standalone resizable widget
/// OshiResizableWidget(minSize: .small, maxSize: .large) {
///     ChartView(data: metrics)
/// }
/// ```
///
/// ## Topics
///
/// ### Layout
/// - ``OshiSnapGrid``
/// - ``OshiSnapGridProxy``
///
/// ### Widgets
/// - ``OshiResizableWidget``
/// - ``OshiWidgetSize``

import SwiftUI
import OshiUICore
import OshiUISpatial

// MARK: - Module Namespace

/// The `OshiUICanvas` namespace.
public enum OshiUICanvas {

    /// The semantic version of the OshiUICanvas module.
    public static let version = "1.0.0-alpha"
}
