//
//  QuestionTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by CDYT on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setData(feedEntity:FeedsEntity){
    lbTitle.text = feedEntity.postEntity.title
    lbContent.text = feedEntity.postEntity.content
    lbLikeCount.text = String(feedEntity.likeCount)
    lbCommentCount.text = String(feedEntity.commentCount)
    let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
    let fontWithColor = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.init(netHex: 0x87baef)]
    var myAttrString = NSMutableAttributedString(string: "Hỏi bởi : ", attributes: fontRegular)
    myAttrString.append(NSAttributedString(string: feedEntity.authorEntity.fullname, attributes: fontWithColor))
    lbAuthor.attributedText = myAttrString
    lbCreateDate.text = String().convertTimeStampWithDateFormat(timeStamp: feedEntity.postEntity.createdDate, dateFormat: "dd/MM/yy HH:mm")
    
  }
  
//  MARK: Outlet
  @IBOutlet weak var lbLikeCount: UILabel!
  @IBOutlet weak var lbCommentCount: UILabel!
  @IBOutlet weak var lbTitle: UILabel!
  @IBOutlet weak var lbContent: UILabel!
  @IBOutlet weak var clvTags: UICollectionView!
  @IBOutlet weak var lbAuthor: UILabel!
  @IBOutlet weak var lbCreateDate: UILabel!
  
}
