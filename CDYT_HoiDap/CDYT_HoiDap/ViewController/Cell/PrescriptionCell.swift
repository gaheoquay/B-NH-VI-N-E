//
//  PrescriptionCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 06/04/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class PrescriptionCell: UITableViewCell {
    
    @IBOutlet weak var lbSTT: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!
    @IBOutlet weak var viewStt: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewQuantity: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewStt.layer.borderColor = UIColor.brown.cgColor
        viewStt.layer.borderWidth = 0.5
        viewName.layer.borderColor = UIColor.brown.cgColor
        viewName.layer.borderWidth = 0.5
        viewContent.layer.borderColor = UIColor.brown.cgColor
        viewContent.layer.borderWidth = 0.5
        viewQuantity.layer.borderColor = UIColor.brown.cgColor
        viewQuantity.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData() {
        lbSTT.text = "1"
        lbName.text = "tiffi"
        lbQuantity.text = "10"
    }
}
