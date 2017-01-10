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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      avaImg.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func setData(entity:ListNotificationEntity){
    if entity.notificaiton.isRead {
      contentView.backgroundColor = UIColor.white
    }else{
      contentView.backgroundColor = UIColor.init(netHex: 0xc7eca1)
    }
    avaImg.sd_setImage(with: URL.init(string: entity.linkedUser.avatarUrl), placeholderImage: #imageLiteral(resourceName: "AvaDefaut.png"))
    let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor().hexStringToUIColor(hex: "4A4A4A")]
    let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor().hexStringToUIColor(hex: "4A4A4A")]
    let fontTitle = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor().hexStringToUIColor(hex: "01a7fa")]
    let myAttrString = NSMutableAttributedString(string: entity.linkedUser.nickname, attributes: fontBold)
    myAttrString.append(NSAttributedString(string: " \(entity.content) ", attributes: fontRegular))
    myAttrString.append(NSAttributedString.init(string: entity.postTitle, attributes: fontTitle))
    titleLbl.attributedText = myAttrString
    timeLbl.text = String().convertTimeStampWithDateFormat(timeStamp: entity.notificaiton.createdDate, dateFormat: "dd/MM/yyyy HH:mm")
    
  }
}
