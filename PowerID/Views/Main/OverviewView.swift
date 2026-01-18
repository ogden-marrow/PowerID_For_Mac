//
//  OverviewView.swift
//  PowerID
//
//  Overview tab showing main battery statistics
//

import SwiftUI

struct OverviewView: View {
    @ObservedObject var batteryMonitor: BatteryMonitor

    var body: some View {
        VStack(spacing: 0) {
            // Header - Fixed at top
            headerView

            Divider()

            // Scrollable Content
            ScrollView {
                VStack(spacing: 30) {
                    batteryLevelSection
                    statusCardsSection
                    lastUpdatedView
                }
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Header View

    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: batteryIcon)
                .font(.system(size: 50))
                .foregroundStyle(batteryGradient)
                .symbolRenderingMode(.hierarchical)

            Text("Power ID")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Battery Level Section

    private var batteryLevelSection: some View {
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
            BatteryProgressBar(
                level: batteryMonitor.batteryLevel,
                gradient: batteryGradient
            )
            .frame(height: 16)
            .padding(.horizontal, 40)
        }
        .padding(.horizontal)
    }

    // MARK: - Status Cards Section

    private var statusCardsSection: some View {
        VStack(spacing: 16) {
            // Charging Status Card
            StatusCard(
                icon: batteryMonitor.isCharging ? "bolt.fill" : "battery.100",
                title: "Status",
                value: batteryMonitor.isCharging ? "Charging" : "On Battery",
                color: batteryMonitor.isCharging ? .green : .blue
            )

            if batteryMonitor.isCharging {
                chargingCards
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
    }

    private var chargingCards: some View {
        Group {
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
                    value: BatteryFormatter.formatTime(batteryMonitor.timeToFullCharge),
                    color: .purple
                )
            }
        }
    }

    private var lastUpdatedView: some View {
        Text("Last updated: \(batteryMonitor.lastUpdate)")
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.bottom, 20)
    }

    // MARK: - Computed Properties

    private var batteryIcon: String {
        BatteryFormatter.batteryIcon(
            level: batteryMonitor.batteryLevel,
            isCharging: batteryMonitor.isCharging
        )
    }

    private var batteryGradient: LinearGradient {
        BatteryFormatter.batteryGradient(
            level: batteryMonitor.batteryLevel,
            isCharging: batteryMonitor.isCharging
        )
    }

    private var healthColor: Color {
        BatteryFormatter.healthColor(health: batteryMonitor.batteryHealth)
    }
}

#Preview {
    OverviewView(batteryMonitor: BatteryMonitor())
}
