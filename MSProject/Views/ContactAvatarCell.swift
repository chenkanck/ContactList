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
    private lazy var selectedCircle: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 72, height: 72))
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor(red: 199.0/255.0, green: 223.0/255.0, blue: 244.0/255.0, alpha: 1.0).cgColor
        view.layer.borderWidth = 4.0
        view.layer.cornerRadius = 36.0
        view.layer.masksToBounds = true
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constrainToCenterOf(contentView, size: CGSize(width: 72, height: 72))
        return view
    }()

    override var isSelected: Bool {
        didSet {
            selectedCircle.isHidden = !isSelected
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }

    private func setupSubview() {
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.constrainToCenterOf(contentView, size: CGSize(width: 64, height: 64))

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
