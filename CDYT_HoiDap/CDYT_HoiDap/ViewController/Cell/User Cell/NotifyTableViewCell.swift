//
//  NotifyTableViewCell.swift
//  CDYT_HoiDap
//
//  Created by ISORA on 12/28/16.
//  Copyright © 2016 CDYT. All rights reserved.
//

import UIKit

class NotifyTableViewCell: UITableViewCell {
  
  @IBOutlet weak var avaImg: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var timeLbl: UILabel!
  @IBOutlet weak var viewBound: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    avaImg.layer.cornerRadius = 5
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  func setData(entity:NotificationNewEntity){
    if (entity.isRead) {
        viewBound.backgroundColor = UIColor.white
    }else{
        viewBound.backgroundColor = UIColor.init(netHex: 0xc7eca1)
    }
    let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor().hexStringToUIColor(hex: "4A4A4A")]
    let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor().hexStringToUIColor(hex: "4A4A4A")]
    var myAttrString = NSMutableAttributedString()
    
    if entity.displayType == 0 {
        myAttrString = NSMutableAttributedString(string: "\(entity.userDisPlay) ", attributes: fontBold)
        myAttrString.append(NSAttributedString.init(string: entity.conTent, attributes: fontRegular))
    }else {
        myAttrString = NSMutableAttributedString(string: (entity.conTent), attributes: fontBold)
    }
    titleLbl.attributedText = myAttrString
    timeLbl.text = String().convertTimeStampWithDateFormat(timeStamp: (entity.createDate), dateFormat: "dd/MM/yyyy HH:mm")
  }
}
