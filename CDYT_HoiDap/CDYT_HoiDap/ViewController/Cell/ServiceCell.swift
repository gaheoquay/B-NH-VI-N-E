//
//  ServiceCell.swift
//  CDYT_HoiDap
//
//  Created by QuangAnh on 27/03/2017.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {
    
    @IBOutlet weak var lbCombo: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var viewShowDetail: UIView!
    @IBOutlet weak var tbListServiceDetail: UITableView!
    @IBOutlet weak var imgShowDetail: UIImageView!
    @IBOutlet weak var lbShowDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnSelect(_ sender: Any) {
        
    }
    
    
}
