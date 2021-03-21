//
//  HW1_3_ SakhankoApp.swift
//  HW1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 8.02.21.
//

import SwiftUI

@main
struct HW1_3SakhankoApp: App {

    let dependencyManager = DependencyManager()

    var body: some Scene {
        WindowGroup {
            GifsFeedView()
                .environment(\.dependencyManager, dependencyManager)
                .onAppear() {
                    dependencyManager.appSettingsService.apiType = "Gifs"
                }
        }
    }
}
