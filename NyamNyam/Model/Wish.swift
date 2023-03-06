//
//  Wish.swift
//  NyamNyam
//
//  Created by 예띤 on 2023/03/05.
//

import Foundation

class Wish{
    var id: Int
    var name: String
    var address: String
    var image: Data?
    var imagename:String
    var category: String
    var date: String?
    
    init(id:Int, name:String, address:String, image:Data? = nil, imagename:String, category:String, _ date:String? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.image = image
        self.imagename = imagename
        self.category = category
        self.date = date
    }
    
}
