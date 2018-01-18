//
//  Giphy.swift
//  GiphyClient
//
//  Created by Oli Pfeffer on 1/16/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import Foundation

public protocol Giphy {
    var id: String { get }
    var mp4: URL { get }

    var size: CGSize { get }
}
