//
//  ContentView.swift
//  PowerID
//
//  Main content view with tab navigation
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var batteryMonitor: BatteryMonitor
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            OverviewView(batteryMonitor: batteryMonitor)
                .tabItem {
                    Label("Overview", systemImage: "gauge.with.dots.needle.67percent")
                }
                .tag(0)

            DetailsView(batteryMonitor: batteryMonitor)
                .tabItem {
                    Label("Details", systemImage: "list.bullet.rectangle")
                }
                .tag(1)

            InfoView(batteryMonitor: batteryMonitor)
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
                .tag(2)
        }
        .frame(minWidth: 600, minHeight: 500)
    }
}

#Preview {
    ContentView()
}
