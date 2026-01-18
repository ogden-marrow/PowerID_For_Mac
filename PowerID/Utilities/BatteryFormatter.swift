//
//  BatteryFormatter.swift
//  PowerID
//
//  Utility for formatting battery-related values and UI elements
//

import SwiftUI

/// Utility struct for formatting battery information and UI elements
enum BatteryFormatter {
    // MARK: - Time Formatting

    /// Formats time in minutes to a human-readable string
    static func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return "\(hours)h \(mins)m"
        } else {
            return "\(mins)m"
        }
    }

    // MARK: - Battery Icon

    /// Returns the appropriate SF Symbol icon name based on battery level and charging status
    static func batteryIcon(level: Int, isCharging: Bool) -> String {
        if isCharging {
            return "battery.100.bolt"
        } else if level < 20 {
            return "battery.25"
        } else if level < 50 {
            return "battery.50"
        } else if level < 75 {
            return "battery.75"
        } else {
            return "battery.100"
        }
    }

    // MARK: - Battery Gradient

    /// Returns the appropriate gradient based on battery level and charging status
    static func batteryGradient(level: Int, isCharging: Bool) -> LinearGradient {
        if isCharging {
            return LinearGradient(
                colors: [.green, .mint],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else if level < 20 {
            return LinearGradient(
                colors: [.red, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else if level < 50 {
            return LinearGradient(
                colors: [.orange, .yellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [.blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    // MARK: - Health Color

    /// Returns the appropriate color based on battery health percentage
    static func healthColor(health: Int) -> Color {
        if health >= 80 {
            return .green
        } else if health >= 60 {
            return .orange
        } else {
            return .red
        }
    }
}
