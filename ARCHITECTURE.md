# PowerID Architecture

## Project Structure

```
PowerID/
├── PowerIDApp.swift              # App entry point
│
├── Views/                        # All SwiftUI views
│   ├── Main/                     # Main app views
│   │   ├── ContentView.swift     # Root view with tab navigation
│   │   ├── OverviewView.swift    # Battery overview dashboard
│   │   ├── DetailsView.swift     # Detailed battery information
│   │   └── InfoView.swift        # Battery tips and information
│   │
│   ├── Settings/                 # Settings window views
│   │   ├── SettingsView.swift    # Settings root view
│   │   ├── GeneralSettingsView.swift
│   │   ├── NotificationsSettingsView.swift
│   │   └── AboutSettingsView.swift
│   │
│   └── Components/               # Reusable view components
│       ├── StatusCard.swift
│       ├── DetailSection.swift
│       ├── DetailRow.swift
│       ├── InfoSection.swift
│       ├── TipRow.swift
│       └── BatteryProgressBar.swift
│
├── ViewModels/                   # View models (MVVM pattern)
│   └── BatteryMonitor.swift      # Main battery monitoring logic
│
├── Models/                       # Data models
│   └── BatteryInfo.swift         # Battery data structures
│
├── Utilities/                    # Utility classes and helpers
│   ├── AppDelegate.swift         # App lifecycle management
│   ├── IOKitBatteryService.swift # IOKit battery data service
│   └── BatteryFormatter.swift    # Battery UI formatting utilities
│
└── Resources/                    # Assets and resources
    └── Assets.xcassets/
```

## Architecture Pattern

This app follows the **MVVM (Model-View-ViewModel)** architecture pattern:

### Models
- `BatteryInfo.swift`: Pure data structures representing battery state
- `BatteryElectricalInfo`: Electrical measurements (voltage, amperage, temperature)
- `BatterySnapshot`: Complete battery state snapshot

### Views
- **Main Views**: Primary app screens (Overview, Details, Info)
- **Settings Views**: Settings window screens
- **Components**: Reusable UI components following Single Responsibility Principle

### ViewModels
- `BatteryMonitor`: ObservableObject that manages battery state and updates
- Publishes battery data changes to views via `@Published` properties
- Handles all business logic for battery monitoring

### Utilities
- `IOKitBatteryService`: Encapsulates all IOKit registry interactions
- `BatteryFormatter`: Pure utility functions for formatting battery data
- `AppDelegate`: App lifecycle and window management

## Design Principles

### 1. Separation of Concerns
Each file has a single, well-defined responsibility:
- Views only handle UI presentation
- ViewModels handle business logic and state
- Services handle external data access (IOKit)
- Utilities provide pure helper functions

### 2. Component Reusability
Common UI patterns are extracted into reusable components:
- `StatusCard`: Displays icon, title, and value
- `DetailSection`: Groups related detail rows
- `DetailRow`: Label-value pair display
- `InfoSection`: Icon, title, and description

### 3. Dependency Injection
Dependencies are injected rather than created:
- Views receive `BatteryMonitor` as a parameter
- `BatteryMonitor` uses `IOKitBatteryService` for data access
- Enables easier testing and flexibility

### 4. Type Safety
Strong typing throughout:
- Dedicated model types instead of dictionaries
- Enums for formatting utilities
- Protocol-oriented where appropriate

## Data Flow

```
IOKit (System)
    ↓
IOKitBatteryService (reads battery data)
    ↓
BatteryMonitor (processes and publishes data)
    ↓
Views (observe and display data)
    ↓
BatteryFormatter (formats data for display)
```

## Key Technologies

- **SwiftUI**: Declarative UI framework
- **Combine**: Reactive programming with `@Published` and `ObservableObject`
- **IOKit**: Low-level system battery information access
- **AppStorage**: Persistent user preferences
- **OSLog**: Structured logging for debugging

## Adding New Features

### Adding a New View
1. Create the view file in appropriate `Views/` subfolder
2. Follow existing naming conventions
3. Use existing components where possible
4. Preview with `#Preview` macro

### Adding New Battery Data
1. Add property to `BatteryMonitor` with `@Published`
2. Update `updateBatteryInfo()` to fetch the data
3. Add to `IOKitBatteryService` if it requires IOKit access
4. Update views to display the new data

### Adding a New Component
1. Create in `Views/Components/`
2. Make it generic and reusable
3. Add `#Preview` for easy testing
4. Document parameters clearly

## Best Practices

1. **Keep views simple**: Extract complex logic to ViewModels
2. **Use computed properties**: For derived state in views
3. **Prefer composition**: Build complex views from simple components
4. **Follow SwiftUI conventions**: Use `@State`, `@Binding`, `@ObservedObject` appropriately
5. **Test in Preview**: Use `#Preview` for rapid development
6. **Log appropriately**: Use OSLog for debugging, not print statements
