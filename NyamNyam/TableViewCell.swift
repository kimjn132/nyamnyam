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
        
      

        
        ImageView.contentMode = .scaleAspectFill
        ImageView.clipsToBounds = true
        
        lblStore.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        if traitCollection.userInterfaceStyle == .dark{
            lblStore.textColor = .white
        }else{
            lblStore.textColor = .black
        }
        
        
        lblDate.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lblDate.textColor = .lightGray
        
        
        
        lblAddress.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lblAddress.textColor = .gray
        
        lblCategory.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        if traitCollection.userInterfaceStyle == .dark{
            lblCategory.textColor = .white
        }else{
            lblCategory.textColor = .black
        }
        
        tvContent.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        if traitCollection.userInterfaceStyle == .dark{
            tvContent.textColor = .white
        }else{
            tvContent.textColor = .black
        }
        
    }
    
    
    
    
}

