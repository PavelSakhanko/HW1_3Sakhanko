//
//  GifsFeedModel.swift
//  HW_1_2_ Sakhanko
//
//  Created by Pavel Sakhanko on 30.01.21.
//

import Foundation

class GifsFeed: ObservableObject, RandomAccessCollection {
    
    enum LoadStatus {
        case ready (nextPage: Int)
        case loading (page: Int)
        case parseError
        case done
    }
    
    @Published var gifsFeedItems = [GifData]()
    
    typealias Element = GifData
    
    var startIndex: Int { gifsFeedItems.startIndex }
    var endIndex: Int { gifsFeedItems.endIndex }
    var loadStatus = LoadStatus.ready(nextPage: 1)
    
    subscript(position: Int) -> GifData {
        return gifsFeedItems[position]
    }

    init() {
        loadGifs()
    }
        
    func loadGifs(currentItem: GifData? = nil) {
        if !shouldLoadMoreData(currentItem: currentItem) { return }
        guard case let .ready(page) = loadStatus else { return }
        loadStatus = .loading(page: page)
        if !shouldLoadMoreData(currentItem: currentItem) { return }
        let apiType: NetworkManager.ApiType = AppSettingsService.apiType.contains("Gifs") ? .gifs : .stickers
        let urlString = NetworkManager().makeRequestFromURL(with: apiType, with: .trending) + "&limit=\(page)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseGifsFromResponse(data:response:error:))
        task.resume()
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

    private func parseGifsFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            loadStatus = .parseError
            return
        }
        guard let data = data else {
            loadStatus = .parseError
            return
        }
    
        let newGifs = parseGifsFromData(data: data)
        DispatchQueue.main.async {
            self.gifsFeedItems = []
            self.gifsFeedItems.append(contentsOf: newGifs)
            if self.gifsFeedItems.isEmpty {
                self.loadStatus = .done
            } else {
                guard case let .loading(page) = self.loadStatus else {
                    fatalError("loadSatus is in a bad state")
                }
                self.loadStatus = .ready(nextPage: page + 1)
            }
        }
    }
    
    private func parseGifsFromData(data: Data) -> [GifData] {
        var response: GifsApiResponse?
        do {
            response = try JSONDecoder().decode(GifsApiResponse.self, from: data)
        } catch {
            print(APIError.decodingError)
            return []
        }

        return response?.data ?? []
    }
}

class GifsApiResponse: Codable {
    var data: [GifData]?
}

class GifData: Identifiable, Codable {

    let type: TypeEnum
    let id: String
    let url: String
    let slug: String
    let bitlyGIFURL, bitlyURL: String
    let embedURL: String
    let username: String
    let source: String
    let title: String
    let rating: Rating
    let contentURL: String
    let sourceTLD: String
    let sourcePostURL: String
    let isSticker: Int
    let importDatetime, trendingDatetime: String
    let images: Images
    let user: User?
    let analyticsResponsePayload: String
    let analytics: Analytics

    enum CodingKeys: String, CodingKey {
        case type, id, url, slug
        case bitlyGIFURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username, source, title, rating
        case contentURL = "content_url"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case images, user
        case analyticsResponsePayload = "analytics_response_payload"
        case analytics
    }
}

// MARK: - Analytics
struct Analytics: Codable {
    let onload, onclick, onsent: Onclick
}

// MARK: - Onclick
struct Onclick: Codable {
    let url: String
}

// MARK: - Images
struct Images: Codable {
    let original: FixedHeight
    let downsized, downsizedLarge, downsizedMedium: The480_WStill
    let downsizedSmall: The4_K
    let downsizedStill: The480_WStill
    let fixedHeight, fixedHeightDownsampled, fixedHeightSmall: FixedHeight
    let fixedHeightSmallStill, fixedHeightStill: The480_WStill
    let fixedWidth, fixedWidthDownsampled, fixedWidthSmall: FixedHeight
    let fixedWidthSmallStill, fixedWidthStill: The480_WStill
    let looping: Looping
    let originalStill: The480_WStill
    let originalMp4, preview: The4_K
    let previewGIF, previewWebp, the480WStill: The480_WStill
    let hd, the4K: The4_K?

    enum CodingKeys: String, CodingKey {
        case original, downsized
        case downsizedLarge = "downsized_large"
        case downsizedMedium = "downsized_medium"
        case downsizedSmall = "downsized_small"
        case downsizedStill = "downsized_still"
        case fixedHeight = "fixed_height"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case fixedHeightSmall = "fixed_height_small"
        case fixedHeightSmallStill = "fixed_height_small_still"
        case fixedHeightStill = "fixed_height_still"
        case fixedWidth = "fixed_width"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case fixedWidthSmall = "fixed_width_small"
        case fixedWidthSmallStill = "fixed_width_small_still"
        case fixedWidthStill = "fixed_width_still"
        case looping
        case originalStill = "original_still"
        case originalMp4 = "original_mp4"
        case preview
        case previewGIF = "preview_gif"
        case previewWebp = "preview_webp"
        case the480WStill = "480w_still"
        case hd
        case the4K = "4k"
    }
}

// MARK: - The480_WStill
struct The480_WStill: Codable {
    let height, width, size: String
    let url: String
}

// MARK: - The4_K
struct The4_K: Codable {
    let height, width, mp4Size: String
    let mp4: String

    enum CodingKeys: String, CodingKey {
        case height, width
        case mp4Size = "mp4_size"
        case mp4
    }
}

// MARK: - FixedHeight
struct FixedHeight: Codable {
    let height, width, size: String
    let url: String
    let mp4Size: String?
    let mp4: String?
    let webpSize: String
    let webp: String
    let frames, hash: String?

    enum CodingKeys: String, CodingKey {
        case height, width, size, url
        case mp4Size = "mp4_size"
        case mp4
        case webpSize = "webp_size"
        case webp, frames, hash
    }
}

// MARK: - Looping
struct Looping: Codable {
    let mp4Size: String
    let mp4: String

    enum CodingKeys: String, CodingKey {
        case mp4Size = "mp4_size"
        case mp4
    }
}

enum Rating: String, Codable {
    case g = "g"
}

enum TypeEnum: String, Codable {
    case gif = "gif"
}

// MARK: - User
struct User: Codable {
    let avatarURL, bannerImage, bannerURL: String
    let profileURL: String
    let username, displayName, userDescription: String
    let instagramURL: String
    let websiteURL: String
    let isVerified: Bool

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case bannerImage = "banner_image"
        case bannerURL = "banner_url"
        case profileURL = "profile_url"
        case username
        case displayName = "display_name"
        case userDescription = "description"
        case instagramURL = "instagram_url"
        case websiteURL = "website_url"
        case isVerified = "is_verified"
    }
}
