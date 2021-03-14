//
//  GifDetailView.swift
//  HW1_2Sakhanko
//
//  Created by Pavel Sakhanko on 11.03.21.
//

import SwiftUI

struct GifDetailView: View {
    
    var gif: GifData
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(alignment: .center) {
                    NavigationLink(
                        "Tap Me 🚗 " + gif.title,
                        destination: GifSuperDetailView(gifTitle: gif.title)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    )
                        .font(.headline)
                    HStack {
                        Spacer()
                        Text(gif.url)
                            .font(.subheadline)
                        Spacer()
                    }
                }
            }
        }
    }
}
