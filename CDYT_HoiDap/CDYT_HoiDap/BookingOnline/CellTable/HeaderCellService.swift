//
//  HeaderCellService.swift
//  CDYT_HoiDap
//
//  Created by Quang Anh on 8/2/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class HeaderCellService: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderColor = UIColor.brown.cgColor
        mainView.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnAddNewService(_ sender: Any) {
    }
}
