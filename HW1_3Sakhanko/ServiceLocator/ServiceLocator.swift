//
//  ServiceLocator.swift
//  HW1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 20.03.21.
//

import Foundation

protocol ServiceLocation {
    func resolve<T>() -> T
}

struct ServiceLocator: ServiceLocation {
    private static var services: [ObjectIdentifier: Any] = [:]
    private init() {}

    func resolve<T>() -> T {
        guard let services = ServiceLocator.services[ServiceLocator.key(for: T.self)] as? T else {
            fatalError("No service for type \(T.self)")
        }
        return services
    }
    
    static func registerService<T>(_ service: T) {
        services[key(for: T.self)] = service
    }

    static func key<T>(for type: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
}

@propertyWrapper struct Inject<T> {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        ServiceLocator.registerService(wrappedValue)
    }
}
