//
//  BluetoothStreamService.swift
//  AsyncStreamVSCombineDemo
//
//  Created by Abraham Gonzalez Puga on 20/02/26.
//

import Foundation

class BluetoothStreamService {
    
    private let device = FakeBluetoothDevice()
    
    func start() -> AsyncStream<BluetoothEvent> {
        AsyncStream { continuation in
            let task = Task {
                await device.start { event in
                    continuation.yield(event)
                }
                continuation.finish()
            }
            
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
