# Getting Started with OshiUISynapse

Build AI/LLM interfaces with streaming text, thinking animations, and chat UI.

@Metadata {
    @PageKind(article)
}

## Overview

`OshiUISynapse` provides purpose-built components for on-device AI and
language model interactions. Every component is optimized for lag-free
streaming and accessible feedback.

## Step 1: Import the Module

```swift
import OshiUISynapse
```

## Step 2: Streaming Text

``OshiStreamingText`` renders token-by-token text output at 60fps:

```swift
OshiStreamingText(text: viewModel.streamedText)
    .oshiStreamCursor(.pulse)
```

Choose a ``OshiStreamCursorStyle``:

| Style | Behavior |
|-------|----------|
| `.pulse` | Blinking cursor at the end of text |
| `.block` | Solid block cursor |
| `.none` | No cursor indicator |

## Step 3: Thinking Particles

Replace spinners with ``OshiThinkingParticles`` for organic computation
feedback:

```swift
if model.isProcessing {
    OshiThinkingParticles(style: .neural, color: OshiColor.neonCyan)
        .frame(width: 60, height: 60)
}
```

Available ``OshiThinkingStyle`` options:

| Style | Character |
|-------|-----------|
| `.neural` | Orbiting particles — neural network inspired |
| `.pulse` | Gentle pulsing cluster — calm and minimal |
| `.spiral` | Fast spiraling particles — high energy |

## Step 4: Chat Interface

``OshiChatView`` provides a complete conversation interface with
role-based bubble styling and async send handling:

```swift
OshiChatView(messages: conversation) { prompt in
    await model.generate(prompt: prompt)
}
```

Messages use the ``OshiChatMessage`` model with `.user`, `.assistant`,
and `.system` roles:

```swift
let messages = [
    OshiChatMessage(role: .user, content: "Hello!"),
    OshiChatMessage(role: .assistant, content: "Hi! How can I help?"),
]
```

## Accessibility

- **Reduce Motion**: Thinking particles show a static pulsing circle
  indicator instead of the full particle canvas animation.
- **VoiceOver**: Chat bubbles announce role and content. The send button
  provides conditional hints. Thinking particles use `.updatesFrequently`.

## Next Steps

- Explore `OshiUIKinetic` for haptic feedback on send actions.
- Explore `OshiUINoir` for cyberpunk-styled system notifications.
