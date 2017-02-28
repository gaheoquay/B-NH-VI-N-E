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
    
  func setData(entity: AllUserEntity){
        var profileUser = entity.profile
    
//          cell.listBooking = listallUSer[indexPath.row].booking[indexPath.row]
//    cell.profileUser = listallUSer[indexPath.row].profile

        let creteDate = String().convertTimeStampWithDateFormat(timeStamp: profileUser.createdDate, dateFormat: "dd/MM/YYYY")
        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let fontRegular = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        
        let myAttrString = NSMutableAttributedString(string: "Ngày khám:", attributes: fontRegular)
        myAttrString.append(NSAttributedString(string: "\(creteDate)", attributes: fontBold))
        lbCreateDate.attributedText = myAttrString

        lbName.text = profileUser.patientName
        
//        if listBooking.status == 0 {
//        let myAttrString  = NSMutableAttributedString(string: "Trạng thái:", attributes: fontBold)
//            myAttrString.append(NSMutableAttributedString(string: "đã có mã số khám", attributes: fontRegular))
//            lbStatus.attributedText = myAttrString
//        }else if listBooking.status == 1 {
//            let myAttrString  = NSMutableAttributedString(string: "Trạng thái:", attributes: fontBold)
//            myAttrString.append(NSMutableAttributedString(string: "đang chò xử lý", attributes: fontRegular))
//            lbStatus.attributedText = myAttrString
//        }else if listBooking.status == 2 {
//            let myAttrString  = NSMutableAttributedString(string: "Trạng thái:", attributes: fontBold)
//            myAttrString.append(NSMutableAttributedString(string: "đã thanh toán", attributes: fontRegular))
//            lbStatus.attributedText = myAttrString
//        }
    }
    
}
