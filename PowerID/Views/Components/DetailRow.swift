//
//  DetailRow.swift
//  PowerID
//
//  Row component for displaying label-value pairs
//

import SwiftUI

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

#Preview {
    DetailRow(label: "Battery Level", value: "85%")
}
