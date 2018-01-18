//
//  ViewController.swift
//  Giphr
//
//  Created by Oli Pfeffer on 1/15/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import GiphyClient

class ViewController: UIViewController {

    enum State {
        case loading
        case playback(Giphy)
        case error(Error)
    }

    @IBOutlet private(set) weak var cardView: UIView!
    @IBOutlet private(set) weak var cardViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var errorView: ErrorView!
    @IBOutlet private(set) weak var nextButton: UIButton!

    lazy var giphyClient = GiphyClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        let navbar = navigationController?.navigationBar
        navbar?.setBackgroundImage(UIImage(), for: .default)
        navbar?.shadowImage = UIImage()

        cardView.clipsToBounds = true
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 16

        errorView.clipsToBounds = true
        errorView.layer.cornerRadius = 16

        let center = NotificationCenter.default
        center.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: nil) { [weak self] (_) in
            self?.playerLayer?.player?.play()
        }

        loadGiphy()
    }

    // MARK: User interactions

    @IBAction func refresh(_ sender: Any) {
        loadGiphy()
    }

    // MARK: Properties

    private var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                playerLayer?.opacity = 0

            case .playback(let giphy):
                play(giphy: giphy)

            case .error(let error):
                errorView.textLabel.text = error.localizedDescription
            }

            let title = state.isError ? "RETRY" : "NEXT"
            nextButton.setTitle(title, for: .normal)

            errorView.isHidden = state.isError == false
        }
    }

    private var looper: AVPlayerLooper?

    private var playerLayer: AVPlayerLayer?

    // MARK: Custom methods

    private func loadGiphy() {
        state = .loading

        giphyClient.random() { [weak self] (result) in
            print(result)

            self?.state = State(result)
        }
    }

    private func play(giphy: Giphy) {
        cardView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let multiplier = cardView.frame.width / giphy.size.width
        cardViewHeightConstraint.constant = giphy.size.height * multiplier
        cardView.setNeedsLayout()
        cardView.layoutIfNeeded()

        let player = AVQueuePlayer()
        player.automaticallyWaitsToMinimizeStalling = false

        let layer = AVPlayerLayer(player: player)
        layer.frame = cardView.bounds
        cardView.layer.addSublayer(layer)
        playerLayer = layer

        let item = AVPlayerItem(url: giphy.mp4)
        looper = AVPlayerLooper(player: player, templateItem: item)

        player.play()
    }
}

// MARK: -

extension ViewController.State {

    init(_ result: Result<Giphy>) {
        switch result {
        case .success(let giphy):
            self = .playback(giphy)

        case .failure(let error):
            self = .error(error)
        }
    }

    var isError: Bool {
        if case .error = self {
            return true
        }

        return false
    }
}

// MARK: -

final class ErrorView: UIView {
    @IBOutlet private(set) weak var emojiLabel: UILabel!
    @IBOutlet private(set) weak var textLabel: UILabel!
}
