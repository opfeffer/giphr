//
//  Button.swift
//  Giphr
//
//  Created by Oli Pfeffer on 1/17/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import UIKit

class Button: UIButton {

    override func awakeFromNib() {
        backgroundColor = UIColor.Button.BackgroundColor.default
    }

    override var isHighlighted: Bool {
        didSet {
            let colors = UIColor.Button.BackgroundColor.self
            backgroundColor = isHighlighted ? colors.highlighted : colors.default
        }
    }
}
