//
//  ArchiveViewController.swift
//  Giphr
//
//  Created by Oli Pfeffer on 1/17/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import UIKit
import CoreData
import GiphyClient

class ArchiveViewController: UIViewController {

    @IBOutlet private(set) weak var errorView: ErrorView! {
        didSet {
            errorView?.clipsToBounds = true
            errorView?.layer.cornerRadius = 8

            errorView?.emojiLabel.text = "😱"
            errorView?.textLabel.text = "No giphies saved yet"
        }
    }

    @IBOutlet private(set) weak var tableView: UITableView! {
        didSet {
            tableView?.estimatedRowHeight = 80
            tableView?.rowHeight = UITableViewAutomaticDimension
            tableView?.tableFooterView = UIView()
        }
    }

    private lazy var context = AppDelegate.shared.persistentContainer.viewContext

    private var giphies: [ManagedGiphy] = [] {
        didSet {
            errorView.isHidden = giphies.isEmpty == false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let result: [ManagedGiphy] = try? context.fetch(ManagedGiphy.fetchRequest) {
            giphies = result
        }
    }

    // MARK: User Interactions

    @IBAction func deleteButtonTapped(_ sender: Any) {
        let ctx = AppDelegate.shared.persistentContainer.newBackgroundContext()

        do {
            let request = NSBatchDeleteRequest(fetchRequest: ManagedGiphy.fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            try ctx.execute(request)

            self.giphies = []
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
}

// MARK: -

extension ArchiveViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giphies.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! GiphyCardTableViewCell
        let giphy = giphies[indexPath.row]

        cell.player = Player(url: giphy.mp4)
        cell.player?.play()
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! GiphyCardTableViewCell
        cell.player?.pause()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GiphyCardTableViewCell.reuseIdentifier, for: indexPath) as! GiphyCardTableViewCell
        let giphy = giphies[indexPath.row]

        cell.videoRect = CGSize(width: CGFloat(giphy.width), height: CGFloat(giphy.height))

        return cell
    }
}

// MARK: - Types

final class GiphyCardTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: GiphyCardTableViewCell.self)

    @IBOutlet private(set) weak var playerView: PlayerView! {
        didSet {
            playerView?.clipsToBounds = true
            playerView?.layer.masksToBounds = true
            playerView?.layer.cornerRadius = 16
        }
    }

    private var aspectRatioConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            aspectRatioConstraint?.isActive = true
        }
    }

    var videoRect: CGSize = .zero {
        didSet {
            let constraint = NSLayoutConstraint(item: playerView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: playerView,
                                                       attribute: .width,
                                                       multiplier: videoRect.height / videoRect.width,
                                                       constant: 0)
            constraint.priority = .defaultHigh
            aspectRatioConstraint = constraint

            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    var player: Player? {
        didSet {
            playerView.player = player?.player
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        player?.pause()
        player = nil

        aspectRatioConstraint?.isActive = false
    }
}
