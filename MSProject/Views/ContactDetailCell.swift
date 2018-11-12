//
//  ContactDetailCell.swift
//  MSProject
//
//  Created by KanChen on 11/11/18.
//  Copyright © 2018 drchrono. All rights reserved.
//

import UIKit

class ContactDetailCell: UITableViewCell {
    private let nameLabel: UILabel = UILabel(frame: .zero)
    private let titleLabel: UILabel = UILabel(frame: .zero)
    private let introductionLabel: UILabel = UILabel(frame: .zero)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        let aboutMeLabel = UILabel(frame: .zero)
        [nameLabel, titleLabel, aboutMeLabel, introductionLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraint(NSLayoutConstraint(item: contentView,
                                                         attribute: .leadingMargin,
                                                         relatedBy: .equal,
                                                         toItem: $0,
                                                         attribute: .leading,
                                                         multiplier: 1.0,
                                                         constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: contentView,
                                                         attribute: .trailingMargin,
                                                         relatedBy: .equal,
                                                         toItem: $0,
                                                         attribute: .trailing,
                                                         multiplier: 1.0,
                                                         constant: 0))
        }

        contentView.addConstraints(
            NSLayoutConstraint
                .constraints(withVisualFormat: "V:|-[nameLabel(30)]-[titleLabel(20)]-20-[aboutMeLabel(20)]-[introductionLabel]-(>=0)-|",
                             options: [],
                             metrics: nil,
                             views: ["nameLabel": nameLabel,
                                     "titleLabel": titleLabel,
                                     "aboutMeLabel": aboutMeLabel,
                                     "introductionLabel": introductionLabel])
        )

        nameLabel.textAlignment = .center
        aboutMeLabel.text = "About me"
        aboutMeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        titleLabel.textColor = UIColor.gray
        titleLabel.textAlignment = .center

        introductionLabel.numberOfLines = 0
        introductionLabel.textColor = UIColor.lightGray
        introductionLabel.font = UIFont.systemFont(ofSize: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with contact: Contact) {
        let fullName = NSMutableAttributedString(string: "")
        fullName.append(NSAttributedString(string: contact.firstName,
                                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        fullName.append(NSAttributedString(string: " "))
        fullName.append(NSAttributedString(string: contact.lastName,
                                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        nameLabel.attributedText = fullName
        titleLabel.text = contact.title
        introductionLabel.text = contact.introduction
    }

}
