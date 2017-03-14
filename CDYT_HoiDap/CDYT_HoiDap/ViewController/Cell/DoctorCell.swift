//
//  DoctorCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 14/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class DoctorCell: UITableViewCell {
    
    @IBOutlet weak var lbNameDoctor: UILabel!
    @IBOutlet weak var lbUnAnwser: UILabel!
    @IBOutlet weak var lbApproved: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
