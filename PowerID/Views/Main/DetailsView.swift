//
//  DetailsView.swift
//  PowerID
//
//  Detailed battery information view
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var batteryMonitor: BatteryMonitor

    var body: some View {
        VStack(spacing: 0) {
            // Header - Fixed at top
            headerView

            Divider()

            // Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    capacitySection
                    electricalSection
                    healthSection
                    powerSourceSection
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Header

    private var headerView: some View {
        Text("Battery Details")
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Sections

    private var capacitySection: some View {
        DetailSection(title: "Capacity", icon: "battery.100") {
            DetailRow(label: "Current Capacity", value: "\(batteryMonitor.currentCapacity) mAh")
            DetailRow(label: "Maximum Capacity", value: "\(batteryMonitor.maxCapacity) mAh")
            DetailRow(label: "Design Capacity", value: "\(batteryMonitor.designCapacity) mAh")
            DetailRow(label: "Battery Level", value: "\(batteryMonitor.batteryLevel)%")
        }
    }

    private var electricalSection: some View {
        DetailSection(title: "Electrical", icon: "bolt.fill") {
            DetailRow(label: "Voltage", value: String(format: "%.2f V", batteryMonitor.voltage))
            DetailRow(label: "Amperage", value: String(format: "%.0f mA", batteryMonitor.amperage))
            DetailRow(label: "Power Draw", value: String(format: "%.2f W", batteryMonitor.chargingWattage))
        }
    }

    private var healthSection: some View {
        DetailSection(title: "Health & Lifecycle", icon: "heart.fill") {
            DetailRow(label: "Battery Health", value: "\(batteryMonitor.batteryHealth)%")
            DetailRow(label: "Cycle Count", value: "\(batteryMonitor.cycleCount)")
            DetailRow(label: "Temperature", value: String(format: "%.1f °C", batteryMonitor.temperature))
        }
    }

    private var powerSourceSection: some View {
        DetailSection(title: "Power Source", icon: "powerplug.fill") {
            DetailRow(label: "Status", value: batteryMonitor.isCharging ? "Charging" : "On Battery")
            DetailRow(label: "Type", value: batteryMonitor.powerSourceType)
            if batteryMonitor.timeToFullCharge > 0 {
                DetailRow(
                    label: "Time to Full Charge",
                    value: BatteryFormatter.formatTime(batteryMonitor.timeToFullCharge)
                )
            }
        }
    }
}

#Preview {
    DetailsView(batteryMonitor: BatteryMonitor())
}
