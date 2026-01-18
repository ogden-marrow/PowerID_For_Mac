//
//  GeneralSettingsView.swift
//  PowerID
//
//  General settings tab
//

import SwiftUI

struct GeneralSettingsView: View {
    @Binding var updateInterval: Double
    @Binding var showInMenuBar: Bool
    @Binding var launchAtLogin: Bool

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    updateIntervalSection
                    Divider()
                    menuBarToggle
                    launchAtLoginToggle
                }
                .padding()
            }
        }
        .formStyle(.grouped)
    }

    // MARK: - Components

    private var updateIntervalSection: some View {
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
    }

    private var menuBarToggle: some View {
        Toggle("Show in Menu Bar", isOn: $showInMenuBar)
            .help("Display battery status in the menu bar")
    }

    private var launchAtLoginToggle: some View {
        Toggle("Launch at Login", isOn: $launchAtLogin)
            .help("Automatically start PowerID when you log in")
    }
}

#Preview {
    GeneralSettingsView(
        updateInterval: .constant(2.0),
        showInMenuBar: .constant(false),
        launchAtLogin: .constant(false)
    )
}
