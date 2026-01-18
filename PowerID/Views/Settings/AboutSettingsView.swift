//
//  AboutSettingsView.swift
//  Power ID
//
//  About tab in settings
//

import SwiftUI

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            appIconView
            appInfoView
            appDescriptionView
            Spacer()
            actionButtonsView
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Components

    private var appIconView: some View {
        Image(systemName: "battery.100.bolt")
            .font(.system(size: 60))
            .foregroundStyle(
                LinearGradient(
                    colors: [.blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .symbolRenderingMode(.hierarchical)
    }

    private var appInfoView: some View {
        VStack(spacing: 4) {
            Text("Power ID")
                .font(.title)
                .fontWeight(.bold)

            Text("Version 1.0.0")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var appDescriptionView: some View {
        VStack(spacing: 8) {
            Text("Advanced Battery Monitoring for macOS\n Made with intent")
                .font(.body)
                .multilineTextAlignment(.center)

            Text("© 2026 Power ID. All rights reserved.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var actionButtonsView: some View {
        HStack(spacing: 16) {
            Button("GitHub") {
                openURL("https://github.com/ogden-marrow/PowerID_For_Mac")
            }
            .buttonStyle(.bordered)

            Button("Report Issue") {
                openURL("https://github.com/ogden-marrow/PowerID_For_Mac/issues")
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Helper Methods

    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }
}

#Preview {
    AboutSettingsView()
}
