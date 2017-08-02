//
//  Cell3TableInfomation.swift
//  CDYT_HoiDap
//
//  Created by Quang Anh on 7/28/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class Cell3TableInfomation: UITableViewCell {

    @IBOutlet weak var txtvHealth: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtvHealth.layer.cornerRadius = 2
        txtvHealth.layer.borderWidth = 1
        txtvHealth.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
