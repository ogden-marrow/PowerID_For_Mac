//
//  TipRow.swift
//  PowerID
//
//  Component for displaying battery care tips
//

import SwiftUI

struct TipRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.secondary)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    TipRow(text: "Keep your battery between 20-80% for optimal longevity")
}
