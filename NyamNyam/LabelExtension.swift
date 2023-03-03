//
//  LabelExtension.swift
//  NyamNyam
//
//  Created by Anna Kim on 2023/03/01.
//

import UIKit

extension UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
            
            let readMoreText: String = trailingText + moreText
            
            if self.visibleTextLength == 0 { return }
            
            let lengthForVisibleString: Int = self.visibleTextLength
            
            if let myText = self.text {
                
                let mutableString: String = myText
                
                let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: myText.count - lengthForVisibleString), with: "")
                
                let readMoreLength: Int = (readMoreText.count)
                
                guard let safeTrimmedString = trimmedString else { return }
                
                if safeTrimmedString.count <= readMoreLength { return }
                
                print("this number \(safeTrimmedString.count) should never be less\n")
                print("then this number \(readMoreLength)")
                
                // "safeTrimmedString.count - readMoreLength" should never be less then the readMoreLength because it'll be a negative value and will crash
                let trimmedForReadMore: String = (safeTrimmedString as NSString).replacingCharacters(in: NSRange(location: safeTrimmedString.count - readMoreLength, length: readMoreLength), with: "") + trailingText
                
                let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font!])
                let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
                answerAttributed.append(readMoreAttributed)
                self.attributedText = answerAttributed
            }
        }
        
    var visibleTextLength: Int {
        
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        if let myText = self.text {
            
            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: myText, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
            
            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (myText as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: myText.count - index - 1)).location
                    }
                } while index != NSNotFound && index < myText.count && (myText as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
        }
        
        if self.text == nil {
            return 0
        } else {
            return self.text!.count
        }
        
    }
    
//    func showTextOnTTTAttributeLable(str: String, readMoreText: String, readLessText: String, font: UIFont?, charatersBeforeReadMore: Int, activeLinkColor: UIColor, isReadMoreTapped: Bool, isReadLessTapped: Bool) {
//
//            let text = str + readLessText
//            let attributedFullText = NSMutableAttributedString.init(string: text)
//            let rangeLess = NSString(string: text).range(of: readLessText, options: String.CompareOptions.caseInsensitive)
//    //Swift 5
//           // attributedFullText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: rangeLess)
//            attributedFullText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: rangeLess)
//
//            var subStringWithReadMore = ""
//            if text.count > charatersBeforeReadMore {
//              let start = String.Index(encodedOffset: 0)
//              let end = String.Index(encodedOffset: charatersBeforeReadMore)
//              subStringWithReadMore = String(text[start..<end]) + readMoreText
//            }
//
//            let attributedLessText = NSMutableAttributedString.init(string: subStringWithReadMore)
//            let nsRange = NSString(string: subStringWithReadMore).range(of: readMoreText, options: String.CompareOptions.caseInsensitive)
//            //Swift 5
//           // attributedLessText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: nsRange)
//            attributedLessText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: nsRange)
//          //  if let _ = font {// set font to attributes
//          //   self.font = font
//          //  }
//            self.attributedText = attributedLessText
//            self.activeLinkAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
//            //Swift 5
//           // self.linkAttributes = [NSAttributedStringKey.foregroundColor : UIColor.blue]
//            self.linkAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
//            self.addLink(toTransitInformation: ["ReadMore":"1"], with: nsRange)
//
//            if isReadMoreTapped {
//              self.numberOfLines = 0
//              self.attributedText = attributedFullText
//              self.addLink(toTransitInformation: ["ReadLess": "1"], with: rangeLess)
//            }
//            if isReadLessTapped {
//              self.numberOfLines = 3
//              self.attributedText = attributedLessText
//            }
//          }
}
