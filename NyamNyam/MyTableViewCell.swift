//
//  MyTableViewCell.swift
//  MyWish
//
//  Created by 예띤 on 2023/02/09.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myWishImage: UIImageView!
    @IBOutlet weak var myWishTitle: UILabel!
    @IBOutlet weak var myWishAddress: UILabel!
    @IBOutlet weak var myWishTag: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
