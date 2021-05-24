//
//  GifsFeedModel.swift
//  HW_1_3_ Sakhanko
//
//  Created by Pavel Sakhanko on 30.01.21.
//

import Foundation

class GifsApiResponse: Codable {
    var data: [GifData]?
}

class GifData: Identifiable, Codable {
    let type: TypeEnum
    let id: String
    let url: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case type, id, url
        case title
    }
}

enum TypeEnum: String, Codable {
    case gif = "gif"
    case sticker = "sticker"
    case text = "text"
}
