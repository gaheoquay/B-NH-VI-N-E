//
//  FileCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit
protocol FileCellDelegate {
    func setupButton()
}

class FileCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
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
        lbName.text = entity.name
        lbPrice.text = String((entity.age))
    }
    
    func isCheck(ischeckDelete: Bool){
//        if ischeckDelete == false {
//            btnDelete.setImage(UIImage(named: "Edit.png"), for: .normal)
//        }else {
//            btnDelete.setImage(UIImage(named: "Delete1.png"), for: .normal)
//        }
    }
    func checkService(isCheckService: Bool){
//        if isCheckService == false {
//            btnDelete.setImage(UIImage(named: "Delete1.png"), for: .normal)
//        }
    }
    func checkListService(isCheckList: Bool){
//        if isCheckList == false {
//            btnDelete.setImage(UIImage(named: "Check0-2.png"), for: .normal)
//            isCheckLists = isCheckList
//        }
    }
    
    
    
}
