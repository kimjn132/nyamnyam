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
    
//    let kCharacterBeforReadMore =  20
//    let kReadMoreText           =  "...더보기"
//    let kReadLessText           =  "...접기"
    

//    @IBOutlet weak var tvContent: UILabel!


    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imageLoca: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var contentViewCell: UIView!
    
    

    
    
    
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
       
        
        
//        let lbl = UILabel()
////        Configure.tvContent.label
////                tvContent.translatesAutoresizingMaskIntoConstraints = false
////                tvContent.numberOfLines = 0
////                tvContent.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
//
//                let contentTextLength = tvContent.text?.count ?? 0
//
//                if contentTextLength > 1 {
//                    DispatchQueue.main.async {
//                        self.tvContent.addTrailing(with: "... ", moreText: "더보기", moreTextFont: .systemFont(ofSize: 13), moreTextColor: UIColor.lightGray)
//                    }
//                }
//
        
           }
    
    
    
//    @IBAction func touchMoreButton1(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//
//        if sender.isSelected {
//            // 펼치기
//            reviewTextViews.textContainer.maximumNumberOfLines = 0
//            reviewTextViews.invalidateIntrinsicContentSize()
//        } else {
//            // 접기
//            reviewTextViews.textContainer.maximumNumberOfLines = 3
//            reviewTextViews.invalidateIntrinsicContentSize()
//
//        }
//
//    }
    
    

    override func prepareForReuse() {
            super.prepareForReuse()
            
            // Reset cell properties
//        ImageView.image = nil
//        lblStore.text = nil
//        lblCategory.text = nil
//        lblAddress.text = nil
//        tvContent.text = nil
        }
    
    

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
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
    
    
    
    

