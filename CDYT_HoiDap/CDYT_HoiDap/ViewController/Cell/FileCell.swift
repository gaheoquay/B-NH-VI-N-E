//
//  FileCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol FileCellDelegate {
    func gotoDetailFileUser(indexPath: IndexPath)
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
        let fontBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)]
        let fontRegularWithColor = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.init(netHex: 0xa0b3bc)]
        let myAttrString = NSMutableAttributedString(string: "\(String().replaceNSnumber(doublePrice: entity.priceService))", attributes: fontBold)
        myAttrString.append(NSAttributedString(string: " đ", attributes: fontRegularWithColor))
        lbPrice.attributedText = myAttrString

        lbName.text = entity.name
    }
    
    func setDataHistory(entity: BookingEntity){
        viewGotoCreateCV.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(gotoDetailHistoryUser)))
        lbName.text = String().convertTimeStampWithDateFormat(timeStamp: entity.bookingDate / 1000, dateFormat: "dd/MM/YYYY")
        lbPrice.isHidden = true
        imgDelete.image = UIImage(named: "DetailEditUp.png")
        heightLbPrice.constant = 0
        marginToplbName.constant = 24
        
    }
    
    func setDataService(){
        imgDelete.image = UIImage(named: "Delete1.png")
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
        delegate?.gotoDetailFileUser(indexPath: indexPath)
    }
    
    func deleteFile(){
        delegate?.deleteFileUser(indexPath: indexPath)
        
    }
    
    func gotoDetailHistoryUser(){
        delegate?.gotoDetailHistory(index: indexPath)
    }

}
