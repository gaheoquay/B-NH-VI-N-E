//
//  ExamScheduleCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol ExamScheduleCellDelegate {
    func gotoDetailUser(index: IndexPath)
}

class ExamScheduleCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCreateDate: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    
    var delegate: ExamScheduleCellDelegate?
    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewDetails.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showDetailsUsers)))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showDetailsUsers(){
        delegate?.gotoDetailUser(index: indexPath)
    }
    
  func setData(entity:AllUserEntity){
    let profileUser = entity.profile
    let listBooking = entity.booking
    
      lbName.text = profileUser.patientName
    
        let creteDate = String().convertTimeStampWithDateFormat(timeStamp: listBooking.bookingDate/1000, dateFormat: "dd/MM/YYYY")
        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
      let fontRegularWithColor = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.init(netHex: 0xa0b3bc)]

        let myAttrString = NSMutableAttributedString(string: "Ngày khám : ", attributes: fontRegular)
        myAttrString.append(NSAttributedString(string: "\(creteDate)", attributes: fontBold))
        lbCreateDate.attributedText = myAttrString


      
        if listBooking.status == 0 {
        let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Chờ xác nhận khám", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }else if listBooking.status == 1 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Chờ xử lý", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }else if listBooking.status == 2 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Đã có số khám", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }
        else if listBooking.status == 3 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Đã thanh toán", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }
        else if listBooking.status == 4 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Đã có kết quả khám", attributes: fontRegularWithColor))
            lbStatus.attributedText = myAttrString
        }
    }
    
}
