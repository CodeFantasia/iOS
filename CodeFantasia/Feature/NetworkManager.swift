//
//  NetworkManager.swift
//  CodeFantasia
//
//  Created by hong on 2023/10/26.
//

import Network
import UIKit
import RxSwift

protocol NetworkManagerProtocol {
    func startMonitoring()
    func stopMonitoring()
    var connectionStatus: NWPath.Status { get set }
    var connectionType: NetworkManager.ConnectionType { get set }
}

final class NetworkManager: NetworkManagerProtocol {
    static let instance = NetworkManager()
    private let nwPathMonitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    var connectionStatus: NWPath.Status
    var connectionType: ConnectionType
    
    enum ConnectionType {
        case wifi
        case cellular
        case wiredEthernet
        case loopBack
        case other
        case unknown
    }
    
    enum NetworkManagerError: LocalizedError {
        case networkNotConnected
    }
    
    private init() {
        connectionStatus = .unsatisfied
        connectionType = .unknown
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }

    func startMonitoring() {
        nwPathMonitor.start(queue: queue)
        nwPathMonitor.pathUpdateHandler = { [weak self] path in
            self?.connectionStatus = path.status
            self?.updateConnectionType(path)
            
            if path.status != .satisfied {
                self?.alertNetworkNotConnected()
            }
        }
    }
    
    func stopMonitoring() {
        nwPathMonitor.cancel()
    }
    
    private func alertNetworkNotConnected() {
        DispatchQueue.main.async {
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let firstWindow = firstScene.windows.first else { return }
            guard let rootViewController = firstWindow.rootViewController else { return }
            rootViewController.alertViewAlert(title: "네트워크 연결 실패", message: "네트워크에 연결되어 있지 않습니다.", cancelText: nil)
        }
    }
    
    private func updateConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .wiredEthernet
        } else if path.usesInterfaceType(.loopback) {
            connectionType = .loopBack
        } else if path.usesInterfaceType(.other) {
            connectionType = .other
        } else {
            connectionType = .unknown
        }
    }
}
