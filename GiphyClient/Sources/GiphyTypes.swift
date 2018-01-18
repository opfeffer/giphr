//
//  GiphyTypes.swift
//  GiphyClient
//
//  Created by Oli Pfeffer on 1/15/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import Foundation

public enum GiphyRating: String, Codable {
    case y
    case g
    case pg
    case pg13
    case r
    case nsfw
    case unrated

    enum CodingKeys: String, CodingKey {
        case y, g, pg, r, nsfw, unrated
        case pg13 = "pg-13"
    }
}

internal struct Gif: Decodable {
    let id: String
    let webURL: URL
    let rating: GiphyRating
    let images: Images

    enum CodingKeys: String, CodingKey {
        case id
        case webURL = "url"
        case images
        case rating
    }

    struct Images: Decodable {
        let original: Rendition
    }

    struct Rendition: Decodable {
        let mp4: URL
        let height: String
        let width: String
    }
}

extension Gif: Giphy {
    var mp4: URL {
        return images.original.mp4
    }

    var size: CGSize {
        guard let h = Int(images.original.height), let w = Int(images.original.width) else { return .zero }
        return CGSize(width: w, height: h)
    }
}

// MARK: -

internal struct RandomGif: Decodable {
    let id: String
    let webURL: URL
    let mp4: URL

    let width: String
    let height: String

    enum CodingKeys: String, CodingKey {
        case id
        case webURL = "url"
        case mp4 = "image_mp4_url"

        case width = "image_width"
        case height = "image_height"
    }
}

extension RandomGif: Giphy {
    
    var size: CGSize {
        guard let w = Int(width), let h = Int(height) else { return .zero }
        return CGSize(width: w, height: h)
    }
}

// MARK: -

internal struct GiphyResponseMeta: Decodable {
    let status: Int
    let msg: String
}

internal struct GiphyMediaResponse<T: Decodable>: Decodable {
    let data: T
    let meta: GiphyResponseMeta
}
