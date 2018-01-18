//
//  GiphyClient.swift
//  GiphyClient
//
//  Created by Oli Pfeffer on 1/15/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import Foundation

public final class GiphyClient {

    public let apiKey: String

    public init(apiKey: String = Bundle.main.infoDictionary!["GiphyClientAPIKey"] as! String) {
        self.apiKey = apiKey
    }

    private let session = URLSession(configuration: .default)

    // MARK: Endpoints

    @discardableResult
    public func random(tag: String = "", rating: GiphyRating = .pg13, completionHandler: @escaping (Result<Giphy>) -> Void) -> URLSessionDataTask {

        let url = URL(string: "https://api.giphy.com/v1/gifs/random?tag=\(tag)&rating=\(rating)&api_key=\(apiKey)")!

        return session.jsonTask(with: url, completionHandler: { (result: Result<GiphyMediaResponse<RandomGif>>) in

            let giphy: Result<Giphy> = result.map { $0.data }

            DispatchQueue.main.async {
                completionHandler(giphy)
            }
        })
    }

    @discardableResult
    public func trending(limit: Int = 10, rating: GiphyRating = .pg13, completionHandler: @escaping (Result<[Giphy]>) -> Void) -> URLSessionDataTask {

        let url = URL(string: "https://api.giphy.com/v1/gifs/trending?limit=\(limit)&rating=\(rating)&api_key=\(apiKey)")!

        return session.jsonTask(with: url, completionHandler: { (result: Result<GiphyMediaResponse<[Gif]>>) in

            let giphy: Result<[Giphy]> = result.map { $0.data }

            DispatchQueue.main.async {
                completionHandler(giphy)
            }
        })

    }
}
