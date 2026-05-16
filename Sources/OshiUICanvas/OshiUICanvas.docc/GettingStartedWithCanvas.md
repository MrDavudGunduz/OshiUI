# Getting Started with OshiUICanvas

Build flexible workspace layouts with snap grids and resizable widgets.

@Metadata {
    @PageKind(article)
}

## Overview

`OshiUICanvas` hands layout control to the user. Components snap to
invisible grids, widgets resize fluidly, and the workspace adapts to
content needs.

## Step 1: Import the Module

```swift
import OshiUICanvas
```

## Step 2: Snap Grid

``OshiSnapGrid`` creates a grid layout with configurable columns:

```swift
OshiSnapGrid(columns: 3, spacing: OshiSpacing.md) {
    ForEach(widgets) { widget in
        WidgetCard(widget: widget)
    }
}
```

Use ``OshiSnapGridProxy`` to access snap-point calculations for
custom alignment behavior.

## Step 3: Resizable Widgets

``OshiResizableWidget`` provides a drag handle for user-driven height
adjustment:

```swift
OshiResizableWidget(minSize: .small, maxSize: .large) {
    VStack {
        Image(systemName: "chart.bar.fill")
            .font(.largeTitle)
            .foregroundStyle(OshiColor.neonCyan)
        Text("Drag to resize")
            .font(OshiTypography.caption)
            .foregroundStyle(OshiColor.textSecondary)
    }
}
```

### Widget Size Presets

``OshiWidgetSize`` provides standard height presets:

| Size | Height |
|------|--------|
| `.small` | 120pt |
| `.medium` | 200pt |
| `.large` | 320pt |
| `.custom(CGFloat)` | Any custom value |

## Accessibility

- **VoiceOver**: Resizable widgets support `accessibilityAdjustableAction`
  — users can increment/decrement height in 40pt steps via VoiceOver swipes.
- Widget height is announced as an accessibility value.

## Next Steps

- Explore `OshiUISpatial` for glassmorphism backgrounds behind widgets.
- Explore `OshiUIHUD` for dashboard components like progress bars and charts.
