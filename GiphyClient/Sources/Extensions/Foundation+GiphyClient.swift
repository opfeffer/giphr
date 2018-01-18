//
//  Foundation+GiphyClient.swift
//  GiphyClient
//
//  Created by Oli Pfeffer on 1/15/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import Foundation

extension URL: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(string: value)!
    }
}

// MARK: -

public extension URLSession {

    func jsonTask<T: Decodable>(with url: URL, decoder: JSONDecoder = .init(), completionHandler: @escaping (Result<T>) -> Void) -> URLSessionDataTask {
        print("Requesting:", url)

        let task = dataTask(with: url, completionHandler: { (data, response, error) in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            if let d = data {
                let json = try? JSONSerialization.jsonObject(with: d, options: .allowFragments)
                print("[\(statusCode)]", json ?? "<null>")
            }

            switch (data, error) {
            case (_, .some(let e)):
                completionHandler(.failure(e))

            case (.some(let d), .none) where 200..<300 ~= statusCode:
                do {
                    let obj = try decoder.decode(T.self, from: d)
                    completionHandler(.success(obj))
                } catch {
                    completionHandler(.failure(error))
                }

            default:
                let error = URLError(.badServerResponse)
                completionHandler(.failure(error))
            }
        })

        task.resume()

        return task
    }
}
