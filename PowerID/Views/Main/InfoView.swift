//
//  InfoView.swift
//  PowerID
//
//  Information and tips about battery data
//

import SwiftUI

struct InfoView: View {
    @ObservedObject var batteryMonitor: BatteryMonitor

    var body: some View {
        VStack(spacing: 0) {
            // Header - Fixed at top
            headerView

            Divider()

            // Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    infoSections
                    tipsSection
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Header

    private var headerView: some View {
        Text("About Battery Data")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Info Sections

    private var infoSections: some View {
        Group {
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
        }
    }

    // MARK: - Tips Section

    private var tipsSection: some View {
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
}

#Preview {
    InfoView(batteryMonitor: BatteryMonitor())
}
