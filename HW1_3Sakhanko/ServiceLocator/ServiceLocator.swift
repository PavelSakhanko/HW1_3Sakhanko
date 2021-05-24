//
//  ServiceLocator.swift
//  HW1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 20.03.21.
//

import Foundation

protocol Locator {
    func resolve<T>() -> T?
}

final class ServiceLocator: Locator {
    private var services: [ObjectIdentifier: Any] = [:]
    
    func register<T>(_ service: T) {
        services[key(for: T.self)] = service
    }
    
    func resolve<T>() -> T? {
        return services[key(for: T.self)] as? T
    }

    private func key<T>(for type: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
}
