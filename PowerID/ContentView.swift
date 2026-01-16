import SwiftUI

struct ContentView: View {
    @StateObject private var batteryMonitor = BatteryMonitor()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            OverviewView(batteryMonitor: batteryMonitor)
                .tabItem {
                    Label("Overview", systemImage: "gauge.with.dots.needle.67percent")
                }
                .tag(0)

            DetailsView(batteryMonitor: batteryMonitor)
                .tabItem {
                    Label("Details", systemImage: "list.bullet.rectangle")
                }
                .tag(1)

            HistoryView(batteryMonitor: batteryMonitor)
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
                .tag(2)
        }
        .frame(minWidth: 600, minHeight: 500)
    }
}

// MARK: - Overview View
struct OverviewView: View {
    @ObservedObject var batteryMonitor: BatteryMonitor

    var body: some View {
        VStack(spacing: 0) {
            // Header - Fixed at top
            VStack(spacing: 8) {
                Image(systemName: batteryIcon)
                    .font(.system(size: 50))
                    .foregroundStyle(batteryGradient)
                    .symbolRenderingMode(.hierarchical)

                Text("PowerID")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(NSColor.windowBackgroundColor))

            Divider()

            // Scrollable Content
            ScrollView {
                VStack(spacing: 30) {
                    // Main Battery Display
                    VStack(spacing: 20) {
                        // Battery Percentage
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(batteryMonitor.batteryLevel)")
                                .font(.system(size: 80, weight: .bold, design: .rounded))
                                .foregroundStyle(batteryGradient)
                            Text("%")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)

                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 16)

                                // Foreground
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(batteryGradient)
                                    .frame(width: geometry.size.width * Double(batteryMonitor.batteryLevel) / 100.0, height: 16)
                                    .animation(.spring(response: 0.5), value: batteryMonitor.batteryLevel)
                            }
                        }
                        .frame(height: 16)
                        .padding(.horizontal, 40)
                    }
                    .padding(.horizontal)

                    // Status Cards
                    VStack(spacing: 16) {
                        // Charging Status Card
                        StatusCard(
                            icon: batteryMonitor.isCharging ? "bolt.fill" : "battery.100",
                            title: "Status",
                            value: batteryMonitor.isCharging ? "Charging" : "On Battery",
                            color: batteryMonitor.isCharging ? .green : .blue
                        )

                        if batteryMonitor.isCharging {
                            // Charging Power Card
                            StatusCard(
                                icon: "powerplug.fill",
                                title: "Charging Power",
                                value: String(format: "%.1f W", batteryMonitor.chargingWattage),
                                color: .orange
                            )

                            // Time to Full Card
                            if batteryMonitor.timeToFullCharge > 0 {
                                StatusCard(
                                    icon: "clock.fill",
                                    title: "Time to Full Charge",
                                    value: formatTime(batteryMonitor.timeToFullCharge),
                                    color: .purple
                                )
                            }
                        }

                        // Battery Health Card
                        StatusCard(
                            icon: "heart.fill",
                            title: "Battery Health",
                            value: "\(batteryMonitor.batteryHealth)%",
                            color: healthColor
                        )

                        // Cycle Count Card
                        StatusCard(
                            icon: "arrow.triangle.2.circlepath",
                            title: "Cycle Count",
                            value: "\(batteryMonitor.cycleCount)",
                            color: .indigo
                        )
                    }
                    .padding(.horizontal, 40)

