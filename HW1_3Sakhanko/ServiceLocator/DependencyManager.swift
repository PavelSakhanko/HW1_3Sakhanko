//
//  DependencyManager.swift
//  HW1_3Sakhanko
//
//  Created by Pavel Sakhanko on 20.03.21.
//

import SwiftUI

struct DependencyManager {
    @Inject var feedService = FeedService()
    @Inject var networkService = NetworkService()
    @Inject var appSettingsService = AppSettingsService()
}

struct DependencyManagerKey: EnvironmentKey {
    static var defaultValue = DependencyManager(
        feedService: FeedService(),
        networkService: NetworkService(),
        appSettingsService: AppSettingsService()
    )
    typealias Value = DependencyManager
}

extension EnvironmentValues {
    var dependencyManager: DependencyManager {
        get {
            self[DependencyManagerKey.self]
        }
        set {
            self[DependencyManagerKey.self] = newValue
        }
    }
}
