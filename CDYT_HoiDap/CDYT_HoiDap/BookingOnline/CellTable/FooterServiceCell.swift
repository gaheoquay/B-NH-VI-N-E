//
//  FooterServiceCell.swift
//  CDYT_HoiDap
//
//  Created by Quang Anh on 8/2/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class FooterServiceCell: UITableViewCell {

    @IBOutlet weak var lbTotalService: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnDeleteAll(_ sender: Any) {
    }
}
