//
//  ExamScheduleCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol ExamScheduleCellDelegate {
    func deleteBooking(index: IndexPath)
    func accepBooking(index: IndexPath)
    func gotoDetailUser(index: IndexPath)
}

class ExamScheduleCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCreateDate: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewShowDetail: UIView!
    @IBOutlet weak var heightViewDetail: NSLayoutConstraint!
    @IBOutlet weak var marginBottomViewDetail: NSLayoutConstraint!
    @IBOutlet weak var btnCancelBooking: UIButton!
    @IBOutlet weak var btnAccepBooking: UIButton!
    @IBOutlet weak var centerCanCel: NSLayoutConstraint!
    @IBOutlet weak var centerAccep: NSLayoutConstraint!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    
    var delegate: ExamScheduleCellDelegate?
    var indexPath = IndexPath()
    var userEntity = AllUserEntity()
    
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
    
  func setData(){
    
    let curentDate = Date()
    let stringCurentDate = String().convertDatetoString(date: curentDate, dateFormat: "dd/MM/YYYY")
    let stringBookingDate = String().convertTimeStampWithDateFormat(timeStamp: userEntity.booking.bookingDate / 1000, dateFormat: "dd/MM/YYYY")
    
    if userEntity.booking.status == 2 || userEntity.booking.status == 3 {
        viewShowDetail.isHidden = true
        marginBottomViewDetail.constant = 0
        btnCancel.isHidden = true
    }else if stringCurentDate == stringBookingDate {
        viewShowDetail.isHidden = false
        marginBottomViewDetail.constant = 90
        btnCancel.isHidden = true
    }
    else {
        viewShowDetail.isHidden = true
        marginBottomViewDetail.constant = 0
        btnCancel.isHidden = false
    }
    
   
      lbName.text = userEntity.profile.patientName
    
        let creteDate = String().convertTimeStampWithDateFormat(timeStamp: userEntity.booking.bookingDate/1000, dateFormat: "dd/MM/YYYY")
        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
      let fontRegularWithColor = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.init(netHex: 0xa0b3bc)]

        let myAttrString = NSMutableAttributedString(string: "Ngày khám : ", attributes: fontRegular)
        myAttrString.append(NSAttributedString(string: "\(creteDate)", attributes: fontBold))
        lbCreateDate.attributedText = myAttrString


      
        if userEntity.booking.status == 0 {
        let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontRegular)
            myAttrString.append(NSMutableAttributedString(string: "Chờ xác nhận khám", attributes: fontRegularWithColor))
            btnStatus.setTitle(myAttrString.string, for: .normal)
            
            
        }else if userEntity.booking.status == 1 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontBold)
            myAttrString.append(NSMutableAttributedString(string: "Chờ xử lý", attributes: fontRegularWithColor))
            btnStatus.setTitle(myAttrString.string, for: .normal)
        }else if userEntity.booking.status == 2 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontBold)
            myAttrString.append(NSMutableAttributedString(string: "Đã có số khám", attributes: fontRegularWithColor))
            btnStatus.setTitle(myAttrString.string, for: .normal)
        }
        else if userEntity.booking.status == 3 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontBold)
            myAttrString.append(NSMutableAttributedString(string: "Đã thanh toán", attributes: fontRegularWithColor))
            btnStatus.setTitle(myAttrString.string, for: .normal)
        }
    
        contentView.layoutIfNeeded()
    }
    
    @IBAction func btnCancelExam(_ sender: Any) {
            delegate?.deleteBooking(index: indexPath)
    }
    
    @IBAction func btnAccept(_ sender: Any) {
            delegate?.accepBooking(index: indexPath)
    }
    
    @IBAction func btnCancelBooking(_ sender: Any) {
            delegate?.deleteBooking(index: indexPath)
    }
    
    
  
    @IBAction func btnShowDeitailStatus(_ sender: Any) {
        
    }
    
}
