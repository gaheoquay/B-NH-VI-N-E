//
//  ServiceTbCell.swift
//  CDYT_HoiDap
//
//  Created by Quang Anh on 8/2/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ServiceTbCell: UITableViewCell {

    @IBOutlet weak var lbServiceName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
