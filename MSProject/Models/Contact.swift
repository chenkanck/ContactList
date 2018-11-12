//
//  Contact.swift
//  MSProject
//
//  Created by KanChen on 11/9/18.
//  Copyright © 2018 drchrono. All rights reserved.
//

import Foundation

struct Contact: Decodable {
    let firstName: String
    let lastName: String
    let avatarFileName: String
    let title: String
    let introduction: String

    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case title = "title"
        case introduction = "introduction"
        case avatarFileName = "avatar_filename"
    }
}
