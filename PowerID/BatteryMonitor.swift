import Foundation
import Combine
import IOKit
import IOKit.ps
import os.log

class BatteryMonitor: ObservableObject {
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

    private var timer: Timer?
    private let logger = Logger(subsystem: "com.powerid.battery", category: "BatteryMonitor")

    init() {
        logger.info("BatteryMonitor initialized")
        startMonitoring()
    }

    func startMonitoring() {
        logger.info("Starting battery monitoring with 2.0s interval")
        updateBatteryInfo()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateBatteryInfo()
        }
    }

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

            logger.debug("Processing power source info")

            // Log all available keys for debugging
            logger.debug("Available keys: \(info.keys.sorted().joined(separator: ", "))")

            // Battery Level
            if let currentCapacity = info[kIOPSCurrentCapacityKey] as? Int,
               let maxCapacity = info[kIOPSMaxCapacityKey] as? Int, maxCapacity > 0 {
                batteryLevel = (currentCapacity * 100) / maxCapacity
            }

            // Charging Status
            isCharging = info[kIOPSIsChargingKey] as? Bool ?? false

            // Current and Max Capacity (mAh) - using correct key names with spaces
            self.currentCapacity = info["Current Capacity"] as? Int ?? 0
            self.maxCapacity = info["Max Capacity"] as? Int ?? 0

            // Get design capacity from IOKit registry
            self.designCapacity = getDesignCapacity()

            logger.debug("Capacity values - Current: \(self.currentCapacity), Max: \(self.maxCapacity), Design: \(self.designCapacity)")

            // Battery Health
            if designCapacity > 0 {
                batteryHealth = (maxCapacity * 100) / designCapacity
            }

            // Cycle Count - get from IOKit registry
            cycleCount = getCycleCount()
            logger.debug("Cycle count: \(self.cycleCount)")

            // Voltage and Amperage from IOKit registry
            let batteryInfo = getBatteryInfoFromRegistry()
            voltage = batteryInfo.voltage
            amperage = batteryInfo.amperage
            temperature = batteryInfo.temperature

            logger.debug("Voltage: \(self.voltage) V")
            logger.debug("Amperage: \(self.amperage) mA")

            // Calculate Wattage (W = V * A)
            chargingWattage = (voltage * abs(amperage)) / 1000.0

            logger.debug("Temperature: \(String(format: "%.1f", self.temperature))°C")

            // Time to Full Charge
            timeToFullCharge = info[kIOPSTimeToFullChargeKey] as? Int ?? 0

            // Power Source Type
            if let transportType = info["Transport Type"] as? String {
                powerSourceType = transportType
            } else if isCharging {
                powerSourceType = "AC Power"
            } else {
                powerSourceType = "Battery"
            }

            // Update timestamp
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            lastUpdate = formatter.string(from: Date())

            logger.info("Battery updated - Level: \(self.batteryLevel)%, Charging: \(self.isCharging), Health: \(self.batteryHealth)%, Cycles: \(self.cycleCount), Wattage: \(String(format: "%.2f", self.chargingWattage))W")
        }
    }

    // Helper function to get battery info from IOKit registry
    private func getBatteryInfoFromRegistry() -> (voltage: Double, amperage: Double, temperature: Double) {
        var voltage: Double = 0.0
        var amperage: Double = 0.0
        var temperature: Double = 0.0

        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("AppleSmartBattery"))
        guard service != 0 else {
            logger.warning("Could not find AppleSmartBattery service")
            return (voltage, amperage, temperature)
        }

        defer { IOObjectRelease(service) }

        // Get voltage (in mV)
        if let voltageValue = getRegistryProperty(service: service, key: "Voltage") as? Int {
            voltage = Double(voltageValue) / 1000.0 // Convert mV to V
        }

        // Get amperage (in mA)
        if let amperageValue = getRegistryProperty(service: service, key: "Amperage") as? Int {
            amperage = Double(amperageValue)
        }

        // Get temperature (in 0.1 Kelvin)
        if let tempValue = getRegistryProperty(service: service, key: "Temperature") as? Int {
            temperature = (Double(tempValue) / 10.0) - 273.15 // Convert to Celsius
        }

        return (voltage, amperage, temperature)
    }

    private func getDesignCapacity() -> Int {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("AppleSmartBattery"))
        guard service != 0 else { return 0 }
        defer { IOObjectRelease(service) }

        return getRegistryProperty(service: service, key: "DesignCapacity") as? Int ?? 0
    }

    private func getCycleCount() -> Int {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("AppleSmartBattery"))
        guard service != 0 else { return 0 }
        defer { IOObjectRelease(service) }

        return getRegistryProperty(service: service, key: "CycleCount") as? Int ?? 0
    }

    private func getRegistryProperty(service: io_service_t, key: String) -> Any? {
        return IORegistryEntryCreateCFProperty(service, key as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue()
    }

    deinit {
        logger.info("BatteryMonitor deinitialized, stopping monitoring")
        timer?.invalidate()
    }
}