                    // Last Updated
                    Text("Last updated: \(batteryMonitor.lastUpdate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)
                }
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }

    private var batteryIcon: String {
        if batteryMonitor.isCharging {
            return "battery.100.bolt"
        } else if batteryMonitor.batteryLevel < 20 {
            return "battery.25"
        } else if batteryMonitor.batteryLevel < 50 {
            return "battery.50"
        } else if batteryMonitor.batteryLevel < 75 {
            return "battery.75"
        } else {
            return "battery.100"
        }
    }

    private var batteryGradient: LinearGradient {
        if batteryMonitor.isCharging {
            return LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if batteryMonitor.batteryLevel < 20 {
            return LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if batteryMonitor.batteryLevel < 50 {
            return LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private var healthColor: Color {
        if batteryMonitor.batteryHealth >= 80 {
            return .green
        } else if batteryMonitor.batteryHealth >= 60 {
            return .orange
        } else {
            return .red
        }
    }

    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return "\(hours)h \(mins)m"
        } else {
            return "\(mins)m"
        }
    }
}

// MARK: - Details View
struct DetailsView: View {
    @ObservedObject var batteryMonitor: BatteryMonitor

    var body: some View {
        VStack(spacing: 0) {
            // Header - Fixed at top
            Text("Battery Details")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color(NSColor.windowBackgroundColor))

            Divider()

            // Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Capacity Section
                    DetailSection(title: "Capacity", icon: "battery.100") {
                        DetailRow(label: "Current Capacity", value: "\(batteryMonitor.currentCapacity) mAh")
                        DetailRow(label: "Maximum Capacity", value: "\(batteryMonitor.maxCapacity) mAh")
                        DetailRow(label: "Design Capacity", value: "\(batteryMonitor.designCapacity) mAh")
                        DetailRow(label: "Battery Level", value: "\(batteryMonitor.batteryLevel)%")
                    }

                    // Electrical Section
                    DetailSection(title: "Electrical", icon: "bolt.fill") {
                        DetailRow(label: "Voltage", value: String(format: "%.2f V", batteryMonitor.voltage))
                        DetailRow(label: "Amperage", value: String(format: "%.0f mA", batteryMonitor.amperage))
                        DetailRow(label: "Power Draw", value: String(format: "%.2f W", batteryMonitor.chargingWattage))
                    }

                    // Health Section
                    DetailSection(title: "Health & Lifecycle", icon: "heart.fill") {
                        DetailRow(label: "Battery Health", value: "\(batteryMonitor.batteryHealth)%")
                        DetailRow(label: "Cycle Count", value: "\(batteryMonitor.cycleCount)")
                        DetailRow(label: "Temperature", value: String(format: "%.1f °C", batteryMonitor.temperature))
                    }

                    // Power Source Section
                    DetailSection(title: "Power Source", icon: "powerplug.fill") {
                        DetailRow(label: "Status", value: batteryMonitor.isCharging ? "Charging" : "On Battery")
                        DetailRow(label: "Type", value: batteryMonitor.powerSourceType)
                        if batteryMonitor.timeToFullCharge > 0 {
                            DetailRow(label: "Time to Full Charge", value: formatTime(batteryMonitor.timeToFullCharge))
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }

    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return "\(hours)h \(mins)m"
        } else {
            return "\(mins)m"
        }
    }
}

// MARK: - Info View
struct HistoryView: View {
    @ObservedObject var batteryMonitor: BatteryMonitor

    var body: some View {
        VStack(spacing: 0) {
            // Header - Fixed at top
            Text("About Battery Data")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color(NSColor.windowBackgroundColor))

            Divider()

            // Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    InfoSection(
                        icon: "battery.100",
                        title: "Battery Level",
                        description: "The current charge level of your battery as a percentage. This shows how much energy remains compared to your battery's current maximum capacity."
                    )

                    InfoSection(
                        icon: "heart.fill",
                        title: "Battery Health",
                        description: "Compares your battery's current maximum capacity to its original design capacity. A healthy battery typically shows 80% or higher. As batteries age through normal use, this percentage gradually decreases."
                    )

                    InfoSection(
                        icon: "arrow.triangle.2.circlepath",
                        title: "Cycle Count",
                        description: "The number of complete charge-discharge cycles your battery has gone through. One cycle equals using 100% of your battery's capacity (not necessarily in one charge). Most Mac batteries are designed for up to 1000 cycles."
                    )

                    InfoSection(
                        icon: "battery.100percent",
                        title: "Capacity (mAh)",
                        description: "Measured in milliamp-hours (mAh), this indicates how much charge your battery can hold. Current Capacity is what it holds now, Maximum Capacity is what it can currently hold when fully charged, and Design Capacity is what it held when new."
                    )

                    InfoSection(
                        icon: "bolt.fill",
                        title: "Voltage & Amperage",
                        description: "Voltage (V) is the electrical potential of your battery. Amperage (mA) is the current flow - positive when charging, negative when discharging. Together they determine the charging or discharging rate."
                    )

                    InfoSection(
                        icon: "powerplug.fill",
                        title: "Power Draw / Wattage",
                        description: "Measured in watts (W), this shows how much power is flowing to or from your battery. Calculated by multiplying voltage and amperage (W = V × A). Higher wattage means faster charging or more power consumption."
                    )

                    InfoSection(
                        icon: "thermometer",
                        title: "Temperature",
                        description: "Your battery's current temperature in Celsius. Normal operating range is typically 10-35°C. Extreme temperatures can affect battery performance and longevity."
                    )

                    InfoSection(
                        icon: "clock.fill",
                        title: "Time to Full Charge",
                        description: "An estimate of how long it will take to fully charge your battery at the current charging rate. This appears only when your Mac is charging and updates as conditions change."
                    )

                    // Tips Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                            Text("Battery Care Tips")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 30)

                        VStack(alignment: .leading, spacing: 8) {
                            TipRow(text: "Keep your battery between 20-80% for optimal longevity")
                            TipRow(text: "Avoid extreme temperatures (too hot or too cold)")
                            TipRow(text: "Update macOS regularly for battery optimizations")
                            TipRow(text: "Use optimized battery charging in System Settings")
                            TipRow(text: "A cycle count under 1000 is generally healthy")
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color(NSColor.controlBackgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// MARK: - Info Section
struct InfoSection: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.accentColor)
                    .frame(width: 24)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 30)
    }
}

struct TipRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.secondary)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Supporting Views
struct StatusCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content

    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 30)

            VStack(spacing: 0) {
                content
            }
            .background(Color(NSColor.controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 30)
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }
}
