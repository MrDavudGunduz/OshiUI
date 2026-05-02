# ``OshiUICanvas``

User-controlled customizable workspaces with magnetic snap alignment.

@Metadata {
    @DisplayName("OshiUI Canvas")
    @SupportedLanguage(swift)
}

## Overview

`OshiUICanvas` puts layout control in the user's hands. Components snap to invisible grids like magnets, widgets resize fluidly, and workspace configurations persist across sessions.

```swift
import OshiUICanvas

OshiSnapGrid(columns: 4, spacing: 12) { proxy in
    ForEach(widgets) { widget in
        OshiResizableWidget(minSize: .small) {
            widget.content
        }
        .oshiSnap(to: proxy)
    }
}
```

## Topics

### Layout

- ``OshiSnapGrid``
- ``OshiSnapGridProxy``

### Widgets

- ``OshiResizableWidget``
- ``OshiWidgetSize``
