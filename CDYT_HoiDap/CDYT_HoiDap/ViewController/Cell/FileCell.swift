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
    func deleteFileUser()
}

class FileCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var viewGotoCreateCV: UIView!
    
    var delegate : FileCellDelegate?
    var isCheckListService = false
    var isCheckLists = false
    
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
    
    func setListUser(entity: FileUserEntity){
        lbName.text = entity.patientName
//        lbPrice.text = String((entity.age))
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
        delegate?.deleteFileUser()
        
    }

}
