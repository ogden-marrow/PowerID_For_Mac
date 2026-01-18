//
//  IOKitBatteryService.swift
//  PowerID
//
//  Service for interacting with IOKit to retrieve battery information
//

import Foundation
import IOKit
import IOKit.ps
import os.log

/// Service class for retrieving battery information from IOKit registry
final class IOKitBatteryService {
    private let logger = Logger(subsystem: "com.powerid.battery", category: "IOKitService")

    // MARK: - Public Methods

    /// Retrieves battery electrical information (voltage, amperage, temperature)
    func getBatteryInfo() -> BatteryElectricalInfo {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("AppleSmartBattery"))
        guard service != 0 else {
            logger.warning("Could not find AppleSmartBattery service")
            return .empty
        }

        defer { IOObjectRelease(service) }

        let voltage = getVoltage(from: service)
        let amperage = getAmperage(from: service)
        let temperature = getTemperature(from: service)

        return BatteryElectricalInfo(
            voltage: voltage,
            amperage: amperage,
            temperature: temperature
        )
    }

    /// Retrieves the battery's design capacity in mAh
    func getDesignCapacity() -> Int {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("AppleSmartBattery"))
        guard service != 0 else { return 0 }
        defer { IOObjectRelease(service) }

        return getRegistryProperty(service: service, key: "DesignCapacity") as? Int ?? 0
    }

    /// Retrieves the battery's cycle count
    func getCycleCount() -> Int {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("AppleSmartBattery"))
        guard service != 0 else { return 0 }
        defer { IOObjectRelease(service) }

        return getRegistryProperty(service: service, key: "CycleCount") as? Int ?? 0
    }

    // MARK: - Private Methods

    private func getVoltage(from service: io_service_t) -> Double {
        if let voltageValue = getRegistryProperty(service: service, key: "Voltage") as? Int {
            return Double(voltageValue) / 1000.0 // Convert mV to V
        }
        return 0.0
    }

    private func getAmperage(from service: io_service_t) -> Double {
        if let amperageValue = getRegistryProperty(service: service, key: "Amperage") as? Int {
            return Double(amperageValue)
        }
        return 0.0
    }

    private func getTemperature(from service: io_service_t) -> Double {
        if let tempValue = getRegistryProperty(service: service, key: "Temperature") as? Int {
            return (Double(tempValue) / 10.0) - 273.15 // Convert 0.1 Kelvin to Celsius
        }
        return 0.0
    }

    private func getRegistryProperty(service: io_service_t, key: String) -> Any? {
        return IORegistryEntryCreateCFProperty(service, key as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue()
    }
}
