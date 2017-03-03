//
//  ExamScheduleCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 26/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol ExamScheduleCellDelegate {
    func showDetailStatus(index: IndexPath)
    func deleteBooking(index: IndexPath)
    func accepBooking()
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
    
    var delegate: ExamScheduleCellDelegate?
    var indexPath = IndexPath()
    var userEntity = AllUserEntity()
    //test
    
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
    
    if userEntity.isCheckSelect == false {
        viewShowDetail.isHidden = true
        marginBottomViewDetail.constant = 0
        print(userEntity.isCheckSelect)
    }else {
        viewShowDetail.isHidden = false
        marginBottomViewDetail.constant = 90
        print(userEntity.isCheckSelect)
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
            let stringCurentDate = String().convertDatetoString(date: curentDate, dateFormat: "dd/MM/YYYY")
            let stringBookingDate = String().convertTimeStampWithDateFormat(timeStamp: userEntity.booking.bookingDate / 1000, dateFormat: "dd/MM/YYYY")
            print(stringBookingDate)
            if stringBookingDate > stringCurentDate || stringBookingDate < stringCurentDate {
                btnAccepBooking.isHidden = true
                centerCanCel.constant = 0
            }else  {
                btnAccepBooking.isHidden = false
                centerCanCel.constant = -50
            }
            btnStatus.isEnabled = true
        }else if userEntity.booking.status == 1 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontBold)
            myAttrString.append(NSMutableAttributedString(string: "Chờ xử lý", attributes: fontRegularWithColor))
            btnStatus.setTitle(myAttrString.string, for: .normal)
            btnStatus.isEnabled = false
           
        }else if userEntity.booking.status == 2 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontBold)
            myAttrString.append(NSMutableAttributedString(string: "Đã có số khám", attributes: fontRegularWithColor))
            btnStatus.setTitle(myAttrString.string, for: .normal)
            btnStatus.isEnabled = false

        }
        else if userEntity.booking.status == 3 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontBold)
            myAttrString.append(NSMutableAttributedString(string: "Đã thanh toán", attributes: fontRegularWithColor))
            btnStatus.setTitle(myAttrString.string, for: .normal)
            btnStatus.isEnabled = false

        }
        else if userEntity.booking.status == 4 {
            let myAttrString  = NSMutableAttributedString(string: "Trạng thái : ", attributes: fontBold)
            myAttrString.append(NSMutableAttributedString(string: "Đã có kết quả khám", attributes: fontRegularWithColor))
            btnStatus.titleLabel?.attributedText = myAttrString
        }
        contentView.layoutIfNeeded()
    }
    
    @IBAction func btnCancelExam(_ sender: Any) {
            delegate?.deleteBooking(index: indexPath)
    }
    
    @IBAction func btnAccept(_ sender: Any) {
            delegate?.accepBooking()
    }
    
  
    @IBAction func btnShowDeitailStatus(_ sender: Any) {
        delegate?.showDetailStatus(index: indexPath)
        
    }
    
}
