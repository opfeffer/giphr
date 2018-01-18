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

class ExploreViewController: UIViewController {

    enum State {
        case loading
        case playback(Giphy)
        case error(Error)
    }

    @IBOutlet private(set) weak var playerView: PlayerView!
    @IBOutlet private(set) weak var playerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var errorView: ErrorView!
    @IBOutlet private(set) weak var nextButton: UIButton!
    @IBOutlet private(set) weak var saveButton: UIButton!

    lazy var giphyClient = GiphyClient()

    lazy var context = AppDelegate.shared.persistentContainer.newBackgroundContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        let navbar = navigationController?.navigationBar
        navbar?.setBackgroundImage(UIImage(), for: .default)
        navbar?.shadowImage = UIImage()

        playerView.clipsToBounds = true
        playerView.layer.masksToBounds = true
        playerView.layer.cornerRadius = 16

        errorView.clipsToBounds = true
        errorView.layer.cornerRadius = 16

        let center = NotificationCenter.default
        center.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: nil) { [weak self] (_) in
            self?.player?.play()
        }

        loadGiphy()
    }

    // MARK: User interactions

    enum SomeError: Error {
        case bad
    }

    @IBAction func refresh(_ sender: Any) {
        loadGiphy()
    }

    @IBAction func save(_ sender: UIButton) {
        guard sender.isSelected == false else { return }
        guard case .playback(let giphy) = state else { return }

        sender.isSelected = true
        sender.setTitle("SAVED", for: .normal)

        _ = ManagedGiphy.newGiphy(in: context, giphy: giphy)
        try? context.save()
    }

    // MARK: Properties

    private var state: State = .loading {
        didSet {
            print(state)

            switch state {
            case .loading:
                player?.pause()
                playerView?.alpha = 0

            case .playback(let giphy):
                saveButton.isSelected = false
                saveButton.setTitle("SAVE", for: .normal)

                let multiplier = playerView.frame.width / giphy.size.width
                playerViewHeightConstraint.constant = giphy.size.height * multiplier
                playerView.setNeedsLayout()
                playerView.layoutIfNeeded()

                playerView.alpha = 1

                player = Player(url: giphy.mp4)
                playerView.player = player?.player

                player?.play()

            case .error(let error):
                errorView.textLabel.text = error.localizedDescription
            }

            let title = state.isError ? "RETRY" : "NEXT"
            nextButton.setTitle(title, for: .normal)

            errorView.isHidden = state.isError == false
        }
    }

    private var player: Player?

    // MARK: Custom methods

    private func loadGiphy() {
        state = .loading

        giphyClient.random(tag: "school") { [weak self] (result) in
            self?.state = State(result)
        }
    }
}

// MARK: -

extension ExploreViewController.State {

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

