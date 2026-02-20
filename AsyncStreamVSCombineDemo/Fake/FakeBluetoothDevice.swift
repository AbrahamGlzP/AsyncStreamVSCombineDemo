//
//  FakeBluetoothDevice.swift
//  AsyncStreamVSCombineDemo
//
//  Created by Abraham Gonzalez Puga on 19/02/26.
//

import Foundation

class FakeBluetoothDevice {
    
    //Simulates a bluetooth device full cycle
    func start(onEvent: @escaping(BluetoothEvent) -> Void) async {
        
        // 1.- Connecting
        onEvent(.connectionChanged(.connecting))
        try? await Task.sleep(for: .seconds(2))
        
        // 2.- Connected
        onEvent(.connectionChanged(.connected))
        try? await Task.sleep(for: .seconds(1))
        
        // 3.- Simultaneous reads for Heart rate and battery
        await withTaskGroup(of: Void.self) { group in
            
            
            //Hear rate every 1.5sec by 5 reads
            group.addTask {
                for _ in 1...5 {
                    try? await Task.sleep(for: .seconds(1.5))
                    onEvent(.heartRate(Int.random(in: 60...100)))
                }
            }
            
            // Battery every 2s by 3 reads
            group.addTask {
                var battery = 85
                for _ in 1...3 {
                    try? await Task.sleep(for: .seconds(2))
                    battery -= Int.random(in: 1...5)
                    onEvent(.battery(battery))
                }
            }
        }
        
        // 4.- Signal error
        try? await Task.sleep(for: .seconds(1))
        onEvent(.error("Weak signal detected"))
        
        // 5.- Disconection
        try? await Task.sleep(for: .seconds(1))
        onEvent(.connectionChanged(.disconnected))
    }
}
