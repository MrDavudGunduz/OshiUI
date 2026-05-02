# ``OshiUISynapse``

Intelligent interfaces for on-device AI and language model interactions.

@Metadata {
    @DisplayName("OshiUI Synapse")
    @SupportedLanguage(swift)
}

## Overview

`OshiUISynapse` provides purpose-built components for on-device LLM communication. The streaming text renderer handles 100+ tokens/second at 60fps, and particle-based "thinking" animations replace boring spinners with neural-inspired visualizations.

```swift
import OshiUISynapse

OshiStreamingText(stream: model.outputStream)
    .oshiStreamCursor(.pulse)
    .oshiStreamMarkdown(true)

if model.isProcessing {
    OshiThinkingParticles(style: .neural)
}
```

## Topics

### Streaming

- ``OshiStreamingText``
- ``OshiStreamCursorStyle``

### Feedback

- ``OshiThinkingParticles``
- ``OshiThinkingStyle``

### Chat

- ``OshiChatView``
- ``OshiChatMessage``
