# PowerID ⚡

<div align="center">

![PowerID Icon](https://img.shields.io/badge/macOS-15.7+-blue?style=for-the-badge&logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.0-orange?style=for-the-badge&logo=swift)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Advanced Battery Monitoring for macOS**

A beautiful, native macOS application that provides detailed insights into your Mac's battery health, performance, and power consumption.

[Features](#features) • [Installation](#installation) • [Screenshots](#screenshots) • [Building](#building) • [Contributing](#contributing)

</div>

---

## ✨ Features

### Real-Time Monitoring
- **Live Updates**: Battery information refreshes every 2 seconds
- **Accurate Metrics**: Direct access to IOKit for precise battery data
- **Zero Performance Impact**: Lightweight and efficient native Swift implementation

### Comprehensive Battery Information

#### 📊 Overview Tab
- **Battery Level**: Large, easy-to-read percentage display with dynamic color gradient
- **Charging Status**: Clear indication of charging state with visual feedback
- **Charging Power**: Real-time wattage display when connected to power
- **Time to Full Charge**: Estimated charging time remaining
- **Battery Health**: Quick health percentage at a glance
- **Cycle Count**: Total charge-discharge cycles

#### 📋 Details Tab
Complete battery specifications organized into intuitive sections:

**Capacity Metrics**
- Current Capacity (mAh)
- Maximum Capacity (mAh)
- Design Capacity (mAh)
- Current Battery Level (%)

**Electrical Metrics**
- Voltage (V)
- Amperage (mA)
- Power Draw/Wattage (W)

**Health & Lifecycle**
- Battery Health Percentage
- Cycle Count
- Temperature (°C)

**Power Source**
- Charging Status
- Power Source Type
- Time to Full Charge

#### ℹ️ Info Tab
Educational content explaining:
- What each metric means
- How to interpret the data
- Battery care tips and best practices
- Optimal battery maintenance guidelines

### Beautiful Native Interface
- **Pure SwiftUI**: Modern, native macOS design language
- **Dynamic Colors**: Adaptive color schemes based on battery state
- **Smooth Animations**: Fluid transitions and progress indicators
- **Dark Mode Support**: Full support for light and dark appearances
- **Responsive Layout**: Optimized for various window sizes

---

## 📸 Screenshots

> Add screenshots here showing the three tabs in action

---

## 🚀 Installation

### Option 1: Download Pre-built Release (Easiest)

1. Go to the [Releases](https://github.com/yourusername/powerid/releases) page
2. Download the latest `PowerID.dmg` or `PowerID.zip`
3. **For DMG:**
   - Open the DMG file
   - Drag PowerID to your Applications folder
   - Eject the DMG
4. **For ZIP:**
   - Unzip the archive
   - Move PowerID.app to Applications
5. Launch PowerID from your Applications folder

#### ⚠️ First Launch Security Notice
Since the app is unsigned, macOS will prevent it from opening the first time:
1. Go to **System Settings** > **Privacy & Security**
2. Scroll down to find the security message about PowerID
3. Click **"Open Anyway"**
4. Confirm you want to open the app

### Option 2: Build from Source

See the [Building from Source](#building) section below.

---

## 🛠 Building from Source

### Prerequisites

- macOS 15.7 or later
- Xcode 16.2 or later
- Swift 5.0+
- Command Line Tools for Xcode

### Build Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/powerid.git
   cd powerid
   ```

2. **Generate app icons** (optional, icons may already exist)
   ```bash
   chmod +x generate_icon.swift
   ./generate_icon.swift
   ```

3. **Open in Xcode**
   ```bash
   open PowerID.xcodeproj
   ```

4. **Build and Run**
   - Select the "PowerID" scheme
   - Choose your Mac as the destination
   - Press `⌘R` to build and run
   - Or press `⌘B` to build only

### Command Line Build

```bash
xcodebuild clean build \
  -project PowerID.xcodeproj \
  -scheme PowerID \
  -configuration Release \
  -derivedDataPath build
```

The built app will be located at:
```
build/Build/Products/Release/PowerID.app
```

---

## 🏗 Project Structure

```
PowerID/
├── PowerID.xcodeproj/          # Xcode project configuration
├── PowerID/                     # Source code
│   ├── PowerIDApp.swift        # App entry point and settings
│   ├── ContentView.swift       # Main UI and all views
│   ├── BatteryMonitor.swift    # Battery monitoring logic
│   └── Assets.xcassets/        # App icons and assets
├── generate_icon.swift          # Icon generation script
├── .github/
│   └── workflows/
│       └── build-release.yml   # Automated build and release
├── README.md                    # This file
└── RELEASE.md                   # Release process documentation
```

### Key Components

#### `BatteryMonitor.swift`
The core battery monitoring engine that:
- Interfaces with IOKit to access battery information
- Uses IOPSCopyPowerSourcesInfo for power source data
- Queries IOKit registry for detailed battery metrics
- Publishes updates via Combine framework
- Implements efficient 2-second polling

**Key APIs Used:**
- `IOPSCopyPowerSourcesInfo()`: Power source information
- `IOServiceGetMatchingService()`: AppleSmartBattery service access
- `IORegistryEntryCreateCFProperty()`: Registry property queries

#### `ContentView.swift`
SwiftUI views organized into:
- **OverviewView**: Primary dashboard with key metrics
- **DetailsView**: Comprehensive battery specifications
- **HistoryView**: Educational information and tips
- Supporting custom views: `StatusCard`, `DetailSection`, `InfoSection`

#### `PowerIDApp.swift`
Application lifecycle and settings:
- Window configuration (disabled full-screen)
- Settings interface with preferences
- App delegate for macOS integration
- Menu commands and keyboard shortcuts

#### `generate_icon.swift`
Automated icon generation:
- Creates all required icon sizes (16x16 to 1024x1024)
- Generates beautiful gradient backgrounds
- Embeds SF Symbol (bolt.fill)
- Outputs PNG files for all resolutions

---

## 🎨 Design Philosophy

### Native First
PowerID is built using pure SwiftUI and native macOS APIs. No third-party dependencies, no Electron, no web views—just fast, native code that feels at home on macOS.

### Information Hierarchy
The three-tab interface progressively discloses information:
1. **Overview**: Quick glance at critical metrics
2. **Details**: Comprehensive specifications for power users
3. **Info**: Educational content for understanding the data

### Visual Feedback
- Color-coded battery states (red/orange for low, green for healthy)
- Smooth animations for state changes
- Dynamic gradients that reflect battery status
- Clear iconography using SF Symbols

### Performance
- Efficient IOKit queries minimize system impact
- 2-second update interval balances freshness with efficiency
- Compiled Swift code for maximum performance
- Minimal memory footprint

---

## 🔧 Technical Details

### Battery Metrics Explained

| Metric | Description | Source |
|--------|-------------|--------|
| Battery Level | Current charge as % of max capacity | IOPowerSources API |
| Current Capacity | Actual charge in mAh | IOKit Registry |
| Max Capacity | Current full charge capacity | IOKit Registry |
| Design Capacity | Original factory capacity | IOKit Registry |
| Battery Health | (Max / Design) × 100% | Calculated |
| Cycle Count | Total charge-discharge cycles | IOKit Registry |
| Voltage | Battery voltage in volts | IOKit Registry |
| Amperage | Current flow in milliamps | IOKit Registry |
| Wattage | Power (V × A) / 1000 | Calculated |
| Temperature | Battery temp in Celsius | IOKit Registry |

### System Requirements

- **Operating System**: macOS 15.7 or later
- **Architecture**: Apple Silicon or Intel
- **Hardware**: Mac with battery (not compatible with Mac mini, Mac Studio, Mac Pro)
- **Permissions**: No special permissions required

### App Sandbox

PowerID runs in the App Sandbox with:
- `ENABLE_APP_SANDBOX = YES`
- `ENABLE_USER_SELECTED_FILES = readonly`
- IOKit access for battery information (allowed in sandbox)

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### Reporting Issues
- Use the [Issues](https://github.com/yourusername/powerid/issues) page
- Include macOS version, Mac model, and steps to reproduce
- Screenshots are helpful!

### Submitting Pull Requests
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Swift style conventions
- Maintain SwiftUI best practices
- Keep the native macOS feel
- Test on both Intel and Apple Silicon if possible
- Update documentation for new features

### Ideas for Contributions
- [ ] Menu bar mode with quick stats
- [ ] Battery health notifications
- [ ] Historical battery data tracking
- [ ] Export battery reports
- [ ] Widget support
- [ ] Localization for other languages
- [ ] Battery usage predictions
- [ ] Comparison with similar Mac models

---

## 📊 Automated Builds

PowerID uses GitHub Actions for automated builds and releases.

### Creating a Release

```bash
# Create a version tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push the tag
git push origin v1.0.0
```

GitHub Actions will automatically:
1. Build the app
2. Generate app icons
3. Create DMG and ZIP distributions
4. Publish a GitHub release

See [RELEASE.md](RELEASE.md) for detailed release instructions.

---

## 🐛 Troubleshooting

### App Won't Open
**Problem**: macOS blocks the app with "cannot be opened because it is from an unidentified developer"

**Solution**: 
1. Go to System Settings > Privacy & Security
2. Find the message about PowerID
3. Click "Open Anyway"

### Battery Data Not Showing
**Problem**: All values show as 0 or "Unknown"

**Solution**:
- Ensure you're running on a Mac with a battery
- Check Console.app for error messages from PowerID
- Try restarting the app

### Build Errors in Xcode
**Problem**: "File not found" or missing assets

**Solution**:
1. Run `./generate_icon.swift` to create icons
2. Clean build folder: Product > Clean Build Folder (`⌘⇧K`)
3. Restart Xcode

### Icons Not Generating
**Problem**: `generate_icon.swift` fails to create icons

**Solution**:
```bash
chmod +x generate_icon.swift
./generate_icon.swift
```

Verify the output path exists:
```bash
ls -la PowerID/Assets.xcassets/AppIcon.appiconset/
```

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2026 PowerID Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Acknowledgments

- Built with [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- Icons use [SF Symbols](https://developer.apple.com/sf-symbols/)
- Inspired by the need for detailed battery information on macOS
- Thanks to the macOS developer community

---

## 📮 Contact

- **Issues**: [GitHub Issues](https://github.com/ogden-marrow/powerid/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ogden-marrow/powerid/discussions)
- **Website**: [jpalenchar.me](https://jpalenchar.me)

---

<div align="center">

**Made with ⚡ and ❤️ for the Mac community**

[⬆ Back to Top](#powerid-)

</div>
