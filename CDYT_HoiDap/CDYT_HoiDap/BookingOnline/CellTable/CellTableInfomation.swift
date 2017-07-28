//
//  CellTableInfomation.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 7/25/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class CellTableInfomation: UITableViewCell {

    
    @IBOutlet weak var btnShowListProfile: UIButton!
    @IBOutlet weak var btnItemName1: UIButton!
    @IBOutlet weak var btnItemName2: UIButton!
    @IBOutlet weak var btnItemName3: UIButton!
    @IBOutlet weak var marginLineBottom: NSLayoutConstraint!
    @IBOutlet weak var btnShowDetailProfile: UIButton!
    
    var setHeightViewProfile : (() -> Void)?
    var isCheck = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setData(arrayProfile: [String]){
        btnItemName1.setTitle(arrayProfile[0], for: .normal)
        btnItemName2.setTitle(arrayProfile[1], for: .normal)
        btnItemName3.setTitle(arrayProfile[2], for: .normal)
        contentView.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnShowListProfile(_ sender: Any) {
        self.setHeightViewProfile?()
    }
    
    
}
