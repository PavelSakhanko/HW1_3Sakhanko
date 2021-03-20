//
//  GifsFeedView.swift
//  HW_1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 30.01.21.
//

import SwiftUI

struct GifsFeedView: View {

    @ObservedObject var feedService = FeedService()
    @State private var selectedSegment = 0

    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .red
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.red], for: .normal)
    }

    var body: some View {
        
        let gifs = NetworkService.ApiType.gifs.description
        let stickers = NetworkService.ApiType.stickers.description
        
        NavigationView {
            VStack {
                List(feedService.gifsFeedItems) { (gif: GifData) in
                    NavigationLink(destination: GifDetailView(gif: gif)) {
                        GifRowView(gif: gif)
                            .frame(height: 120)
                            .onAppear {
                                feedService.loadGifs(currentItem: gif)
                            }
                    }
                }
                Picker(selection: $selectedSegment, label: Text("")) {
                    Text((gifs)).tag(0)
                    Text((stickers)).tag(1)
                }
                .onChange(of: selectedSegment) {
                    AppSettingsService.apiType = $0 == 0 ? gifs : stickers
                    feedService.loadGifs(currentItem: nil)
                }
                .frame(width: UIScreen.main.bounds.size.width / 2, height: 80, alignment: .center)
                .pickerStyle(SegmentedPickerStyle())
                .scaleEffect(CGSize(width: 1.5, height: 1.5))
            }
            .navigationBarTitle(Text("\(selectedSegment == 0 ? gifs : stickers)"))
        }
    }
}
