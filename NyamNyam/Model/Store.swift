//
//  Store.swift
//  SQLite
//
//  Created by Anna Kim on 2023/01/30.
//

import Foundation


class Store{
    var id: Int
    var name: String
    var address: String
    var image: Data?
    var contents: String
    var category: String
    
    init(id: Int, name: String, address: String, image: Data? = nil, contents: String, category: String) {
        self.id = id
        self.name = name
        self.address = address
        self.image = image
        self.contents = contents
        self.category = category
    }
}
