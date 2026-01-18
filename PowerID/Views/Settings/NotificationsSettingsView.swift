//
//  NotificationsSettingsView.swift
//  PowerID
//
//  Notifications settings tab
//

import SwiftUI

struct NotificationsSettingsView: View {
    @Binding var notifications: Bool

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    Toggle("Enable Notifications", isOn: $notifications)
                        .font(.headline)

                    if notifications {
                        notificationInfoView
                    }
                }
                .padding()
            }
        }
        .formStyle(.grouped)
    }

    // MARK: - Components

    private var notificationInfoView: some View {
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

#Preview {
    NotificationsSettingsView(notifications: .constant(true))
}
