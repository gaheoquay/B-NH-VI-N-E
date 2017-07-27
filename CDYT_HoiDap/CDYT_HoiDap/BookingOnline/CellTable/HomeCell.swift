//
//  HomeCell.swift
//  CDYT_HoiDap
//
//  Created by Quang anh Vu on 7/24/17.
//  Copyright © 2017 CDYT. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var imgBackGround: UIImageView!
    var btnGotoDetail : (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnGotoDetail(_ sender: Any) {
        self.btnGotoDetail?()
    }
}
