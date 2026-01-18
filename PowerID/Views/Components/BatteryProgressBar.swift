//
//  BatteryProgressBar.swift
//  PowerID
//
//  Animated progress bar for battery level
//

import SwiftUI

struct BatteryProgressBar: View {
    let level: Int
    let gradient: LinearGradient

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))

                // Foreground
                RoundedRectangle(cornerRadius: 8)
                    .fill(gradient)
                    .frame(width: geometry.size.width * Double(level) / 100.0)
                    .animation(.spring(response: 0.5), value: level)
            }
        }
    }
}

#Preview {
    BatteryProgressBar(
        level: 75,
        gradient: LinearGradient(
            colors: [.blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
    .frame(height: 16)
    .padding()
}
