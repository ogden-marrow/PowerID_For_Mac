#!/usr/bin/swift

import AppKit
import Foundation

// Configuration
let outputDir = "/Users/jpalenchar/Documents/MacOSProjects/PowerID/PowerID/Assets.xcassets/AppIcon.appiconset"
let sizes: [(size: CGFloat, scale: CGFloat, name: String)] = [
    (16, 1, "icon_16x16"),
    (16, 2, "icon_16x16@2x"),
    (32, 1, "icon_32x32"),
    (32, 2, "icon_32x32@2x"),
    (128, 1, "icon_128x128"),
    (128, 2, "icon_128x128@2x"),
    (256, 1, "icon_256x256"),
    (256, 2, "icon_256x256@2x"),
    (512, 1, "icon_512x512"),
    (512, 2, "icon_512x512@2x")
]

// Create icon with SF Symbol
func createIcon(size: CGFloat, scale: CGFloat) -> NSBitmapImageRep? {
    let pixelSize = Int(size * scale)

    guard let bitmapRep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: pixelSize,
        pixelsHigh: pixelSize,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        return nil
    }

    let context = NSGraphicsContext(bitmapImageRep: bitmapRep)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context

    // Background gradient (blue to cyan)
    let gradient = NSGradient(colors: [
        NSColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0),  // Blue
        NSColor(red: 0.0, green: 0.749, blue: 1.0, alpha: 1.0)   // Cyan
    ])

    let rect = NSRect(x: 0, y: 0, width: CGFloat(pixelSize), height: CGFloat(pixelSize))
    let cornerRadius = CGFloat(pixelSize) * 0.225
    let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
    gradient?.draw(in: path, angle: 135)

    // Add SF Symbol
    let symbolConfig = NSImage.SymbolConfiguration(pointSize: CGFloat(pixelSize) * 0.6, weight: .semibold)
    if let symbol = NSImage(systemSymbolName: "bolt.fill", accessibilityDescription: nil)?.withSymbolConfiguration(symbolConfig) {

        let symbolSize = symbol.size
        let x = (CGFloat(pixelSize) - symbolSize.width) / 2
        let y = (CGFloat(pixelSize) - symbolSize.height) / 2

        // Draw white symbol
        NSColor.white.set()
        symbol.draw(in: NSRect(x: x, y: y, width: symbolSize.width, height: symbolSize.height),
                   from: .zero,
                   operation: .sourceOver,
                   fraction: 1.0)
    }

    NSGraphicsContext.restoreGraphicsState()

    return bitmapRep
}

// Save icon as PNG
func saveIcon(_ bitmapRep: NSBitmapImageRep, filename: String, size: CGFloat, scale: CGFloat) {
    guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
        print("Failed to create PNG for \(filename)")
        return
    }

    let fileURL = URL(fileURLWithPath: "\(outputDir)/\(filename).png")

    do {
        try pngData.write(to: fileURL)
        let pixelSize = Int(size * scale)
        print("Created: \(filename).png (\(pixelSize)x\(pixelSize) pixels)")
    } catch {
        print("Error writing \(filename): \(error)")
    }
}

// Generate all icon sizes
print("Generating app icons...")
for config in sizes {
    if let icon = createIcon(size: config.size, scale: config.scale) {
        saveIcon(icon, filename: config.name, size: config.size, scale: config.scale)
    }
}

print("Done! Icons generated in \(outputDir)")
