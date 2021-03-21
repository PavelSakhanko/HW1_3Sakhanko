//
//  FeedService.swift
//  HW1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 20.03.21.
//

import Foundation

class FeedService: ObservableObject, RandomAccessCollection {
    
    @Inject var networkService: NetworkService
    @Published var gifsFeedItems = [GifData]()

    typealias Element = GifData

    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        loadGifs()
    }

    enum LoadStatus {
        case ready (nextPage: Int)
        case loading (page: Int)
        case parseError
        case done
    }

    var loadStatus = LoadStatus.ready(nextPage: 1)

    var startIndex: Int { gifsFeedItems.startIndex }
    var endIndex: Int { gifsFeedItems.endIndex }
    
    subscript(position: Int) -> GifData {
        return gifsFeedItems[position]
    }

    func loadGifs(currentItem: GifData? = nil) {
        if !shouldLoadMoreData(currentItem: currentItem) { return }
        guard case let .ready(page) = loadStatus else { return }
        loadStatus = .loading(page: page)
        if !shouldLoadMoreData(currentItem: currentItem) { return }
        networkService.startDataTask(
            page: page,
            completionHandler: parseGifsFromResponse(data:response:error:)
        )
    }

    private func parseGifsFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            loadStatus = .parseError
            return
        }
        guard let data = data else {
            loadStatus = .parseError
            return
        }

        let newGifs = networkService.parseGifsFromData(data: data)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.gifsFeedItems = []
            self.gifsFeedItems.append(contentsOf: newGifs)

            if self.gifsFeedItems.isEmpty {
                self.loadStatus = .done
            } else {
                guard case let .loading(page) = self.loadStatus else {
                    fatalError("load status is in a bad state")
                }
                self.loadStatus = .ready(nextPage: page + 1)
            }
        }
    }

    private func shouldLoadMoreData(currentItem: GifData? = nil) -> Bool {
        guard let currentItem = currentItem else {
            return true
        }

        for n in (gifsFeedItems.count - 2)...(gifsFeedItems.count - 1) {
            if n >= 0 && currentItem.id == gifsFeedItems[n].id {
                return true
            }
        }
        return false
    }
}
