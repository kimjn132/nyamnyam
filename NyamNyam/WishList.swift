//
//  WishList.swift
//  MyWish
//
//  Created by 예띤 on 2023/02/07.
//

import Foundation

class WishList{
    var wId: Int
    var wName: String
    var wAddress: String
    var wImage: Data?
    var wTag: String
    
    init(wId: Int, wName: String, wAddress: String, wImage: Data? = nil, wTag: String) {
        self.wId = wId
        self.wName = wName
        self.wAddress = wAddress
        self.wImage = wImage
        self.wTag = wTag
    }
    
}
