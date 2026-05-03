# ``OshiUICanvas``

User-controlled customizable workspaces with grid alignment and resizable widgets.

@Metadata {
    @DisplayName("OshiUI Canvas")
    @SupportedLanguage(swift)
}

## Overview

`OshiUICanvas` puts layout control in the user's hands. Components are arranged in flexible grid layouts with configurable columns and spacing, while widgets resize fluidly via drag handles within min/max constraints.

```swift
import OshiUICanvas

// Grid layout with configurable columns
OshiSnapGrid(columns: 4, spacing: 12) {
    ForEach(widgets) { widget in
        OshiResizableWidget(minSize: .small, maxSize: .large) {
            widget.content
        }
    }
}

// Snap-point calculation for custom layouts
let proxy = OshiSnapGridProxy(columns: 4, spacing: 10, gridWidth: 400)
let snapped = proxy.snap(dragLocation)
```

## Topics

### Layout

- ``OshiSnapGrid``
- ``OshiSnapGridProxy``

### Widgets

- ``OshiResizableWidget``
- ``OshiWidgetSize``
