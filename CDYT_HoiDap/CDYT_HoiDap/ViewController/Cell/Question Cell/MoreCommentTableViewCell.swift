//
//  MoreCommentTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/30/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class MoreCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var countCommentLbl: UILabel!
    
    var commentEntity = MainCommentEntity()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avaImg.layer.cornerRadius = 8
    }

    func setData(){
        let fontName = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor().hexStringToUIColor(hex: "4A4A4A")]
        let fontAnswer = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.lightGray]
        
        let myAttrString = NSMutableAttributedString(string: commentEntity.subComment[0].author.nickname, attributes: fontName)
        myAttrString.append(NSAttributedString(string: "đã trả lời", attributes: fontAnswer))
        nameLbl.attributedText = myAttrString
        
        countCommentLbl.text = "\(commentEntity.subComment.count)"
        
    }
    
    @IBAction func tapMoreAction(_ sender: Any) {
        print("tap more comment")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
