//
//  NetworkManager.swift
//  HW_1_2_ Sakhanko
//
//  Created by Pavel Sakhanko on 30.01.21.
//

import Foundation

enum APIError: Error {
    case decodingError
    case httpError(Int)
    case unknown
}

class NetworkManager {
    enum ApiType: String {
        case gifs = "gifs"
        case stickers = "stickers"
        
        var description: String {
            rawValue.prefix(1).uppercased() + rawValue.dropFirst(1)
        }
    }

    enum EndpointType: String {
        case trending = "trending"
        case random = "random"
    }

    func makeRequestFromURL(with product: ApiType, with path: EndpointType) -> String {
        let trendingQueryParams: [String: String] = [
            "api_key": "9DBorJdXekyY2e110C5XsJ7XbSSOwysf",
            "rating": "g"
        ]

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.giphy.com"
        urlComponents.path = "/v1/" + product.rawValue + "/" + path.rawValue
        urlComponents.setQueryItems(with: trendingQueryParams)

        return urlComponents.url!.absoluteString
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
