//
//  OshiUISynapse.swift
//  OshiUI — Synapse Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

/// # OshiUISynapse
///
/// Intelligent system interfaces for on-device AI and language model interactions.
///
/// `OshiUISynapse` provides purpose-built UI components for communicating with
/// on-device language models (MLX, Core ML). Every component is optimized for
/// lag-free streaming text rendering and ambient "thinking" feedback.
///
/// ## Components
///
/// - **Streaming Text Renderer**: A high-performance text view that renders
///   token-by-token output from language models without frame drops. Supports
///   markdown rendering, code highlighting, and cursor animations.
/// - **Particle Thinking Animation**: A particle-system-based "thinking"
///   indicator that replaces boring spinners with organic, neural-network-inspired
///   visualizations that convey active computation.
/// - **Chat Bubble Layout**: A conversation view with role-based bubble styling,
///   streaming response integration, and auto-scrolling.
///
/// ## Usage
///
/// ```swift
/// import OshiUISynapse
///
/// // Streaming text from an on-device LLM
/// OshiStreamingText(stream: model.outputStream)
///     .oshiStreamCursor(.pulse)
///     .oshiStreamMarkdown(true)
///
/// // Thinking animation while model processes
/// if model.isProcessing {
///     OshiThinkingParticles(style: .neural)
///         .frame(width: 60, height: 60)
/// }
///
/// // Complete chat interface
/// OshiChatView(messages: $conversation) { prompt in
///     await model.generate(prompt: prompt)
/// }
/// ```
///
/// ## Performance
///
/// `OshiStreamingText` uses a custom `AttributedString` diffing engine
/// that appends tokens incrementally without re-rendering the entire text.
/// Target: **60fps** streaming at 100+ tokens/second.
///
/// ## Topics
///
/// ### Streaming
/// - ``OshiStreamingText``
/// - ``OshiStreamCursorStyle``
///
/// ### Feedback
/// - ``OshiThinkingParticles``
/// - ``OshiThinkingStyle``
///
/// ### Chat
/// - ``OshiChatView``
/// - ``OshiChatMessage``

import SwiftUI
import OshiUICore
import OshiUIKinetic

// MARK: - Module Namespace

/// The `OshiUISynapse` namespace.
public enum OshiUISynapse {

    /// The semantic version of the OshiUISynapse module.
    public static let version = "1.0.0-alpha"
}
