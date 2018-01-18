//
//  Button.swift
//  Giphr
//
//  Created by Oli Pfeffer on 1/17/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.PrimaryButton.BackgroundColor.default
        clipsToBounds = true
        layer.cornerRadius = 8
    }

    override var isHighlighted: Bool {
        didSet {
            let colors = UIColor.PrimaryButton.BackgroundColor.self
            backgroundColor = isHighlighted ? colors.highlighted : colors.default
        }
    }
}

// MARK: -

class SecondaryButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        clipsToBounds = true

        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.SecondaryButton.borderColor.cgColor
    }

    override var isHighlighted: Bool {
        didSet {
            let shouldFill = isHighlighted || isSelected
            backgroundColor = shouldFill ? UIColor.SecondaryButton.BackgroundColor.highlighted : .clear
        }
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.SecondaryButton.BackgroundColor.highlighted : .clear
        }
    }
}
