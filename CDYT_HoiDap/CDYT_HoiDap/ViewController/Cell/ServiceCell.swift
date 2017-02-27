//
//  ServiceCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 24/02/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit


class ServiceCell: UITableViewCell {
    
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var heightView2: NSLayoutConstraint!
    @IBOutlet weak var btnShowDetail1: UIButton!
    @IBOutlet weak var btnShowDetail2: UIButton!
    
    var isCheckCell = false

    override func awakeFromNib() {
        super.awakeFromNib()
//        if isCheckCell == false {
//            viewBottom.isHidden = false
//        }else {
//            viewBottom.isHidden = true
//        }
//        self.contentView.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnShowDetail1(_ sender: Any) {
    }
        
    @IBAction func btnShowDetail2(_ sender: Any) {
    }
    
    @IBAction func btnShowDetail3(_ sender: Any) {
    }
    
    
}
