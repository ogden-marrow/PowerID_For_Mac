//
//  InfoSection.swift
//  PowerID
//
//  Component for displaying informational content with icon and description
//

import SwiftUI

struct InfoSection: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.accentColor)
                    .frame(width: 24)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    InfoSection(
        icon: "battery.100",
        title: "Battery Level",
        description: "The current charge level of your battery as a percentage."
    )
}
