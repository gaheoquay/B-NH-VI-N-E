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

    @IBOutlet weak var btnDelete: UIButton!
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
            btnDelete.setImage(UIImage(named: "Check0-2.png"), for: .normal)
            isCheckLists = isCheckList
        }
    }
    
    @IBAction func btnEditOrDelete(_ sender: Any) {
        delegate?.setupButton()
        if isCheckListService == true {
            if isCheckLists == false {
                btnDelete.setImage(UIImage(named: "Check1-2.png"), for: .normal)
                isCheckLists = true
            }else {
                btnDelete.setImage(UIImage(named: "Check0-2.png"), for: .normal)
                isCheckLists = false
            }
        }
    }
    
    
}
