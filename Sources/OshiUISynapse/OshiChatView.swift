//
//  OshiChatView.swift
//  OshiUI — Synapse Module
//
//  Copyright © 2026 Davud Gunduz. All rights reserved.
//

import SwiftUI
import OshiUICore
import OshiUIKinetic

/// A role-based chat conversation interface with streaming support.
///
/// ## Usage
///
/// ```swift
/// OshiChatView(messages: conversation) { prompt in
///     await model.generate(prompt: prompt)
/// }
/// ```
public struct OshiChatView: View {

    /// The messages in the conversation.
    public let messages: [OshiChatMessage]

    /// Callback when the user sends a message.
    public let onSend: @MainActor @Sendable (String) async -> Void

    @State private var inputText = ""
    @State private var isSending = false
    @State private var sendTask: Task<Void, Never>?

    /// Creates a chat view.
    ///
    /// - Parameters:
    ///   - messages: The conversation messages.
    ///   - onSend: Async callback invoked when the user sends a message.
    public init(
        messages: [OshiChatMessage],
        onSend: @escaping @MainActor @Sendable (String) async -> Void
    ) {
        self.messages = messages
        self.onSend = onSend
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Message list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: OshiSpacing.md) {
                        ForEach(messages) { message in
                            messageBubble(message)
                                .id(message.id)
                        }
                    }
                    .padding(OshiSpacing.lg)
                }
                .defaultScrollAnchor(.bottom)
                .onChange(of: messages.last?.id) { _, newID in
                    guard let newID else { return }
                    withAnimation(OshiSpringPreset.snappy.animation) {
                        proxy.scrollTo(newID, anchor: .bottom)
                    }
                }
            }

            // Input bar
            inputBar
        }
        .onDisappear {
            sendTask?.cancel()
            sendTask = nil
        }
    }

    // MARK: - Input Bar

    @ViewBuilder
    private var inputBar: some View {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)

        HStack(spacing: OshiSpacing.sm) {
            TextField("Message…", text: $inputText, axis: .vertical)
                .textFieldStyle(.plain)
                .font(OshiTypography.body)
                .foregroundStyle(OshiColor.textPrimary)
                .lineLimit(1...5)
                .padding(.horizontal, OshiSpacing.md)
                .padding(.vertical, OshiSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                        .fill(OshiColor.surfaceElevated)
                )
                .accessibilityLabel("Message input")

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(
                        trimmed.isEmpty
                        ? OshiColor.textTertiary
                        : OshiColor.neonCyan
                    )
            }
            .disabled(trimmed.isEmpty || isSending)
            .accessibilityLabel("Send message")
            .accessibilityHint(trimmed.isEmpty ? "Type a message first" : "Sends your message")
        }
        .padding(OshiSpacing.md)
        .background(OshiColor.surfaceDeep)
    }

    // MARK: - Message Bubble

    @ViewBuilder
    private func messageBubble(_ message: OshiChatMessage) -> some View {
        HStack {
            if message.role == .user { Spacer(minLength: 60) }

            VStack(
                alignment: message.role == .user ? .trailing : .leading,
                spacing: OshiSpacing.xs
            ) {
                Text(message.content)
                    .font(OshiTypography.body)
                    .foregroundStyle(OshiColor.textPrimary)
                    .padding(.horizontal, OshiSpacing.md)
                    .padding(.vertical, OshiSpacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                            .fill(
                                message.role == .user
                                ? OshiColor.neonCyan.opacity(0.15)
                                : OshiColor.surfaceElevated
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: OshiSpacing.radiusMedium)
                            .stroke(
                                message.role == .user
                                ? OshiColor.neonCyan.opacity(0.2)
                                : .clear,
                                lineWidth: 0.5
                            )
                    )
            }

            if message.role == .assistant { Spacer(minLength: 60) }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(message.role.accessibilityName): \(message.content)")
    }

    // MARK: - Actions

    private func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        inputText = ""
        isSending = true
        OshiHapticEngine.impact(.light)

        sendTask?.cancel()
        sendTask = Task {
            await onSend(trimmed)
            guard !Task.isCancelled else { return }
            isSending = false
        }
    }
}

// MARK: - Chat Message

/// A single message in an ``OshiChatView`` conversation.
public struct OshiChatMessage: Identifiable, Sendable {

    /// The unique message identifier.
    public let id: UUID

    /// The role of the message sender.
    public let role: Role

    /// The text content of the message.
    public let content: String

    /// The message sender role.
    public enum Role: String, Sendable {
        /// The user (human) role.
        case user
        /// The assistant (AI) role.
        case assistant
        /// A system instruction.
        case system

        /// Human-readable name for VoiceOver.
        var accessibilityName: String {
            switch self {
            case .user: "You"
            case .assistant: "Assistant"
            case .system: "System"
            }
        }
    }

    /// Creates a chat message.
    ///
    /// - Parameters:
    ///   - id: Unique identifier. Defaults to a new UUID.
    ///   - role: The sender role.
    ///   - content: The message text.
    public init(id: UUID = UUID(), role: Role, content: String) {
        self.id = id
        self.role = role
        self.content = content
    }
}

// MARK: - Previews

#Preview("Chat View") {
    OshiChatView(
        messages: [
            OshiChatMessage(role: .user, content: "What is OshiUI?"),
            OshiChatMessage(
                role: .assistant,
                content: "OshiUI is a futuristic SwiftUI component library with neon aesthetics, spring physics, and spatial depth effects."
            ),
            OshiChatMessage(role: .user, content: "Show me a code example"),
            OshiChatMessage(
                role: .assistant,
                content: "import OshiUI\n\nButton(\"Launch\") { }\n    .buttonStyle(.oshiVolumetric())"
            ),
        ]
    ) { _ in }
    .frame(height: 500)
    .background(OshiColor.surfaceDeep)
}
