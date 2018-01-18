//
//  Color.swift
//  Giphr
//
//  Created by Oli Pfeffer on 1/17/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import UIKit

extension UIColor {

    struct PrimaryButton {
        struct BackgroundColor {
            static let `default`: UIColor = #colorLiteral(red: 0.3294117647, green: 0.1058823529, blue: 0.1450980392, alpha: 1)
            static let highlighted: UIColor = #colorLiteral(red: 0.8745098039, green: 0.7921568627, blue: 0.7294117647, alpha: 1)
        }
    }

    struct SecondaryButton {
        static let borderColor: UIColor = #colorLiteral(red: 0.8745098039, green: 0.7921568627, blue: 0.7294117647, alpha: 1)

        struct BackgroundColor {
            static let highlighted: UIColor = #colorLiteral(red: 0.8745098039, green: 0.7921568627, blue: 0.7294117647, alpha: 1)
        }
    }
}
