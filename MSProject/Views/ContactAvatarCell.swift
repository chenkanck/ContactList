//
//  ContactAvatarCell.swift
//  MSProject
//
//  Created by KanChen on 11/11/18.
//  Copyright © 2018 drchrono. All rights reserved.
//

import UIKit

class ContactAvatarCell: UICollectionViewCell {
    private let avatarView: UIImageView = UIImageView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }

    private func setupSubview() {
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: contentView,
                                                     attribute: .centerX,
                                                     relatedBy: .equal,
                                                     toItem: avatarView,
                                                     attribute: .centerX,
                                                     multiplier: 1.0,
                                                     constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: contentView,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: avatarView,
                                                     attribute: .centerY,
                                                     multiplier: 1.0,
                                                     constant: 0))
        avatarView.addConstraint(NSLayoutConstraint(item: avatarView,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: 64))
        avatarView.addConstraint(NSLayoutConstraint(item: avatarView,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1.0,
                                                    constant: 64))
        avatarView.layer.cornerRadius = 32.0
        avatarView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with contact: Contact) {
        if let fileName = contact.avatarFileName.components(separatedBy: ".").first {
            avatarView.image = UIImage(named: fileName)
        } else {
            avatarView.image = nil
        }
    }
}
