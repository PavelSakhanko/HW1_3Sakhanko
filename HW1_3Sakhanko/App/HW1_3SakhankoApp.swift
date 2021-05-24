//
//  HW1_3_ SakhankoApp.swift
//  HW1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 8.02.21.
//

import SwiftUI

@main
struct HW1_3SakhankoApp: App {

    var serviceLocator: ServiceLocator {
      let serviceLocator = ServiceLocator()
      serviceLocator.register(NetworkService())
      serviceLocator.register(AppSettingsService())

      return serviceLocator
    }

    var body: some Scene {
        WindowGroup {
            GifsFeedView(viewModel: FeedViewModel(locator: serviceLocator))
        }
    }
}
