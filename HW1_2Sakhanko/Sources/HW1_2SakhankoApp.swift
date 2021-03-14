//
//  HW1_2SakhankoApp.swift
//  HW1_2Sakhanko
//
//  Created by Pavel Sakhanko on 8.02.21.
//

import SwiftUI

@main
struct HW1_2SakhankoApp: App {
    var body: some Scene {
        WindowGroup {
            GifsFeedView()
                .onAppear() {
                    AppSettingsService.apiType = "Gifs"
                }
        }
    }
}
