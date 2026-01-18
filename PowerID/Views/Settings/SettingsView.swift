//
//  SettingsView.swift
//  PowerID
//
//  Main settings container with tabs
//

import SwiftUI

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

#Preview {
    SettingsView()
}
