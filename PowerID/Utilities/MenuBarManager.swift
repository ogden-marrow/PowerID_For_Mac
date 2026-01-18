//
//  MenuBarManager.swift
//  PowerID
//
//  Created by John Palenchar on 1/18/26.
//


import AppKit
import SwiftUI
import Combine

class MenuBarManager: ObservableObject {
    private var statusItem: NSStatusItem?
    private var batteryMonitor: BatteryMonitor

    @Published var isEnabled: Bool {
        didSet {
            Task { @MainActor in
                if self.isEnabled {
                    await self.setupMenuBar()
                } else {
                    await self.removeMenuBar()
                }
            }
        }
    }

    init(batteryMonitor: BatteryMonitor, isEnabled: Bool = true) {
        self.batteryMonitor = batteryMonitor
        self.isEnabled = isEnabled

        if isEnabled {
            Task { @MainActor in
                await self.setupMenuBar()
            }
        }
    }

    @MainActor
    private func setupMenuBar() async {
        // Create status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        guard let statusItem = statusItem,
              let _ = statusItem.button else { return }

        // Set initial icon and title
        await updateMenuBarDisplay()

        // Create menu
        let menu = NSMenu()

        // Battery level item
        let levelItem = NSMenuItem(
            title: "Battery: \(batteryMonitor.batteryLevel)%",
            action: nil,
            keyEquivalent: ""
        )
        menu.addItem(levelItem)

        // Charging status
        let statusText = batteryMonitor.isCharging ? "Charging" : "On Battery"
        let menuStatusItem = NSMenuItem(
            title: "Status: \(statusText)",
            action: nil,
            keyEquivalent: ""
        )
        menu.addItem(menuStatusItem)

        // Health
        let healthItem = NSMenuItem(
            title: "Health: \(batteryMonitor.batteryHealth)%",
            action: nil,
            keyEquivalent: ""
        )
        menu.addItem(healthItem)

        menu.addItem(NSMenuItem.separator())

        // Show main window
        let showItem = NSMenuItem(
            title: "Show PowerID",
            action: #selector(showMainWindow),
            keyEquivalent: ""
        )
        showItem.target = self
        menu.addItem(showItem)

        menu.addItem(NSMenuItem.separator())

        // Quit
        let quitItem = NSMenuItem(
            title: "Quit PowerID",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu

        // Observe battery changes to update menu
        setupObservers()
    }

    @MainActor
    private func removeMenuBar() async {
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
            self.statusItem = nil
        }
    }

    @MainActor
    private func setupObservers() {
        // Update menu bar when battery info changes
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                await self.updateMenuBarDisplay()
                await self.updateMenu()
            }
        }
    }

    @MainActor
    private func updateMenuBarDisplay() async {
        guard let button = statusItem?.button else { return }

        // Update icon based on battery level and charging state
        let iconName = BatteryFormatter.batteryIcon(
            level: batteryMonitor.batteryLevel,
            isCharging: batteryMonitor.isCharging
        )

        button.image = NSImage(systemSymbolName: iconName, accessibilityDescription: "Battery")
        button.image?.isTemplate = true

        // Show percentage next to icon
        button.title = " \(batteryMonitor.batteryLevel)%"
    }

    @MainActor
    private func updateMenu() async {
        guard let menu = statusItem?.menu else { return }

        // Update menu items with current values
        if menu.items.count >= 3 {
            menu.items[0].title = "Battery: \(batteryMonitor.batteryLevel)%"

            let statusText = batteryMonitor.isCharging ? "Charging" : "On Battery"
            menu.items[1].title = "Status: \(statusText)"

            menu.items[2].title = "Health: \(batteryMonitor.batteryHealth)%"
        }
    }

    @objc private func showMainWindow() {
        NSApp.activate(ignoringOtherApps: true)

        // Show the main window
        for window in NSApp.windows {
            if window.title.contains("Power ID") || window.title.isEmpty {
                window.makeKeyAndOrderFront(nil)
                return
            }
        }

        // If no window found, create one
        NSApp.windows.first?.makeKeyAndOrderFront(nil)
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    deinit {
        // Clean up status item on main thread
        if let item = statusItem {
            DispatchQueue.main.async {
                NSStatusBar.system.removeStatusItem(item)
            }
        }
    }
}
