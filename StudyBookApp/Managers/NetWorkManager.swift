//
//  NetWorkManager.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/03.
//

import UIKit
import Combine
import Reachability

class NetworkConnectStatusManager {
    
    private var reachability: Reachability? = nil
    
    public var isReachability: AnyPublisher<Bool, Never> {
        _isReachability.eraseToAnyPublisher()
    }
    
    private var _isReachability = PassthroughSubject<Bool, Never>()
    
    init() {
        reachability = try? Reachability()
        // ネットワーク環境の観測開始
        startObserveNetworkStatus()
    }
    
    public func startObserveNetworkStatus() {
        reachability?.whenReachable = { [weak self] reachability in
            guard let self else { return }
            // 接続した
            self._isReachability.send(self.checkIsOnline())
        }
        reachability?.whenUnreachable = { [weak self] reachability in
            guard let self else { return }
            // 切断された
            self._isReachability.send(self.checkIsOnline())
        }
        try? reachability?.startNotifier()
    }
    
    /// ネットワーク環境が接続済みであるかどうか
    public func checkIsOnline() -> Bool {
        switch reachability?.connection {
        case .wifi, .cellular:
            return true
        case .unavailable, nil:
            return false
        }
    }
    
}
