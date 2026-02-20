//
//  AsyncStreamView.swift
//  AsyncStreamVSCombineDemo
//
//  Created by Abraham Gonzalez Puga on 20/02/26.
//

import SwiftUI

struct AsyncStreamView: View {
    
    @StateObject private var viewModel = BluetoothStreamViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Current state
            GroupBox("Device state") {
                HStack(spacing: 20) {
                    StatusItem(
                        icon: connectionIcon(viewModel.connectionState),
                        label: connectionLabel(viewModel.connectionState)
                    )
                    if let heartRate = viewModel.heartRate {
                        StatusItem(icon: "❤️", label: "\(heartRate) bpm")
                    }
                    if let battery = viewModel.battery {
                        StatusItem(icon: "🔋", label: "\(battery)%")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
                
                if let errorMessage = viewModel.errorMessage {
                    Text("⚠️ \(errorMessage)")
                        .font(.caption)
                        .foregroundStyle(Color.orange)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal)
            
            Button(viewModel.isRunning ? "Stop" : "Connect device") {
                viewModel.isRunning ? viewModel.stop() : viewModel.start()
            }
            .buttonStyle(.borderedProminent)
            .tint(viewModel.isRunning ? .red : .blue)
            
            //Event log
            GroupBox("Events") {
                if viewModel.eventLog.isEmpty {
                    Text("There's no events yet")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 100)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 6) {
                            ForEach(viewModel.eventLog, id: \.self) { event in
                                Text(event)
                                    .font(.system(.caption, design: .monospaced))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(4)
                    }
                    .frame(maxHeight: 300)
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.top)
    }
    
    private func connectionIcon(_ state: ConnectionState) -> String {
        switch state {
        case .disconnected: return "📵"
        case .connecting: return "🔄"
        case .connected: return "📶"
        }
    }
    
    private func connectionLabel(_ state: ConnectionState) -> String {
        switch state {
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting..."
        case .connected: return "Connected"
        }
    }
}
