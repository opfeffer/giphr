//
//  Player.swift
//  Giphr
//
//  Created by Oli Pfeffer on 1/17/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import UIKit
import AVKit

final class Player {
    private let looper: AVPlayerLooper

    let player: AVQueuePlayer

    init(url: URL) {
        let item = AVPlayerItem(url: url)

        player = AVQueuePlayer()
        player.automaticallyWaitsToMinimizeStalling = false

        looper = AVPlayerLooper(player: player, templateItem: item)
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }
}


class PlayerView: UIView {

    class override var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }

    var player: AVPlayer? {
        get {
            return playerLayer?.player
        }
        set {
            playerLayer?.player = newValue
        }
    }
}
