//
//  BluetoothCombineService.swift
//  AsyncStreamVSCombineDemo
//
//  Created by Abraham Gonzalez Puga on 19/02/26.
//

import Combine

class BluetoothCombineService {
    
    // PassthroughSubject is the equivalent of AsyncStream.Continuation
    // Emits events without saving a history
    let eventsPublisher = PassthroughSubject<BluetoothEvent, Never>()
    
    private let device = FakeBluetoothDevice()
    private var task: Task<Void, Never>?
    
    func start() {
        task = Task {
            await device.start { [weak self] event in
                self?.eventsPublisher.send(event)
            }
            self.eventsPublisher.send(completion: .finished)
        }
    }
    
    func stop() {
        task?.cancel()
        eventsPublisher.send(completion: .finished)
    }
}
