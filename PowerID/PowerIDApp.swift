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
                }
                .keyboardShortcut("u", modifiers: .command)
            }

            CommandGroup(replacing: .help) {
                Button("Power ID Help") {
                    openGitHubHelp()
                }
            }
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
