//
//  TableViewCell.swift
//  SQLite
//
//  Created by Anna Kim on 2023/02/14.
//

import UIKit

@IBDesignable
class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imageLoca: UIImageView!
    
    @IBOutlet weak var contentViewCell: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        contentViewCell.layer.cornerRadius = 15
        contentViewCell.backgroundColor = .white
        
        self.backgroundColor = .white
    }
 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected{
            contentView.layer.borderWidth=2
            contentView.layer.borderColor = UIColor.red.cgColor
        }else{
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.blue.cgColor
        }
    }
   

    override func layoutSubviews() {

//
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0))
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .opaqueSeparator
        contentView.layer.borderColor = .init(gray: 2.0, alpha: 2.0)
        contentView.layer.borderWidth = 0.1
    }
    
    
    
    


    
}
