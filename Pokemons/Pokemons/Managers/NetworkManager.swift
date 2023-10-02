//
//  NetworkManager.swift
//  Pokemons
//
//  Created by Bahdan Piatrouski on 2.10.23.
//

import Foundation
import Network

enum NetworkState {
    case hasInternet
    case hasNotInternet
}

protocol NetworkManagerDelegate: AnyObject {
    func networkStateDidChange(_ status: NetworkState)
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private lazy var monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    
    var isReachable: Bool {
        return self.status == .satisfied
    }
    
    weak var delegate: NetworkManagerDelegate?
    
    fileprivate init() {
        self.startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard self?.status != path.status else { return }
            
            self?.status = path.status
            self?.delegate?.networkStateDidChange((self?.isReachable ?? false) ? .hasInternet : .hasNotInternet)
        }
        
        let queue = DispatchQueue(label: "Pokemon-Network")
        monitor.start(queue: queue)
    }
    
    deinit {
        self.stopMonitoring()
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
    
    func start() {}
}
