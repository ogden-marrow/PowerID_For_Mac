import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        configureApplication()
        disableFullScreenForAllWindows()
        observeWindowNotifications()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        let showInMenuBar = UserDefaults.standard.bool(forKey: "showInMenuBar")
        return !showInMenuBar
    }

    @objc func windowDidBecomeKey(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            window.collectionBehavior = [.fullScreenNone]
        }
    }

    private func configureApplication() {
        NSApp.setActivationPolicy(.regular)
    }

    private func disableFullScreenForAllWindows() {
        for window in NSApplication.shared.windows {
            window.collectionBehavior = [.fullScreenNone]
        }
    }

    private func observeWindowNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidBecomeKey(_:)),
            name: NSWindow.didBecomeKeyNotification,
            object: nil
        )
    }
}
