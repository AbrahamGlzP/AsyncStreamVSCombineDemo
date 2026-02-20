//
//  BluetoothCombineViewModel.swift
//  AsyncStreamVSCombineDemo
//
//  Created by Abraham Gonzalez Puga on 19/02/26.
//

import SwiftUI
import Combine

@MainActor
class BluetoothCombineViewModel: ObservableObject {
    @Published var connectionState: ConnectionState = .disconnected
    @Published var heartRate: Int?
    @Published var battery: Int?
    @Published var errorMessage: String?
    @Published var eventLog: [String] = []
    @Published var isRunning = false
    
    private let service = BluetoothCombineService()
    private var cancellables = Set<AnyCancellable>()
    
    func start() {
        isRunning = true
        eventLog = []
        
        service.eventsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isRunning = false
            } receiveValue: { [weak self] event in
                self?.handle(event)
            }
            .store(in: &cancellables)
        
        service.start()
    }
    
    func stop() {
        service.stop()
        cancellables.removeAll()
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
