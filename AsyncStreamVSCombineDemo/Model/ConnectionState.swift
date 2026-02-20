//
//  ConnectionState.swift
//  AsyncStreamVSCombineDemo
//
//  Created by Abraham Gonzalez Puga on 19/02/26.
//

import Foundation

enum ConnectionState {
    case disconnected
    case connecting
    case connected
}

enum BluetoothEvent {
    case connectionChanged(ConnectionState)
    case heartRate(Int)
    case battery(Int)
    case error(String)
}
