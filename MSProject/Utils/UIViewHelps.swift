//
//  UIViewHelps.swift
//  MSProject
//
//  Created by KanChen on 11/11/18.
//  Copyright © 2018 drchrono. All rights reserved.
//

import UIKit

extension UIView {
    func constrainToCenterOf(_ superview: UIView, size: CGSize) {
        superview.addConstraint(NSLayoutConstraint(item: superview,
                                                     attribute: .centerX,
                                                     relatedBy: .equal,
                                                     toItem: self,
                                                     attribute: .centerX,
                                                     multiplier: 1.0,
                                                     constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: superview,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: self,
                                                     attribute: .centerY,
                                                     multiplier: 1.0,
                                                     constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: size.width))
        self.addConstraint(NSLayoutConstraint(item: self,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: size.height))
    }
}
