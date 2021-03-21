//
//  GifDetailView.swift
//  HW1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 11.03.21.
//

import SwiftUI
import CustomUI

struct GifDetailView: View {
    
    @State private var isUrlShowing = false
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
                        .padding()
                    HStack {
                        Spacer()
                        if isUrlShowing {
                            Text(gif.url)
                                .font(.subheadline)
                        }
                        Spacer()
                    }

                    Spacer()
                    
                    Button("\(isUrlShowing ? "Hide" : "Show")" + " URL") {
                        isUrlShowing.toggle()
                    }
                    .buttonStyle(CustomButtonStyle())
                }
            }
        }
    }
}
