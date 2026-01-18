//
//  BatteryMonitor.swift
//  PowerID
//
//  View model for monitoring battery status and information
//

import Foundation
import Combine
import IOKit
import IOKit.ps
import os.log

/// View model responsible for monitoring and publishing battery information
@MainActor
class BatteryMonitor: ObservableObject {
    // MARK: - Published Properties

    @Published var batteryLevel: Int = 0
    @Published var isCharging: Bool = false
    @Published var batteryHealth: Int = 0
    @Published var cycleCount: Int = 0
    @Published var currentCapacity: Int = 0
    @Published var maxCapacity: Int = 0
    @Published var designCapacity: Int = 0
    @Published var voltage: Double = 0.0
    @Published var amperage: Double = 0.0
    @Published var temperature: Double = 0.0
    @Published var chargingWattage: Double = 0.0
    @Published var timeToFullCharge: Int = 0
    @Published var powerSourceType: String = "Unknown"
    @Published var lastUpdate: String = ""

    // MARK: - Private Properties

    private var monitoringTask: Task<Void, Never>?
    private let logger = Logger(subsystem: "com.powerid.battery", category: "BatteryMonitor")
    private let ioKitService = IOKitBatteryService()

    // MARK: - Initialization

    init() {
        logger.info("BatteryMonitor initialized")
        startMonitoring()
    }

    deinit {
        logger.info("BatteryMonitor deinitialized, stopping monitoring")
        monitoringTask?.cancel()
    }

    // MARK: - Public Methods

    /// Starts the battery monitoring with continuous updates
    func startMonitoring(interval: TimeInterval = 2.0) {
        logger.info("Starting battery monitoring with \(interval)s interval")

        // Cancel any existing monitoring task
        monitoringTask?.cancel()

        // Create a new monitoring task
        monitoringTask = Task { @MainActor in
            // Initial update
            updateBatteryInfo()

            // Continuous monitoring loop
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(interval))
                if !Task.isCancelled {
                    updateBatteryInfo()
                }
            }
        }
    }

    /// Updates all battery information from system
    func updateBatteryInfo() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else {
            logger.error("Failed to get power source information")
            return
        }

        logger.debug("Found \(sources.count) power source(s)")

        for source in sources {
            guard let info = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any] else {
                logger.warning("Failed to get power source description")
                continue
            }

            updateProperties(from: info)
        }
    }

    // MARK: - Private Methods

    /// Updates all properties from the power source info dictionary
    private func updateProperties(from info: [String: Any]) {
        logger.debug("Processing power source info")
        logger.debug("Available keys: \(info.keys.sorted().joined(separator: ", "))")

        updateBatteryLevel(from: info)
        updateChargingStatus(from: info)
        updateCapacities(from: info)
        updateBatteryHealth()
        updateCycleCount()
        updateElectricalInfo()
        updatePowerSourceType(from: info)
        updateTimestamp()

        logBatteryStatus()
    }

    private func updateBatteryLevel(from info: [String: Any]) {
        if let currentCapacity = info[kIOPSCurrentCapacityKey] as? Int,
           let maxCapacity = info[kIOPSMaxCapacityKey] as? Int,
           maxCapacity > 0 {
            batteryLevel = (currentCapacity * 100) / maxCapacity
        }
    }

    private func updateChargingStatus(from info: [String: Any]) {
        isCharging = info[kIOPSIsChargingKey] as? Bool ?? false
        timeToFullCharge = info[kIOPSTimeToFullChargeKey] as? Int ?? 0
    }

    private func updateCapacities(from info: [String: Any]) {
        currentCapacity = info["Current Capacity"] as? Int ?? 0
        maxCapacity = info["Max Capacity"] as? Int ?? 0
        designCapacity = ioKitService.getDesignCapacity()

        logger.debug("Capacity values - Current: \(self.currentCapacity), Max: \(self.maxCapacity), Design: \(self.designCapacity)")
    }

    private func updateBatteryHealth() {
        if designCapacity > 0 {
            batteryHealth = (maxCapacity * 100) / designCapacity
        }
    }

    private func updateCycleCount() {
        cycleCount = ioKitService.getCycleCount()
        logger.debug("Cycle count: \(self.cycleCount)")
    }

    private func updateElectricalInfo() {
        let batteryInfo = ioKitService.getBatteryInfo()
        voltage = batteryInfo.voltage
        amperage = batteryInfo.amperage
        temperature = batteryInfo.temperature

        // Calculate Wattage (W = V * A)
        chargingWattage = (voltage * abs(amperage)) / 1000.0

        logger.debug("Voltage: \(self.voltage) V")
        logger.debug("Amperage: \(self.amperage) mA")
        logger.debug("Temperature: \(String(format: "%.1f", self.temperature))°C")
    }

    private func updatePowerSourceType(from info: [String: Any]) {
        if let transportType = info["Transport Type"] as? String {
            powerSourceType = transportType
        } else if isCharging {
            powerSourceType = "AC Power"
        } else {
            powerSourceType = "Battery"
        }
    }

    private func updateTimestamp() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        lastUpdate = formatter.string(from: Date())
    }

    private func logBatteryStatus() {
        logger.info("Battery updated - Level: \(self.batteryLevel)%, Charging: \(self.isCharging), Health: \(self.batteryHealth)%, Cycles: \(self.cycleCount), Wattage: \(String(format: "%.2f", self.chargingWattage))W")
    }
}
