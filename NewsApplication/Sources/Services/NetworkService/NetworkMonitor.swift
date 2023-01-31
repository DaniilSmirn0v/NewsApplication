//
//  NetworkMonitor.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 31.01.2023.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor
    
    private(set) var isConnected = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied ? true : false
        }
        monitor.start(queue: queue)
    }
}

