//
//  FileCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol FileCellDelegate {
    func gotoDetailFileUser()
    func deleteFileUser(indexPath: IndexPath)
    func gotoDetailHistory(index: IndexPath)
}

class FileCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var viewGotoCreateCV: UIView!
    @IBOutlet weak var marginToplbName: NSLayoutConstraint!
    @IBOutlet weak var heightLbPrice: NSLayoutConstraint!
    
    var delegate : FileCellDelegate?
    var isCheckListService = false
    var isCheckLists = false
    var listUser = FileUserEntity()
    var listBooking = BookingUserEntity()
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(entity: ServiceEntity){
        lbName.text = entity.name
        lbPrice.text = String(entity.priceService)
    }
    
    func setDataHistory(entity: BookingEntity){
        viewGotoCreateCV.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(gotoDetailHistoryUser)))
        lbName.text = String().convertTimeStampWithDateFormat(timeStamp: entity.createDate, dateFormat: "dd/MM/YYYY")
        lbPrice.isHidden = true
        imgDelete.image = UIImage(named: "DetailEditUp.png")
        heightLbPrice.constant = 0
        marginToplbName.constant = 24
    }
    
    func setListUser(){
        lbName.text = listBooking.profile.patientName
        
        let fontWithColor = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.init(netHex: 0x878787)]
        
        let myAttrString = NSMutableAttributedString(string: "\(listBooking.profile.age)", attributes: fontWithColor)
        myAttrString.append(NSAttributedString(string: " tuổi", attributes: fontWithColor))
        lbPrice.attributedText = myAttrString
        
    }
    
    func setSearchListUser(){
        lbName.text = listUser.patientName
        
        let fontWithColor = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.init(netHex: 999999)]
        
        let myAttrString = NSMutableAttributedString(string: "\(listUser.age)", attributes: fontWithColor)
        myAttrString.append(NSAttributedString(string: " tuổi", attributes: fontWithColor))
        lbPrice.attributedText = myAttrString
    }
    
    func isCheck(ischeckDelete: Bool){
        if ischeckDelete == false {
            imgDelete.image = UIImage(named: "DetailEditUp.png")
            viewGotoCreateCV.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(gotoDetailFileUser)))
        }else {
            imgDelete.image = UIImage(named: "Delete1.png")
            viewGotoCreateCV.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(deleteFile)))
        }
    }
    
    func gotoDetailFileUser(){
        delegate?.gotoDetailFileUser()
    }
    
    func deleteFile(){
        delegate?.deleteFileUser(indexPath: indexPath)
        
    }
    
    func gotoDetailHistoryUser(){
        delegate?.gotoDetailHistory(index: indexPath)
    }

}
