//
//  FileCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    var isCheckListService = Bool()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func isCheck(ischeckDelete: Bool){
        if ischeckDelete == false {
            btnDelete.setImage(UIImage(named: "Edit.png"), for: .normal)
        }else {
            btnDelete.setImage(UIImage(named: "Delete1.png"), for: .normal)
        }
    }
    func checkService(isCheckService: Bool){
        if isCheckService == false {
            btnDelete.setImage(UIImage(named: "Delete1.png"), for: .normal)
        }
    }
    func checkListService(isCheckList: Bool){
        if isCheckList == false {
            btnDelete.setImage(UIImage(named: "Check0.png"), for: .normal)
            isCheckListService = isCheckList
        }
    }
    
    @IBAction func btnEditOrDelete(_ sender: Any) {
        if isCheckListService == false {
            btnDelete.setImage(UIImage(named: "Check1-2.png"), for: .normal)
            isCheckListService = true
        }else {
            btnDelete.setImage(UIImage(named: "Check0-2.png"), for: .normal)
            isCheckListService = false
        }
    }
    
    
}
