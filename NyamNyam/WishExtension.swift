//
//  wishExtension.swift
//  NyamNyam
//
//  Created by 예띤 on 2023/03/05.
//

import UIKit

extension WishTableViewController: WishModelProtocol{
    func itemdownloaded(items:[Wish]){
        wishList = items
        self.tvListView.reloadData()
    }
}

extension WishAddViewController: WishModelProtocol{
    func itemdownloaded(items: [Wish]) {
        
    }
}
