//
//  BatteryInfo.swift
//  PowerID
//
//  Data models for battery information
//

import Foundation

/// Electrical information from the battery
struct BatteryElectricalInfo {
    let voltage: Double
    let amperage: Double
    let temperature: Double

    static let empty = BatteryElectricalInfo(
        voltage: 0.0,
        amperage: 0.0,
        temperature: 0.0
    )
}

/// Complete battery snapshot
struct BatterySnapshot {
    let level: Int
    let isCharging: Bool
    let health: Int
    let cycleCount: Int
    let currentCapacity: Int
    let maxCapacity: Int
    let designCapacity: Int
    let voltage: Double
    let amperage: Double
    let temperature: Double
    let wattage: Double
    let timeToFullCharge: Int
    let powerSourceType: String
    let timestamp: Date
}
