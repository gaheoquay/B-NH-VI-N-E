//
//  Cell2Infomation.swift
//  CDYT_HoiDap
//
//  Created by Quang Anh on 7/28/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class Cell2Infomation: UITableViewCell {

    @IBOutlet weak var txtInfomation: UITextField!
    @IBOutlet weak var btnSelect: UIButton!
    var gotoSelectService : ((_ identifier: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(plachoder: String, isDate: Bool){
        self.txtInfomation.placeholder = plachoder
        if isDate {
            btnSelect.isHidden = false
        }else {
            btnSelect.isHidden = true
        }
    }

    @IBAction func btnSelect(_ sender: Any) {
        self.gotoSelectService!("ServiceNewViewController")
    }
}
