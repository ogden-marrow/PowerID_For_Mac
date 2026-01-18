import SwiftUI

@main
struct PowerIDApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var batteryMonitor = BatteryMonitor()
    @StateObject private var menuBarManager: MenuBarManager
    @AppStorage("showInMenuBar") private var showInMenuBar = true

    init() {
        let monitor = BatteryMonitor()
        _batteryMonitor = StateObject(wrappedValue: monitor)
        _menuBarManager = StateObject(wrappedValue: MenuBarManager(
            batteryMonitor: monitor,
            isEnabled: UserDefaults.standard.bool(forKey: "showInMenuBar")
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(batteryMonitor)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(replacing: .newItem) { }

            CommandGroup(after: .appInfo) {
                Button("Check for Updates...") {
                }
                .keyboardShortcut("u", modifiers: .command)
            }

            CommandGroup(replacing: .help) {
                Button("Power ID Help") {
                    openGitHubHelp()
                }
            }
        }
        .onChange(of: showInMenuBar) { _, newValue in
            menuBarManager.isEnabled = newValue
        }

        Settings {
            SettingsView()
        }
    }

    private func openGitHubHelp() {
        if let url = URL(string: "https://github.com/ogden-marrow/PowerID_For_Mac") {
            NSWorkspace.shared.open(url)
        }
    }
}
