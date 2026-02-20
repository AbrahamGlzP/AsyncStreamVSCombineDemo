//
//  BluetoothStreamViewModel.swift
//  AsyncStreamVSCombineDemo
//
//  Created by Abraham Gonzalez Puga on 20/02/26.
//

import SwiftUI

@MainActor
class BluetoothStreamViewModel: ObservableObject {
    @Published var connectionState: ConnectionState = .disconnected
    @Published var heartRate: Int?
    @Published var battery: Int?
    @Published var errorMessage: String?
    @Published var eventLog: [String] = []
    @Published var isRunning = false
    
    private let service = BluetoothStreamService()
    // Saving the task to ;cancel it
    private var streamTask: Task<Void, Never>?
    
    func start() {
        isRunning = true
        eventLog = []
        
        streamTask = Task {
            let stream = service.start()
            
            for await event in stream {
                handle(event)
            }
            
            isRunning = false
        }
    }
    
    func stop() {
        streamTask?.cancel()
        streamTask = nil
        isRunning = false
    }
    
    private func handle(_ event: BluetoothEvent) {
        switch event {
        case .connectionChanged(let state):
            connectionState = state
            eventLog.insert("🔗 Connection State: \(state)", at: 0)
        case .heartRate(let bpm):
            heartRate = bpm
            eventLog.insert("❤️ Heart rate: \(bpm) bpm", at: 0)
        case .battery(let level):
            battery = level
            eventLog.insert("🔋 Battery level: \(level)%", at: 0)
        case .error(let message):
            errorMessage = message
            eventLog.insert("⚠️ Error: \(message)", at: 0)
        }
    }
}
