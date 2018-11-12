//
//  ContactListViewModel.swift
//  MSProject
//
//  Created by KanChen on 11/9/18.
//  Copyright © 2018 drchrono. All rights reserved.
//

import Foundation

class ContactListViewModel {
    private(set) var contacts: [Contact] = []

    func loadData() throws {
        guard let data = jsonData(from: "contacts") else {
            fatalError("Load file failed")
        }
        contacts = try JSONDecoder().decode([Contact].self, from: data)
    }

    func jsonData(from fileName: String) -> Data? {
        let bundle = Bundle(for: ContactListViewModel.self)
        let path = bundle.path(forResource: fileName, ofType: "json")
        let jsonData = path.flatMap { try? Data(contentsOf: URL(fileURLWithPath: $0), options: .alwaysMapped) }
        return jsonData
    }
}
