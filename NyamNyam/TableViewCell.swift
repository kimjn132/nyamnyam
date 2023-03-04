//
//  TableViewCell.swift
//  SQLite
//
//  Created by Anna Kim on 2023/02/14.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imageLoca: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var contentViewCell: UIView!
    
    
    
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
    }
    
    
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        //                contentView.layer.cornerRadius = 10
        //                contentView.layer.borderWidth = 2
        //                contentView.layer.borderColor = UIColor(hexString: "#757575")
        
        ImageView.contentMode = .scaleAspectFill
        ImageView.clipsToBounds = true
        //        ImageView.layer.cornerRadius = 10
        //        ImageView.layer.borderWidth = 2
        
        lblStore.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lblStore.textColor = .black
        
        lblDate.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lblDate.textColor = .lightGray
        
        
        
        lblAddress.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lblAddress.textColor = .gray
        
        lblCategory.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lblCategory.textColor = .black
        
        tvContent.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tvContent.textColor = .black
        
        
    }
    
    
    
    
}

