//
//  Result.swift
//  GiphyClient
//
//  Created by Oli Pfeffer on 1/16/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import Foundation

public enum Result<T>{
    case success(T)
    case failure(Error)
}

// MARK: -

public extension Result {

    var value: T? {
        guard case .success(let value) = self else { return nil }
        return value
    }

    func map<U>(transform: (T) throws -> U) -> Result<U> {
        switch self {
        case .success(let value):
            do {
                let t = try transform(value)
                return .success(t)
            } catch {
                return .failure(error)
            }

        case .failure(let error):
            return .failure(error)
        }
    }
}

