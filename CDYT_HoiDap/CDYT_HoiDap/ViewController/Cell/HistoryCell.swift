//
//  HistoryCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 29/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbCreateDate: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDataHistory(entity: BookingEntity){
        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let fontRegularWithColor = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.init(netHex: 0xa0b3bc)]
        let myAttrStringSv = NSMutableAttributedString(string: "Kiểu dịch vụ: ", attributes: fontRegular)
        if entity.bookType == 2 {
            myAttrStringSv.append(NSMutableAttributedString(string: "Xét nghiệm tại nhà", attributes: fontBold))
            imgAvatar.image = UIImage(named: "XNTaiNha.png")
        }else {
            myAttrStringSv.append(NSMutableAttributedString(string: "Khám tại viện E", attributes: fontBold))
            imgAvatar.image = UIImage(named: "KhamTaiVien.png")
        }
        
        if entity.status == 0 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái: ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Chờ xác nhận ", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }else if entity.status == 1 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái: ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Chờ xử lý", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }else if entity.status == 2 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái: ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Đã có số khám", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }
        else if entity.status == 3 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái: ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Đã thanh toán", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }else {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái: ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Đã có kết quả", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }
        
        lbType.attributedText = myAttrStringSv
        lbCreateDate.text = String().convertTimeStampWithDateFormat(timeStamp: entity.bookingDate / 1000, dateFormat: "dd/MM/YYYY")
    }

}
