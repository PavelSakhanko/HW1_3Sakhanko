//
//  NetworkService.swift
//  HW_1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 30.01.21.
//

import Foundation

class NetworkService {

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

    func startDataTask(
        page: Int,
        completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
    {
        let apiType: NetworkService.ApiType = AppSettingsService().apiType.contains("Gifs") ? .gifs : .stickers
        let urlString = makeRequestFromURL(with: apiType, with: .trending) + "&limit=\(page)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }

    func parseGifsFromData(data: Data) -> [GifData] {
        var response: GifsApiResponse?
        do {
            response = try JSONDecoder().decode(GifsApiResponse.self, from: data)
        } catch {
            return []
        }

        return response?.data ?? []
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
