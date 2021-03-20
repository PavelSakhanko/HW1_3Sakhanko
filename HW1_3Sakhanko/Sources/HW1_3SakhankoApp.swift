//
//  HW1_3_ SakhankoApp.swift
//  HW1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 8.02.21.
//

import SwiftUI

@main
struct HW1_3SakhankoApp: App {
    var body: some Scene {
        WindowGroup {
            GifsFeedView()
                .onAppear() {
                    AppSettingsService.apiType = "Gifs"
                }
        }
    }
}
