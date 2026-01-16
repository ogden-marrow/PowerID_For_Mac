import SwiftUI

@main
struct PowerIDApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(replacing: .newItem) { }

            CommandGroup(after: .appInfo) {
                Button("Check for Updates...") {
                    // Future: Check for updates
                }
                .keyboardShortcut("u", modifiers: .command)
            }

            CommandGroup(replacing: .help) {
                Button("PowerID Help") {
                    if let url = URL(string: "https://github.com/yourusername/powerid") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        }

        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set app to be a good Mac citizen
        NSApp.setActivationPolicy(.regular)

        // Disable full screen for all windows
        for window in NSApplication.shared.windows {
            window.collectionBehavior = [.fullScreenNone]
        }

        // Watch for new windows
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidBecomeKey(_:)),
            name: NSWindow.didBecomeKeyNotification,
            object: nil
        )
    }

    @objc func windowDidBecomeKey(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            window.collectionBehavior = [.fullScreenNone]
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @AppStorage("updateInterval") private var updateInterval = 2.0
    @AppStorage("showInMenuBar") private var showInMenuBar = false
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("notifications") private var notifications = true

    var body: some View {
        TabView {
            GeneralSettingsView(
                updateInterval: $updateInterval,
                showInMenuBar: $showInMenuBar,
                launchAtLogin: $launchAtLogin
            )
            .tabItem {
                Label("General", systemImage: "gear")
            }

            NotificationsSettingsView(notifications: $notifications)
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                }

            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 450, height: 350)
    }
}

struct GeneralSettingsView: View {
    @Binding var updateInterval: Double
    @Binding var showInMenuBar: Bool
    @Binding var launchAtLogin: Bool

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Update Interval")
                            .font(.headline)
                        HStack {
                            Slider(value: $updateInterval, in: 1...10, step: 0.5) {
                                Text("Update Interval")
                            }
                            Text("\(updateInterval, specifier: "%.1f")s")
                                .frame(width: 40)
                                .foregroundColor(.secondary)
                        }
                        Text("How often battery information is refreshed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Divider()

                    Toggle("Show in Menu Bar", isOn: $showInMenuBar)
                        .help("Display battery status in the menu bar")

                    Toggle("Launch at Login", isOn: $launchAtLogin)
                        .help("Automatically start PowerID when you log in")
                }
                .padding()
            }
        }
        .formStyle(.grouped)
    }
}

struct NotificationsSettingsView: View {
    @Binding var notifications: Bool

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    Toggle("Enable Notifications", isOn: $notifications)
                        .font(.headline)

                    if notifications {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Get notified about:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            VStack(alignment: .leading, spacing: 8) {
                                Label("Low battery (< 20%)", systemImage: "battery.25")
                                Label("Battery fully charged", systemImage: "battery.100.bolt")
                                Label("Battery health issues", systemImage: "exclamationmark.triangle")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding(.leading, 20)
                    }
                }
                .padding()
            }
        }
        .formStyle(.grouped)
    }
}

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "battery.100.bolt")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .symbolRenderingMode(.hierarchical)

            VStack(spacing: 4) {
                Text("PowerID")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Version 1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 8) {
                Text("Advanced Battery Monitoring for macOS")
                    .font(.body)
                    .multilineTextAlignment(.center)

                Text("© 2026 PowerID. All rights reserved.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 16) {
                Button("GitHub") {
                    if let url = URL(string: "https://github.com/yourusername/powerid") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .buttonStyle(.bordered)

                Button("Report Issue") {
                    if let url = URL(string: "https://github.com/yourusername/powerid/issues") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
