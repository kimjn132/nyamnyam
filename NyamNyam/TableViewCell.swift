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
        
//            // Set up cell appearance
//            self.backgroundColor = .white
//
//            // Set up labels
//            lblStore.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//            lblAddress.font = UIFont.systemFont(ofSize: 14)
//            lblCategory.font = UIFont.systemFont(ofSize: 14)
//            tvContent.font = UIFont.systemFont(ofSize: 14)
//
//            // Set up image view
//            ImageView.contentMode = .scaleAspectFill
//            ImageView.clipsToBounds = true
//
//            // Set up location icon image view
//            imageLoca.contentMode = .scaleAspectFit
//            imageLoca.tintColor = .systemGray

    }
 
    
    

    override func prepareForReuse() {
            super.prepareForReuse()
            
            // Reset cell properties
        ImageView.image = nil
        lblStore.text = nil
        lblCategory.text = nil
        lblAddress.text = nil
        tvContent.text = nil
        }
    
    

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
                contentView.layer.cornerRadius = 10
                contentView.layer.borderWidth = 2
//                contentView.layer.borderColor = UIColor(hexString: "#757575")
                
        ImageView.contentMode = .scaleAspectFill
        ImageView.clipsToBounds = true
        ImageView.layer.cornerRadius = 10
                
        lblStore.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lblStore.textColor = .black
                
        lblAddress.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lblAddress.textColor = .gray
                
        lblCategory.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lblCategory.textColor = .black
            }
}
    
    
    
    


    

