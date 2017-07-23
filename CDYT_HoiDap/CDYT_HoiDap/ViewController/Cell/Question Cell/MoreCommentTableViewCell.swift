//
//  MoreCommentTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/30/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit
protocol MoreCommentTableViewCellDelegate {
    func showMoreSubcomment()
}
class MoreCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var delegate : MoreCommentTableViewCellDelegate?
    var commentEntity = MainCommentEntity()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avaImg.layer.cornerRadius = 8
        self.contentView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapMoreAction)))
        
    }

    func setData(){
        avaImg.sd_setImage(with: URL.init(string: commentEntity.subComment[0].author.thumbnailAvatarUrl), placeholderImage: UIImage.init(named: "AvaDefaut.png"))
        let fontName = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor().hexStringToUIColor(hex: "4A4A4A")]
        let fontAnswer = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.lightGray]
        let fontCount = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor().hexStringToUIColor(hex: "61abfa")]
      var myAttrString = NSMutableAttributedString()
      if commentEntity.subComment[0].author.role != 1 {
        myAttrString = NSMutableAttributedString(string: commentEntity.subComment[0].author.fullname, attributes: fontName)
      }else{
        myAttrString = NSMutableAttributedString(string: commentEntity.subComment[0].author.fullname, attributes: fontName)
      }
      
        myAttrString.append(NSAttributedString(string: "\n đã trả lời ", attributes: fontAnswer))
        myAttrString.append(NSAttributedString.init(string: "+\(commentEntity.subComment.count)", attributes: fontCount))
        nameLbl.attributedText = myAttrString
        
    }
    
    func tapMoreAction(){
        commentEntity.isShowMore = true
        delegate?.showMoreSubcomment()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
