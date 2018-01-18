//
//  ErrorView.swift
//  Giphr
//
//  Created by Oli Pfeffer on 1/18/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import UIKit

@objc(ErrorView)
final class ErrorView: UIView {

    @IBOutlet private(set) weak var emojiLabel: UILabel!
    @IBOutlet private(set) weak var textLabel: UILabel!

    deinit {
        print(#function, self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }

    // MARK: Custom methods

    func loadFromNib() {
        let nib = UINib(nibName: "ErrorView", bundle: nil)

        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }
}

